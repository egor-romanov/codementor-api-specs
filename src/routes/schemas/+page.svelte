<script lang="ts">
  import { invalidateAll } from '$app/navigation'
  import type { PageData } from './$types'

  export let data: PageData

  let { session } = data

  // group by schema name
  function groupBySchemaName(schemas: any[]) {
    const grouped = schemas.reduce((acc, schema) => {
      const { name, ...rest } = schema
      if (!acc[name]) {
        acc[name] = [rest]
      } else {
        acc[name].push(rest)
      }
      return acc
    }, {})

    return Object.keys(grouped).map((key) => {
      return {
        name: key,
        domain: grouped[key][0].domains.name,
        versions: grouped[key].sort((a: any, b: any) => b.version - a.version)
      }
    })
  }

  // get list of domains
  function getDomains(schemas: any[]) {
    const domains = schemas.reduce((acc, schema) => {
      if (!acc.includes(schema.domains.name)) {
        acc.push(schema.domains.name)
      }
      return acc
    }, [])

    return domains
  }
</script>

<div>
  <div class="row flex-center flex">
    <div class="col-9 form-widget">
      <div>
        <!-- list of schemas from the database -->
        <h2>Schema List</h2>
        {#if data?.schemas?.length === 0}
          <p>No schemas found</p>
        {:else}
          {#each getDomains(data?.schemas ?? []) as domain}
            <h3>{domain}</h3>
            <ul>
              {#each groupBySchemaName(data?.schemas ?? []).filter((s) => s.domain === domain) as schema}
                <li>
                  <a href="/schemas/{schema.versions[0].id}"
                    >{schema.name} .v{schema.versions[0].version}</a
                  >
                  <p>
                    {schema.versions[0].description}
                  </p>
                </li>
              {/each}
            </ul>
          {/each}
        {/if}
      </div>
      <a class="button primary" href="/schemas/new">Create New Schema</a>
      <form
        method="post"
        action="?/signout"
        on:submit={async () => await invalidateAll()}
      >
        <div class="flex" style="justify-content: flex-end; padding-top: 1rem;">
          <button class="button">Sign Out</button>
        </div>
      </form>
    </div>
  </div>
</div>
