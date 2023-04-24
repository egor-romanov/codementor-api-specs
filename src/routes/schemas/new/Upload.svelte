<script lang="ts">
  import type { SupabaseClient } from '@supabase/supabase-js'
  import { createEventDispatcher } from 'svelte'

  export let size = 10
  export let url: string
  export let domain: string
  export let supabase: SupabaseClient

  let uploading = false
  let files: FileList

  const dispatch = createEventDispatcher()

  const uploadSchema = async () => {
    try {
      uploading = true

      if (!files || files.length === 0) {
        throw new Error('You must select an API-Schema to upload.')
      }

      if (!domain) {
        throw new Error('You must select a domain first.')
      }

      const file = files[0]
      const fileExt = file.name.split('.').pop()
      url = `${domain}/${Math.floor(Math.random() * 1000000)}.${fileExt}`

      let { error, data } = await supabase.storage
        .from('specs')
        .upload(url, file)

      if (error) {
        throw error
      }

      dispatch('upload', {
        path: data?.path
      })
    } catch (error) {
      if (error instanceof Error) {
        alert(error.message)
      }
    } finally {
      uploading = false
    }
  }
</script>

<div>
  <div class="avatar no-image" style="height: {size}em; width: {size}em;" />
  <input type="hidden" name="schemaUrl" value={url} />

  <div style="width: {size}em;">
    <label class="button primary block" for="single">
      {uploading ? 'Uploading ...' : 'Upload'}
    </label>
    <input
      style="visibility: hidden; position:absolute;"
      type="file"
      id="single"
      bind:files
      on:change={uploadSchema}
      disabled={uploading}
    />
  </div>
</div>
