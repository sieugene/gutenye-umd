# Download models
 https://paddleocr.bj.bcebos.com/PP-OCRv3/multilingual/Multilingual_PP-OCRv3_det_infer.tar⁠
 https://paddleocr.bj.bcebos.com/PP-OCRv4/multilingual/japan_PP-OCRv4_rec_infer.tar⁠
 https://paddleocr.bj.bcebos.com/dygraph_v2.0/ch/ch_ppocr_mobile_v2.0_cls_infer.tar⁠

# Collect the image
docker build -t paddle2onnx .

# Run with mounting of the folder with models
docker run -it -v $(pwd):/workspace paddle2onnx

# Perform the conversion inside the container
paddle2onnx --model_dir ./Multilingual_PP-OCRv3_det_infer \
    --model_filename inference.pdmodel \
    --params_filename inference.pdiparams \
    --save_file ./multilingual_det_infer.onnx \
    --opset_version 11 \
    --enable_onnx_checker True

paddle2onnx --model_dir ./japan_PP-OCRv4_rec_infer \
    --model_filename inference.pdmodel \
    --params_filename inference.pdiparams \
    --save_file ./japan_rec_infer.onnx \
    --opset_version 11 \
    --enable_onnx_checker True

paddle2onnx --model_dir ./ch_ppocr_mobile_v2.0_cls_infer \
    --model_filename inference.pdmodel \
    --params_filename inference.pdiparams \
    --save_file ./ch_ppocr_mobile_v2.0_cls_infer.onnx \
    --opset_version 11 \
    --enable_onnx_checker True