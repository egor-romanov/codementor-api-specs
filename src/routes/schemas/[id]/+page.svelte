<script lang="ts">
  import type { PageData } from './$types'

  export let data: PageData
  import html from './swagger.html?raw'

  $: doc = html.replace('%openapi_spec_file%', data.schema?.schema_url)
</script>

<hgroup>
  <h1>{data.schema.name} .{data.schema?.version}</h1>
</hgroup>

<div class="content" style="height: 70vh">
  <iframe title="openapi" class="block" style="height: 100%;" srcdoc={doc} />
</div>

<style>
  iframe {
    border: none;
  }
</style>
