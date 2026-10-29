// supabase/functions/invite-staff/index.ts
// Ajoute ou crée un membre dans l'équipe du commerce.
// Si le compte Baobabe existe, l'associe. S'il n'existe pas, crée le compte et le profil.
import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const CORS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}
const VALID_ROLES = ['owner', 'manager', 'staff', 'kitchen']

serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: CORS })

  try {
    const { businessId, email, role, name, phone } = await req.json()
    if (!businessId || !email || !role) return err('businessId, email et role sont requis', 400)
    if (!VALID_ROLES.includes(role)) return err('Rôle invalide', 400)

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

    // Vérifie que le demandeur est owner ou manager actif
    const { data: caller } = await svc
      .from('business_staff')
      .select('role')
      .eq('business_id', businessId)
      .eq('user_id', user.id)
      .eq('status', 'active')
      .single()

    if (!caller || !['owner', 'manager'].includes(caller.role)) {
      return err('Accès réservé aux propriétaires et gérants', 403)
    }

    if (caller.role === 'manager' && role === 'owner') {
      return err('Un gérant ne peut pas attribuer le rôle de propriétaire', 403)
    }

    const normalizedEmail = email.toLowerCase().trim()
    let target = null
    let page = 1
    const perPage = 100
    while (true) {
      const { data: listRes, error: listErr } = await svc.auth.admin.listUsers({ page, perPage })
      if (listErr || !listRes?.users || listRes.users.length === 0) break
      target = listRes.users.find((u) => u.email?.toLowerCase() === normalizedEmail)
      if (target) break
      if (listRes.users.length < perPage) break
      page++
    }

    // Si le compte n'existe pas encore, on le crée automatiquement
    if (!target) {
      const displayName = (name && name.trim().length > 0) ? name.trim() : normalizedEmail.split('@')[0]
      const { data: newUser, error: createAuthErr } = await svc.auth.admin.createUser({
        email: normalizedEmail,
        email_confirm: true,
        user_metadata: { name: displayName, phone: phone || '' },
      })
      if (createAuthErr || !newUser?.user) {
        return err(`Impossible de créer le compte : ${createAuthErr?.message ?? 'Erreur inconnue'}`, 400)
      }
      target = newUser.user

      // Insertion du profil dans public.users
      await svc.from('users').upsert({
        id: target.id,
        name: displayName,
        phone: phone || null,
      })
    }

    // Vérifie qu'il n'est pas déjà dans l'équipe
    const { data: existing } = await svc
      .from('business_staff')
      .select('id')
      .eq('business_id', businessId)
      .eq('user_id', target.id)
      .single()

    if (existing) return err('Cette personne fait déjà partie de votre équipe', 400)

    // Insère dans l'équipe
    const { data: inserted, error: insErr } = await svc
      .from('business_staff')
      .insert({ business_id: businessId, user_id: target.id, role, status: 'active' })
      .select('id')
      .single()

    if (insErr) return err(insErr.message, 400)

    console.log(`[invite-staff] user=${target.id} role=${role} business=${businessId}`)
    return ok({ data: inserted })
  } catch (e) {
    console.error('[invite-staff]', e)
    return err('Erreur inattendue. Réessayez.', 500)
  }
})

const ok = (body: unknown) =>
  new Response(JSON.stringify(body), { headers: { ...CORS, 'Content-Type': 'application/json' } })

const err = (message: string, status: number) =>
  new Response(JSON.stringify({ error: message }), { status, headers: { ...CORS, 'Content-Type': 'application/json' } })
