import { fail, redirect, type Actions } from '@sveltejs/kit'
import type { PageServerLoad } from './$types'

export const load = (async ({ locals: { supabase, getSession } }) => {
  const session = await getSession()

  if (!session) {
    throw redirect(303, '/')
  }

  const { data: schemas, error } = await supabase
    .from('specs')
    .select(
      'id, name, description, version, schema_url, domains (name), owner_id'
    )
    .is('deleted_at', null)

  if (error) {
    console.log(error)
    fail(500, { error: error.message })
  }

  return { session, schemas }
}) satisfies PageServerLoad

export const actions = {
  signout: async ({ locals: { supabase, getSession } }) => {
    const session = await getSession()
    if (!session) {
      throw redirect(303, '/')
    }

    await supabase.auth.signOut()
    throw redirect(303, '/')
  }
} satisfies Actions
