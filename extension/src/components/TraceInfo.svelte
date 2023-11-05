<script lang='ts'>
  import { buildPathInfo, isEditorSet } from '../utils/link.ts';
  import type { TraceInfoSchema } from '../api/Api.ts';

  export let traceInfo: TraceInfoSchema;
</script>

{#if isEditorSet()}
  {@const pathInfo = buildPathInfo(traceInfo.original, traceInfo.path, traceInfo.line)}
  <a href={pathInfo.link} target='_blank'
     class='hover:text-gray-500'>{pathInfo.display}</a><br />
{:else}
  <p>{traceInfo.original}</p>
{/if}
