<script lang="ts">
  import { enhance } from '$app/forms'
  import type { ActionData, PageData, SubmitFunction } from './$types'
  import Upload from './Upload.svelte'

  export let data: PageData
  export let form: ActionData = {
    name: '',
    description: '',
    schema_url: '',
    domain_id: ''
  }

  let { session, supabase } = data

  let loading = false
  $: schemaUrl = ''
  $: domainId = ''
  $: domain = ''

  async function getDomainId(event: Event) {
    domain = (event?.target as HTMLInputElement).value ?? ''
    const { data, error } = await supabase
      .from('domains')
      .select('id')
      .eq('name', domain)
      .single()

    if (error) {
      console.log(error)
    } else {
      domainId = data.id
    }
  }
  const handleSubmit: SubmitFunction = (input) => {
    // do something before the form submits
    loading = true
    input.data.append('schema_url', schemaUrl)
    input.data.append('domain_id', domainId)

    return async ({ update }) => {
      // do something after the form submits
      loading = false
      await update()
    }
  }
</script>

<div class="form-widget">
  <form
    class="form-widget"
    method="post"
    action="?/create"
    use:enhance={handleSubmit}
  >
    <div>
      <label for="email">Email</label>
      <input id="email" type="text" value={session?.user?.email} disabled />
    </div>

    <div>
      <label for="name">Name</label>
      <input id="name" name="name" type="text" value={form?.name ?? ''} />
    </div>

    <div>
      <label for="description">Description</label>
      <input
        id="description"
        name="description"
        type="text"
        value={form?.description ?? ''}
      />
    </div>

    <div>
      <label for="domain">Domain</label>
      <select id="domain" name="domain" on:change={getDomainId} value={domain}>
        <option value="">-</option>
        <option value="rnd">RnD</option>
        <option value="auth">Auth</option>
      </select>
    </div>

    <Upload
      {supabase}
      bind:url={schemaUrl}
      size={10}
      domain={domainId}
      on:upload={(event) => {
        const path = event.detail.path
      }}
    />

    <div>
      <input
        type="submit"
        class="button block primary"
        value={loading ? 'Loading...' : 'Create'}
        disabled={loading}
      />
    </div>
  </form>
</div>
