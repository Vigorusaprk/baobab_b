// supabase/functions/remove-staff/index.ts
// Retire un membre du personnel.
import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const CORS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: CORS })

  try {
    const { staffId } = await req.json()
    if (!staffId) return err('staffId est requis', 400)

    const userClient = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_ANON_KEY')!,
      { global: { headers: { Authorization: req.headers.get('Authorization')! } } }
    )
    const svc = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    )

    const { data: { user } } = await userClient.auth.getUser()
    if (!user) return err('Non authentifié', 401)

    const { data: target } = await svc
      .from('business_staff')
      .select('*')
      .eq('id', staffId)
      .maybeSingle()

    if (!target) return err('Membre introuvable', 404)

    const { data: caller } = await svc
      .from('business_staff')
      .select('role')
      .eq('business_id', target.business_id)
      .eq('user_id', user.id)
      .eq('status', 'active')
      .maybeSingle()

    if (!caller || !['owner', 'manager'].includes(caller.role)) {
      return err('Accès réservé aux propriétaires et gérants', 403)
    }

    if (caller.role === 'manager' && target.role === 'owner') {
      return err('Un gérant ne peut pas retirer un propriétaire', 403)
    }

    if (target.user_id === user.id) {
      return err('Vous ne pouvez pas vous retirer vous-même de l\'équipe', 403)
    }

    if (target.role === 'owner') {
      const { count } = await svc
        .from('business_staff')
        .select('id', { count: 'exact', head: true })
        .eq('business_id', target.business_id)
        .eq('role', 'owner')
        .eq('status', 'active')

      if ((count ?? 0) <= 1) {
        return err('Le commerce doit conserver au moins un propriétaire actif', 400)
      }
    }

    const { error: delErr } = await svc
      .from('business_staff')
      .delete()
      .eq('id', staffId)

    if (delErr) return err(delErr.message, 400)
    return ok({ data: { success: true } })
  } catch (e) {
    console.error('[remove-staff]', e)
    return err('Erreur inattendue. Réessayez.', 500)
  }
})

const ok = (body: unknown) =>
  new Response(JSON.stringify(body), { headers: { ...CORS, 'Content-Type': 'application/json' } })

const err = (message: string, status: number) =>
  new Response(JSON.stringify({ error: message }), { status, headers: { ...CORS, 'Content-Type': 'application/json' } })
