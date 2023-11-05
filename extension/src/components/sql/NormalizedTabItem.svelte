<script lang='ts'>
  import { TabItem, Table, TableBody, TableBodyCell, TableBodyRow, TableHead, TableHeadCell } from 'flowbite-svelte';
  import QueryTable from './QueryTable.svelte';
  import type { NormalizedAggregationSchema, QuerySchema, SqlSchema } from '../../api/Api';
  import type { OpenRowsType, SortType } from '../../types';
  import { buildRows, buildSort, compFunc } from '../../utils/sort';

  export let sql: SqlSchema | undefined;
  export let sqlSubPanesHeight: string;
  export let openNormalizedRows: OpenRowsType;
  export let setOpenNormalizedRows: (id: number) => (key?: string) => void;
  export let normalizedSort: SortType;
  export let setNormalizedSort: (key: string) => void;

  const extractQueries = (sql: SqlSchema, normalized: NormalizedAggregationSchema, sortKey: string, sortDirection: number): QuerySchema[] =>
    sql.queries
      .filter((query) => normalized.queryIds.includes(query.id))
      .sort((a, b) => a[sortKey] > b[sortKey] ? sortDirection : -sortDirection);
</script>

<TabItem title='NORMALIZED' class='[&>button]:!p-3'>
  <div class='overflow-auto' style='height: {sqlSubPanesHeight}'>
    <Table hoverable class='table-fixed  min-w-[50em]'>
      <TableHead>
        <TableHeadCell class='w-8/12' on:click={() => setNormalizedSort('statement')}>Statement</TableHeadCell>
        <TableHeadCell class='w-2/12' on:click={() => setNormalizedSort('count')}>Count</TableHeadCell>
        <TableHeadCell class='w-2/12' on:click={() => setNormalizedSort('duration')}>Duration</TableHeadCell>
      </TableHead>
      <TableBody>
        {#if sql !== undefined}
          {#each sql.normalizedAggregations.sort(compFunc(normalizedSort)) as normalized}
            <TableBodyRow on:click={() => setOpenNormalizedRows(normalized.id)()}>
              <TableBodyCell class='whitespace-normal break-words'>{normalized.statement}</TableBodyCell>
              <TableBodyCell class='whitespace-normal break-words'>{normalized.count}</TableBodyCell>
              <TableBodyCell class='whitespace-normal break-words'>{normalized.duration}</TableBodyCell>
            </TableBodyRow>
            {#if openNormalizedRows.hasOwnProperty(normalized.id)}
              <TableBodyRow>
                <TableBodyCell colspan='4' class='p-2'>
                  <QueryTable
                    setSort={setOpenNormalizedRows(normalized.id)}
                    queries={extractQueries(sql, normalized, openNormalizedRows[normalized.id].key, openNormalizedRows[normalized.id].direction)}
                  />
                </TableBodyCell>
              </TableBodyRow>
            {/if}
          {/each}
        {/if}
      </TableBody>
    </Table>
  </div>
</TabItem>
