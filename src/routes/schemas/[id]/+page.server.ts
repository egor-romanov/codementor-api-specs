import { fail, redirect } from '@sveltejs/kit'
import type { PageServerLoad } from './$types'

export const load = (async ({
  locals: { supabase, getSession },
  params: { id }
}) => {
  const session = await getSession()

  if (!session) {
    throw redirect(303, '/')
  }

  const { data: schema, error } = await supabase
    .from('specs')
    .select(
      'id, name, description, version, schema_url, domains (name), owner_id'
    )
    .eq('id', id)
    .single()

  if (error) {
    console.log(error)
    throw fail(400, { error: error.message })
  }
  if (!schema) {
    throw fail(404, { error: 'Schema not found' })
  }

  const { data: storageResp, error: storageErr } = await supabase.storage
    .from('specs')
    .createSignedUrl(schema?.schema_url, 60 * 5)

  if (storageErr) {
    console.log(storageErr)
    throw fail(400, { error: storageErr.message })
  }

  schema.schema_url = storageResp?.signedUrl

  return { session, schema }
}) satisfies PageServerLoad
