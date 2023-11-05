<script lang='ts'>
  import { TabItem, Tabs } from 'flowbite-svelte';
  import CrudTabItem from './sql/CrudTabItem.svelte';
  import NormalizedTabItem from './sql/NormalizedTabItem.svelte';
  import AllTabItem from './sql/AllTabItem.svelte';
  import type { SqlSchema } from '../api/Api';
  import type { OpenRowsType, SortType } from '../types';
  import { buildRows, buildSort } from '../utils/sort';
  import ErroredTabItem from './sql/ErroredTabItem.svelte';

  export let sql: SqlSchema | undefined;
  export let sqlSubPanesHeight: string;
  export let openCrudRows: OpenRowsType;
  export let openNormalizedRows: OpenRowsType;

  let crudSort: SortType = { key: 'id', direction: 1 };
  let normalizedSort: SortType = { key: 'id', direction: 1 };
  let allSort: SortType = { key: 'id', direction: 1 };
  let erroredSort: SortType = { key: 'id', direction: 1 };

  const setOpenCrudRows = (id: number) => (key?: string): void => {
    openCrudRows = buildRows(openCrudRows, id, key);
  };
  const setCrudSort = (key: string) => {
    crudSort = buildSort(crudSort, key);
  };

  const setOpenNormalizedRows = (id: number) => (key?: string): void => {
    openNormalizedRows = buildRows(openNormalizedRows, id, key);
  };
  const setNormalizedSort = (key: string): void => {
    normalizedSort = buildSort(normalizedSort, key);
  };

  const setAllSort = (key: string): void => {
    allSort = buildSort(allSort, key);
  };

  const setErroredSort = (key: string): void => {
    erroredSort = buildSort(erroredSort, key);
  };
</script>

<TabItem open title='SQL' class='[&>button]:!p-3'>
  <Tabs contentClass='bg-white rounded-lg dark:bg-gray-800 mt-2'>
    <CrudTabItem
      {sql}
      {sqlSubPanesHeight}
      {openCrudRows}
      {setOpenCrudRows}
      {crudSort}
      {setCrudSort}
    />
    <NormalizedTabItem
      {sql}
      {sqlSubPanesHeight}
      {openNormalizedRows}
      {setOpenNormalizedRows}
      {normalizedSort}
      {setNormalizedSort}
    />
    <AllTabItem
      {sql}
      {sqlSubPanesHeight}
      {allSort}
      {setAllSort}
    />
    {#if sql !== undefined && sql.erroredQueries.length > 0 }
      <ErroredTabItem
        {sql}
        {sqlSubPanesHeight}
        {erroredSort}
        {setErroredSort}
      />
    {/if}
  </Tabs>
</TabItem>
