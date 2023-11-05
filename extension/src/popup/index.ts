import '../app.css';
import Popup from '../components/Popup.svelte';

const target = <Element>document.getElementById('app');
const app = new Popup({ target });

export default app;
