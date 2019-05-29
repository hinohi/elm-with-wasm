const rust = import('./pkg/elm_wasm_test');

async function run() {
    let wasm = await rust;
    let div = document.getElementById("ans");
    div.innerHTML = wasm.add(1, 2);
};

run();
