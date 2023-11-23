import { sprintf } from 'sprintf-js';

export const isEditorSet = (): boolean => !!localStorage.getItem('rack-dev-insight.editor');

export const buildPathInfo = (original: string, path: string, line: number): { display: string; link: string } => {
  const Links: { [key: string]: string } = {
    rubymine: 'x-mine://open?file=%s&line=%d',
    vscode: 'vscode://file%s:%d',
    textmate: 'txmt://open?url=file://%s&line=%d&column=%d',
    atom: 'atm://open?url=file://%s&line=%d&column=%d',
    sublime: 'subl://open?url=file://%s&line=%d&column=%d',
    emacs: 'emacs://open?url=file://%s&line=%d&column=%d',
    macvim: 'mvim://open?url=file://%s&line=%d&column=%d',
  };
  const editor = localStorage.getItem('rack-dev-insight.editor') || '';
  const remoteRootPath = localStorage.getItem('rack-dev-insight.remote-root-path') || '';
  const localRootPath = localStorage.getItem('rack-dev-insight.local-root-path') || '';
  let originalToDisplay = original;
  let linkPath = path;
  if (remoteRootPath) {
    originalToDisplay = original.replace(remoteRootPath, '');
    linkPath = path.replace(remoteRootPath, localRootPath);
  } else if (localRootPath) {
    originalToDisplay = original.replace(localRootPath, '');
  }

  return { display: originalToDisplay, link: sprintf(Links[editor], linkPath, line, 1) };
};
