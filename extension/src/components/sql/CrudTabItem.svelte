<script>
  import { TabItem, Table, TableBody, TableBodyCell, TableBodyRow, TableHead, TableHeadCell } from 'flowbite-svelte';

  export let sql;
  export let sqlSubPanesHeight;
  export let openCrudRows;
  export let toggleCrudRow;
</script>

<TabItem open title='CRUD' class='[&>button]:!p-3'>
  <div class='overflow-auto' style='height: {sqlSubPanesHeight}'>
    <Table hoverable>
      <TableHead>
        <TableHeadCell>Type</TableHeadCell>
        <TableHeadCell>Table</TableHeadCell>
        <TableHeadCell>Count</TableHeadCell>
        <TableHeadCell>Duration(ms)</TableHeadCell>
      </TableHead>
      <TableBody>
        {#if sql !== undefined}
          {#each sql.crudAggregations as crud, idx}
            <TableBodyRow on:click={() => toggleCrudRow(idx)}>
              <TableBodyCell>{crud.type}</TableBodyCell>
              <TableBodyCell>{crud.table}</TableBodyCell>
              <TableBodyCell>{crud.count}</TableBodyCell>
              <TableBodyCell>{crud.duration}</TableBodyCell>
            </TableBodyRow>
            {#if openCrudRows.has(idx)}
              <TableBodyRow>
                <TableBodyCell colspan='4' class='p-2'>
                  <Table class='p-2'>
                    <TableHead>
                      <TableHeadCell>Statement</TableHeadCell>
                      <TableHeadCell>Backtrace</TableHeadCell>
                      <TableHeadCell>Duration(ms)</TableHeadCell>
                    </TableHead>
                    <TableBody>
                      {#each sql.queries.filter((query) => sql.normalizedAggregations[idx].queryIds.includes(query.id)) as query}
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
