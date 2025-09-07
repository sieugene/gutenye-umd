```
  const ocr = await window.GutenyeOCR.default.create({
        models: {
          detectionPath: '/ocr/ch_PP-OCRv4_det_infer.onnx',
          recognitionPath: '/ocr/ch_PP-OCRv4_rec_infer.onnx',
          dictionaryPath: "/ocr/ppocr_keys_v1.txt"
        }
      });
```


Next.js Cdn script
```
    <Script
        src="/ocr/ocr-browser.umd.js"
        strategy="afterInteractive"
        onLoad={handleScriptsLoaded}
      />

```


dicts
https://gitee.com/paddlepaddle/PaddleOCR/tree/release/2.2/ppocr/utils/dict