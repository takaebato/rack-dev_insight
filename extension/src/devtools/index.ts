import '../app.css';
import DevtoolsPanel from '../components/DevtoolsPanel.svelte';

const target = <Element>document.getElementById('app');

chrome.devtools.panels.create('Rack analyzer', 'src/favicon.png', 'src/devtools/index.html', (_panel) => {
  // code invoked on panel creation
});

async function render() {
  // eslint-disable-next-line no-new
  new DevtoolsPanel({ target, props: {} });
}

document.addEventListener('DOMContentLoaded', render);
