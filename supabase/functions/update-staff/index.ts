// supabase/functions/update-staff/index.ts
// Modifie le rôle ou le statut d'un membre.
import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const CORS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}
const VALID_ROLES = ['owner', 'manager', 'staff', 'kitchen']
const VALID_STATUSES = ['active', 'suspended']

serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: CORS })

  try {
    const { staffId, role, status } = await req.json()
    if (!staffId) return err('staffId est requis', 400)
    if (role && !VALID_ROLES.includes(role)) return err('Rôle invalide', 400)
    if (status && !VALID_STATUSES.includes(status)) return err('Statut invalide', 400)

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

    // Cible
    const { data: target } = await svc
      .from('business_staff')
      .select('*')
      .eq('id', staffId)
      .maybeSingle()

    if (!target) return err('Membre introuvable', 404)

    // Demandeur
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

    if (caller.role === 'manager') {
      if (target.role === 'owner') return err('Un gérant ne peut pas modifier un propriétaire', 403)
      if (role === 'owner') return err('Un gérant ne peut pas attribuer le rôle propriétaire', 403)
    }

    if (target.user_id === user.id && role && role !== target.role) {
      return err('Vous ne pouvez pas modifier votre propre rôle', 403)
    }

    // Dernier owner actif ?
    if (target.role === 'owner' && (role && role !== 'owner' || status === 'suspended')) {
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

    const updates: Record<string, string> = {}
    if (role) updates.role = role
    if (status) updates.status = status

    const { data: updated, error: updErr } = await svc
      .from('business_staff')
      .update(updates)
      .eq('id', staffId)
      .select()
      .single()

    if (updErr) return err(updErr.message, 400)
    return ok({ data: updated })
  } catch (e) {
    console.error('[update-staff]', e)
    return err('Erreur inattendue. Réessayez.', 500)
  }
})

const ok = (body: unknown) =>
  new Response(JSON.stringify(body), { headers: { ...CORS, 'Content-Type': 'application/json' } })

const err = (message: string, status: number) =>
  new Response(JSON.stringify({ error: message }), { status, headers: { ...CORS, 'Content-Type': 'application/json' } })
