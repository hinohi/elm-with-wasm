onmessage = function (e) {
    let [func, args] = e.data;
    import('../pkg/elm_wasm_test')
        .then(wasm => {
            let ans = wasm[func](...args);
            postMessage([func, ans]);
    }).catch(console.error);
};
