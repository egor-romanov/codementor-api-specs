import { fail, redirect } from '@sveltejs/kit'
import type { Actions, PageServerLoad } from './$types'

export const load = (async ({ locals: { getSession } }) => {
  const session = await getSession()

  if (!session) {
    throw redirect(303, '/')
  }

  return { session }
}) satisfies PageServerLoad

export const actions = {
  create: async ({ request, locals: { supabase, getSession } }) => {
    const formData = await request.formData()
    const name = formData.get('name') as string
    const description = formData.get('description') as string
    const domain_id = formData.get('domain_id') as string
    const schema_url = formData.get('schema_url') as string

    const session = await getSession()

    let version = 1
    const { data: versionData, error: versionErr } = await supabase
      .from('specs')
      .select('version')
      .eq('name', name)
      .order('version', { ascending: false })
      .limit(1)

    if (versionErr) {
      return fail(500, {
        error: versionErr.message
      })
    }
    if (versionData?.length != 0) {
      version = versionData.pop()?.version + 1
    }

    const { error } = await supabase.from('specs').insert({
      owner_id: session?.user?.id,
      name,
      description,
      domain_id,
      schema_url,
      version
    })

    if (error) {
      console.log(error)
      return fail(500, {
        name,
        description,
        schema_url,
        domain_id
      })
    }

    throw redirect(303, '/schemas')
  }
} satisfies Actions
