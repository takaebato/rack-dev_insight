<script lang='ts'>
  import { TabItem, Tabs } from 'flowbite-svelte';
  import CrudTabItem from './sql/CrudTabItem.svelte';
  import NormalizedTabItem from './sql/NormalizedTabItem.svelte';
  import AllTabItem from './sql/AllTabItem.svelte';

  export let sql;
  export let sqlSubPanesHeight;
  export let openCrudRows;
  export let openNormalizedRows;

  const crudSort = { key: 'id', direction: 1 };
  const normalizedSort = { key: 'id', direction: 1 };
  const allSort = { key: 'id', direction: 1 };
</script>

<TabItem open title='SQL' class='[&>button]:!p-3'>
  <Tabs style='default' contentClass='bg-white rounded-lg dark:bg-gray-800 mt-2'>
    <CrudTabItem
      {sql}
      {sqlSubPanesHeight}
      {openCrudRows}
      {crudSort}
    />
    <NormalizedTabItem
      {sql}
      {sqlSubPanesHeight}
      {openNormalizedRows}
      {normalizedSort}
    />
    <AllTabItem
      {sql}
      {sqlSubPanesHeight}
      {allSort}
    />
  </Tabs>
</TabItem>
