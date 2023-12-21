<script lang="ts">
  import { TabItem, Table, TableBody, TableBodyCell, TableBodyRow, TableHead, TableHeadCell } from 'flowbite-svelte';
  import type { ErroredQuerySchema } from '../../api/Api';
  import type { SortType } from '../../types';
  import { compFunc } from '../../utils/sort';
  import TraceInfo from '../TraceInfo.svelte';

  export let erroredQueries: ErroredQuerySchema[];
  export let sqlSubPanesHeight: string;
  export let erroredSort: SortType;
  export let setErroredSort: (key: string) => void;
  $: erroredQueries = erroredQueries.sort(compFunc(erroredSort));
</script>

<TabItem title="ERRORED" class="[&>button]:!p-3">
  <div class="overflow-auto" style="height: {sqlSubPanesHeight}">
    <Table class="min-w-[50em]  table-fixed">
      <TableHead>
        <TableHeadCell class="w-3/12" on:click={() => setErroredSort('message')}>Message</TableHeadCell>
        <TableHeadCell class="w-4/12" on:click={() => setErroredSort('statement')}>Statement</TableHeadCell>
        <TableHeadCell class="w-4/12" on:click={() => setErroredSort('backtrace')}>Backtrace</TableHeadCell>
        <TableHeadCell class="w-1/12" on:click={() => setErroredSort('duration')}>Dur.</TableHeadCell>
      </TableHead>
      <TableBody>
        {#each erroredQueries as errored}
          <TableBodyRow>
            <TableBodyCell class="whitespace-normal break-words">{errored.message}</TableBodyCell>
            <TableBodyCell class="whitespace-normal break-words">{errored.statement}</TableBodyCell>
            <TableBodyCell class="whitespace-normal break-words">
              {#each errored.backtrace as traceInfo}
                <TraceInfo {traceInfo} />
              {/each}
            </TableBodyCell>
            <TableBodyCell class="whitespace-normal break-words">{errored.duration}</TableBodyCell>
          </TableBodyRow>
        {/each}
      </TableBody>
    </Table>
  </div>
</TabItem>
