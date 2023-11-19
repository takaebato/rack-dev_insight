<script>
  import { Input, Label, Modal, Select, Helper } from 'flowbite-svelte';
  import Setting from './svgs/Setting.svelte';

  let editor = localStorage.getItem('rack-analyzer.editor') || '';
  let remoteRootPath = localStorage.getItem('rack-analyzer.remote-root-path') || '';
  let localRootPath = localStorage.getItem('rack-analyzer.local-root-path') || '';
  const editors = [
    { value: 'rubymine', name: 'RubyMine' },
    { value: 'vscode', name: 'Visual studio code' },
    { value: 'textmate', name: 'TextMate' },
    { value: 'sublime', name: 'Sublime' },
    { value: 'atom', name: 'Atom' },
    { value: 'emacs', name: 'Emacs' },
    { value: 'macvim', name: 'MacVim' },
  ];

  $: {
    localStorage.setItem('rack-analyzer.editor', editor);
    localStorage.setItem('rack-analyzer.remote-root-path', remoteRootPath);
    localStorage.setItem('rack-analyzer.local-root-path', localRootPath);
  }
  let isOpen = false;
  const handleOpen = () => (isOpen = !isOpen);
</script>

<Setting on:click={handleOpen} {isOpen} />
<Modal bind:open={isOpen} autoclose outsideclose size="sm">
  <h1 slot="header" class="text-xl font-medium text-gray-700">Settings</h1>
  <h3 class="!mt-0 border-b pb-3 text-base font-medium text-gray-700">Editor integration</h3>
  <Label class="!mt-4 space-y-2">
    <span>Editor to open files</span>
    <Select items={editors} bind:value={editor} />
  </Label>
  <fieldset class="!mt-4 rounded border border-solid border-gray-300 p-3">
    <legend class="text-sm"><span class="mx-1">Remote path mapping (Optional)</span></legend>
    <Label class="mb-3 space-y-2">
      <span>Local application root folder</span>
      <Input
        type="text"
        name="Local application root folder"
        placeholder="/path/to/local/app/root/folder"
        bind:value={localRootPath}
      />
      <Helper class="px-1.5 text-gray-700">
        <span
          >Tip: Even for local machines only, setting this is useful for shortening each line of the backtrace by
          displaying paths as relative.</span
        >
      </Helper>
    </Label>
    <Label class="space-y-2">
      <span>Remote application root folder</span>
      <Input
        type="text"
        name="Remote application root folder"
        placeholder="/path/to/remote/app/root/folder"
        bind:value={remoteRootPath}
      />
    </Label>
  </fieldset>
</Modal>
