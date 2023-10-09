<script>
  import { TabItem, Table, TableBody, TableBodyCell, TableBodyRow, TableHead, TableHeadCell } from 'flowbite-svelte';
  import QueryTable from './QueryTable.svelte';

  export let sql;
  export let sqlSubPanesHeight;
  export let openNormalizedRows;
  export let normalizedSort;

  const setOpenNormalizedRows = (id) => (key) => {
    if (key) {
      if (key === openNormalizedRows[id].sortKey) {
        if (openNormalizedRows[id].sortDirection === 1) {
          openNormalizedRows[id].sortDirection = -1;
        } else {
          openNormalizedRows[id].sortKey = 'id';
          openNormalizedRows[id].sortDirection = 1;
        }
      } else {
        openNormalizedRows[id].sortKey = key;
        openNormalizedRows[id].sortDirection = 1;
      }
    } else {
      openNormalizedRows.hasOwnProperty(id) ? delete openNormalizedRows[id] : openNormalizedRows[id] = { sortKey: 'id', sortDirection: 1 };
    }
    openNormalizedRows = openNormalizedRows;
  };

  const setNormalizedSort = (key) => {
    if (key === normalizedSort.key) {
      if (normalizedSort.direction === 1) {
        normalizedSort.direction = -1;
      } else {
        normalizedSort.key = 'id';
        normalizedSort.direction = 1;
      }
    } else {
      normalizedSort.key = key;
      normalizedSort.direction = 1;
    }
    normalizedSort = normalizedSort;
  };

  const extractQueries = (sql, normalized, sortKey, sortDirection) =>
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
          {#each sql.normalizedAggregations.sort((a, b) => a[normalizedSort.key] > b[normalizedSort.key] ? normalizedSort.direction : -normalizedSort.direction) as normalized}
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
                    queries={extractQueries(sql, normalized, openNormalizedRows[normalized.id].sortKey, openNormalizedRows[normalized.id].sortDirection)}
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
