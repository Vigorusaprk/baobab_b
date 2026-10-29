// supabase/functions/get-staff/index.ts
// Retourne la liste du personnel d'un commerce (réservé owner et manager).
import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const CORS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: CORS })

  try {
    const url = new URL(req.url)
    const businessId = url.searchParams.get('businessId')
    if (!businessId) return err('businessId requis', 400)

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

    // Vérifie le rôle du demandeur
    const { data: caller } = await svc
      .from('business_staff')
      .select('role')
      .eq('business_id', businessId)
      .eq('user_id', user.id)
      .eq('status', 'active')
      .maybeSingle()

    const role = caller?.role?.toLowerCase()
    if (!role || !['owner', 'manager'].includes(role)) {
      return err('Accès réservé aux propriétaires et gérants', 403)
    }

    // Récupère les membres
    const { data: rows, error: rowsErr } = await svc
      .from('business_staff')
      .select('*')
      .eq('business_id', businessId)

    if (rowsErr) return err(rowsErr.message, 400)

    const data = await Promise.all((rows ?? []).map(async (row) => {
      const { data: profile } = await svc
        .from('users')
        .select('*')
        .eq('id', row.user_id)
        .maybeSingle()

      const { data: authRes } = await svc.auth.admin.getUserById(row.user_id)
      const uMeta = authRes?.user?.user_metadata
      const name = profile?.name ?? profile?.full_name ?? uMeta?.name ?? uMeta?.full_name ?? authRes?.user?.email?.split('@')[0] ?? null
      const phone = profile?.phone ?? uMeta?.phone ?? authRes?.user?.phone ?? null

      return {
        id: row.id,
        user_id: row.user_id,
        role: row.role,
        status: row.status ?? 'active',
        invited_at: row.invited_at ?? row.created_at ?? null,
        name,
        phone,
        email: authRes?.user?.email ?? null,
      }
    }))

    return ok({ data })
  } catch (e) {
    console.error('[get-staff]', e)
    return err('Erreur inattendue. Réessayez.', 500)
  }
})

const ok = (body: unknown) =>
  new Response(JSON.stringify(body), { headers: { ...CORS, 'Content-Type': 'application/json' } })

const err = (message: string, status: number) =>
  new Response(JSON.stringify({ error: message }), { status, headers: { ...CORS, 'Content-Type': 'application/json' } })
