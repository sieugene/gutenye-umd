import resolve from '@rollup/plugin-node-resolve';
import commonjs from '@rollup/plugin-commonjs';
import nodePolyfills from 'rollup-plugin-node-polyfills';

export default {
  input: 'node_modules/@gutenye/ocr-browser/build/index.js',
  output: {
    file: 'dist/ocr-browser.umd.js',
    format: 'umd',
    name: 'GutenyeOCR',
  },
  plugins: [resolve({ browser: true }), commonjs(), nodePolyfills()],
};
