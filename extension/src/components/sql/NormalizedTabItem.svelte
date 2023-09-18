<script>
  import { TabItem, Table, TableBody, TableBodyCell, TableBodyRow, TableHead, TableHeadCell } from 'flowbite-svelte';

  export let sql;
  export let sqlSubPanesHeight;
  export let openNormalizedRows;
  export let toggleNormalizedRow;
</script>

<TabItem title='NORMALIZED' class='[&>button]:!p-3'>
  <div class='overflow-auto' style='height: {sqlSubPanesHeight}'>
    <Table hoverable>
      <TableHead>
        <TableHeadCell>Statement</TableHeadCell>
        <TableHeadCell>Count</TableHeadCell>
        <TableHeadCell>Duration(ms)</TableHeadCell>
      </TableHead>
      <TableBody>
        {#if sql !== undefined}
          {#each sql.normalizedAggregations as normalized, idx}
            <TableBodyRow on:click={() => toggleNormalizedRow(idx)}>
              <TableBodyCell>{normalized.statement}</TableBodyCell>
              <TableBodyCell>{normalized.count}</TableBodyCell>
              <TableBodyCell>{normalized.duration}</TableBodyCell>
            </TableBodyRow>
            {#if openNormalizedRows.has(idx)}
              <TableBodyRow>
                <TableBodyCell colspan='4' class='p-2'>
                  <Table class='p-2'>
                    <TableHead>
                      <TableHeadCell>Statement</TableHeadCell>
                      <TableHeadCell>Backtrace</TableHeadCell>
                      <TableHeadCell>Duration(ms)</TableHeadCell>
                    </TableHead>
                    <TableBody>
                      {#each sql.queries.filter((query) => sql.crudAggregations[idx].queryIds.includes(query.id)) as query}
                        <TableBodyRow>
                          <TableBodyCell>{query.statement}</TableBodyCell>
                          <TableBodyCell>{query.backtrace}</TableBodyCell>
                          <TableBodyCell>{query.duration}</TableBodyCell>
                        </TableBodyRow>
                      {/each}
                    </TableBody>
                  </Table>
                </TableBodyCell>
              </TableBodyRow>
            {/if}
          {/each}
        {/if}
      </TableBody>
    </Table>
  </div>
</TabItem>
