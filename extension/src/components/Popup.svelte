<script lang='ts'>
  import { Radio } from 'flowbite-svelte';

  let editor = localStorage.getItem('rack-analyzer.editor') || '';
  $: {
    localStorage.setItem('rack-analyzer.editor', editor);
  }
</script>

<div class='p-5'>
  <p class='mb-4 font-semibold text-gray-900 dark:text-white'>Editor integration</p>
  <ul
    class='w-48 bg-white border border-gray-200 dark:bg-gray-800 dark:border-gray-600 divide-y divide-gray-200 dark:divide-gray-600'>
    <li>
      <Radio class='p-3' bind:group={editor} value='rubymine'>RubyMine</Radio>
    </li>
    <li>
      <Radio class='p-3' bind:group={editor} value='vscode'>Visual Studio Code</Radio>
    </li>
    <li>
      <Radio class='p-3' bind:group={editor} value='textmate'>TextMate</Radio>
    </li>
    <li>
      <Radio class='p-3' bind:group={editor} value='sublime'>Sublime</Radio>
    </li>
    <li>
      <Radio class='p-3' bind:group={editor} value='atom'>Atom</Radio>
    </li>
    <li>
      <Radio class='p-3' bind:group={editor} value='emacs'>Emacs</Radio>
    </li>
    <li>
      <Radio class='p-3' bind:group={editor} value='macvim'>MacVim</Radio>
    </li>
  </ul>
</div>
