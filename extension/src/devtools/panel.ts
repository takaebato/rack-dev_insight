import '../app.css';
import DevtoolsPanel from '../components/DevtoolsPanel.svelte';

const target = <Element>document.getElementById('app');

async function render() {
  // eslint-disable-next-line no-new
  new DevtoolsPanel({ target, props: {} });
}

document.addEventListener('DOMContentLoaded', render);
