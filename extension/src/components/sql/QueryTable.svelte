<script lang="ts">
  import { Table, TableBody, TableBodyCell, TableBodyRow, TableHead, TableHeadCell } from 'flowbite-svelte';
  import TraceInfo from '../TraceInfo.svelte';
  import type { QuerySchema } from '../../api/Api';

  export let setSort: (key: string) => void;
  export let queries: QuerySchema[];
</script>

<Table class="min-w-[50em]  table-fixed">
  <TableHead>
    <TableHeadCell class="w-5/12" on:click={() => setSort('statement')}>Statement</TableHeadCell>
    <TableHeadCell class="w-6/12" on:click={() => setSort('backtrace')}>Backtrace</TableHeadCell>
    <TableHeadCell class="w-1/12" on:click={() => setSort('duration')}>Dur.</TableHeadCell>
  </TableHead>
  <TableBody>
    {#each queries as query}
      <TableBodyRow>
        <TableBodyCell class="whitespace-normal break-words">
          {query.statement}
          {#if query.binds !== ''}
            <span class="pl-1.5">{query.binds}</span>
          {/if}
        </TableBodyCell>
        <TableBodyCell class="whitespace-normal break-words">
          {#each query.backtrace as traceInfo}
            <TraceInfo {traceInfo} />
          {/each}
        </TableBodyCell>
        <TableBodyCell class="whitespace-normal break-words">{query.duration}</TableBodyCell>
      </TableBodyRow>
    {/each}
  </TableBody>
</Table>
