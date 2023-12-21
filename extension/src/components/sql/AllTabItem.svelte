<script lang="ts">
  import { TabItem } from 'flowbite-svelte';
  import QueryTable from './QueryTable.svelte';
  import type { QuerySchema } from '../../api/Api';

  export let queries: QuerySchema[];
  export let sqlSubPanesHeight: string;
  export let setAllSort: (key: string) => void;
</script>

<TabItem title="ALL" class="[&>button]:!p-3">
  <div class="overflow-auto" style="height: {sqlSubPanesHeight}">
    <QueryTable setSort={setAllSort} {queries} />
  </div>
</TabItem>
