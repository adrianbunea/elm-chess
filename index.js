import { Elm } from './src/Main.elm'

const app = Elm.Main.init({
    node: document.querySelector('main'),
    flags : { playerName : window.localStorage.getItem('playerName') ?? '' }
})

app.ports.saveStore.subscribe(function(store) {
    window.localStorage.setItem('playerName', store.playerName);
    console.log(window.localStorage);
});
