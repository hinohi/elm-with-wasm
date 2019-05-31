const rust = import('./pkg/elm_wasm_test');

let wasm = {};

const app = Elm.Main.init({
    node: document.getElementById('elm'),
});

app.ports.send.subscribe(args => {
        let [a, b] = args;
        let ans = wasm.add(a, b);
        app.ports.rev.send(ans);
    }
);

async function run() {
    wasm = await rust;
}

run().catch(console.error);
