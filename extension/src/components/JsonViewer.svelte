<script lang='ts'>
  import JSONTree from 'svelte-json-tree';

  export let data;

  type ViewMode = 'parsed' | 'source' | 'formatted';
  let mode: ViewMode = 'parsed';

  const isValidJson = (raw) => {
    try {
      JSON.parse(raw);
      return true;
    } catch {
      return false;
    }
  };
</script>

{#if isValidJson(data)}
  {#if mode === 'parsed'}
    <button on:click={() => (mode = 'source')} class='pb-2 hover:text-gray-600'>view source</button>
    <div style='--json-tree-font-family: "Hiragino Kaku Gothic ProN", sans-serif; --json-tree-font-size: 0.7rem;'>
      <JSONTree value={JSON.parse(data)} />
    </div>
  {:else if mode === 'source'}
    <button on:click={() => (mode = 'parsed')} class='pb-2 hover:text-gray-600'>view parsed</button>
    <button on:click={() => (mode = 'formatted')} class='pb-2 pl-1 hover:text-gray-600'>view formatted</button>
    <p>{JSON.stringify(JSON.parse(data))}</p>
  {:else if mode === 'formatted'}
    <button on:click={() => (mode = 'parsed')} class='pb-2 hover:text-gray-600'>view parsed</button>
    <button on:click={() => (mode = 'source')} class='pb-2 pl-1 hover:text-gray-600'>view source</button>
    <pre class='text-sm font-pre'>{JSON.stringify(JSON.parse(data), null, 2)}</pre>
  {/if}
{:else}
  <p>{data}</p>
{/if}
