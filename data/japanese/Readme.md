# Download models
 https://paddleocr.bj.bcebos.com/PP-OCRv3/multilingual/Multilingual_PP-OCRv3_det_infer.tar⁠
 https://paddleocr.bj.bcebos.com/PP-OCRv4/multilingual/japan_PP-OCRv4_rec_infer.tar⁠
 https://paddleocr.bj.bcebos.com/dygraph_v2.0/ch/ch_ppocr_mobile_v2.0_cls_infer.tar⁠


# Build
docker build -t paddle2onnx .

# Run (auto-converts + fixes detector)
docker run -it -v $(pwd):/workspace paddle2onnx
