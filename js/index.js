const worker = new Worker(WORKER_PATH);

const app = Elm.Main.init({
    node: document.getElementById('elm'),
});

const ADD = 'add';
const PRIME = 'is_prime';

async function run() {
    worker.onmessage = function(e) {
        let [func, ans] = e.data;
        if (func === ADD) {
            app.ports.revAdd.send(ans);
        } else if (func === PRIME) {
            app.ports.revPrime.send(ans);
        }
    };
    app.ports.sendAdd.subscribe(args => worker.postMessage([ADD, args]));
    app.ports.sendPrime.subscribe(args => worker.postMessage([PRIME, [args]]));

}

run().catch(console.error);
