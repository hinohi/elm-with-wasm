const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const webpack = require('webpack');
const WasmPackPlugin = require("@wasm-tool/wasm-pack-plugin");

const distPath = path.resolve(__dirname, 'dist');

const WORKER_PATH = '/worker.js';


const appConfig = {
    entry: './js/index.js',
    output: {
        path: distPath,
        filename: 'index.js',
    },
    plugins: [
        new HtmlWebpackPlugin({
            template: 'index.html'
        }),
        new WasmPackPlugin({
            crateDirectory: path.resolve(__dirname, ".")
        }),
        new webpack.DefinePlugin({
            WORKER_PATH: JSON.stringify(WORKER_PATH),
        }),
    ],
    mode: 'development'
};

const workerConfig = {
    target: 'webworker',
    entry: './js/worker.js',
    output: {
        path: distPath,
        filename: 'worker.js',
    },
    mode: 'development'
};

module.exports = [appConfig, workerConfig];
