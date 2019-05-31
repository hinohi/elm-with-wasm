const rust = import('./pkg/elm_wasm_test');

const app = Elm.Main.init({
    node: document.getElementById('elm'),
});

async function run() {
    let wasm = await rust;
    app.ports.sendAdd.subscribe(args => {
            let [a, b] = args;
            let ans = wasm.add(a, b);
            app.ports.revAdd.send(ans);
        }
    );
    app.ports.sendPrime.subscribe(args => {
            let ans = wasm.is_prime(args);
            app.ports.revPrime.send(ans);
        }
    );
}

run().catch(console.error);
