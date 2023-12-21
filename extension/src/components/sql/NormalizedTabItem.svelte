<script lang="ts">
  import { TabItem, Table, TableBody, TableBodyCell, TableBodyRow, TableHead, TableHeadCell } from 'flowbite-svelte';
  import QueryTable from './QueryTable.svelte';
  import type { NormalizedAggregationSchema, QuerySchema, SqlSchema } from '../../api/Api';
  import type { OpenRowsType, SortType } from '../../types';
  import { compFunc } from '../../utils/sort';

  export let queries: QuerySchema[];
  export let normalizedAggregations: NormalizedAggregationSchema[];
  export let sqlSubPanesHeight: string;
  export let openNormalizedRows: OpenRowsType;
  export let setOpenNormalizedRows: (id: number) => (key?: string) => void;
  export let normalizedSort: SortType;
  export let setNormalizedSort: (key: string) => void;
  $: normalizedAggregations = normalizedAggregations.sort(compFunc(normalizedSort));

  const extractQueries = (
    normalized: NormalizedAggregationSchema,
    sortKey: string,
    sortDirection: number,
  ): QuerySchema[] =>
    queries
      .filter((query) => normalized.queryIds.includes(query.id))
      .sort((a, b) => (a[sortKey] > b[sortKey] ? sortDirection : -sortDirection));
</script>

<TabItem title="NORMALIZED" class="[&>button]:!p-3">
  <div class="overflow-auto" style="height: {sqlSubPanesHeight}">
    <Table hoverable class="min-w-[50em]  table-fixed">
      <TableHead>
        <TableHeadCell class="w-8/12" on:click={() => setNormalizedSort('statement')}>Statement</TableHeadCell>
        <TableHeadCell class="w-2/12" on:click={() => setNormalizedSort('count')}>Count</TableHeadCell>
        <TableHeadCell class="w-2/12" on:click={() => setNormalizedSort('duration')}>Duration</TableHeadCell>
      </TableHead>
      <TableBody>
        {#each normalizedAggregations as normalized}
          <TableBodyRow
            on:click={() => setOpenNormalizedRows(normalized.id)()}
            class={openNormalizedRows.hasOwnProperty(normalized.id) ? 'bg-primary-100 hover:bg-primary-100' : ''}
          >
            <TableBodyCell class="whitespace-normal break-words">{normalized.statement}</TableBodyCell>
            <TableBodyCell class="whitespace-normal break-words">{normalized.count}</TableBodyCell>
            <TableBodyCell class="whitespace-normal break-words">{normalized.duration}</TableBodyCell>
          </TableBodyRow>
          <!--eslint-disable-next-line no-prototype-builtins-->
          {#if openNormalizedRows.hasOwnProperty(normalized.id)}
            <TableBodyRow>
              <TableBodyCell colspan="4" class="p-2">
                <QueryTable
                  setSort={setOpenNormalizedRows(normalized.id)}
                  queries={extractQueries(
                    normalized,
                    openNormalizedRows[normalized.id].key,
                    openNormalizedRows[normalized.id].direction,
                  )}
                />
              </TableBodyCell>
            </TableBodyRow>
          {/if}
        {/each}
      </TableBody>
    </Table>
  </div>
</TabItem>
