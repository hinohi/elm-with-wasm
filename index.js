const rust = import('./pkg/elm_wasm_test');

const app = Elm.Main.init({
    node: document.getElementById('elm'),
});

async function run() {
    let wasm = await rust;
    app.ports.send.subscribe(args => {
            let [a, b] = args;
            let ans = wasm.add(a, b);
            app.ports.rev.send(ans);
        }
    );
}

run().catch(console.error);
