#!/bin/bash
set -e

echo "=================================================="
echo "Starting Paddle → ONNX conversion"
echo "Dynamic shapes: [batch, 3, H, W] where H/W = dynamic"
echo "=================================================="

# Check model directories
check_dir() {
    if [ ! -d "$1" ]; then
        echo "ERROR: Directory not found: $1"
        echo "Please download and extract models first."
        exit 1
    fi
}

check_dir "./Multilingual_PP-OCRv3_det_infer"
check_dir "./japan_PP-OCRv4_rec_infer"
check_dir "./ch_ppocr_mobile_v2.0_cls_infer"

# === 1. Convert Detection Model ===
echo "Converting Detection model (PP-OCRv3)..."
paddle2onnx \
    --model_dir ./Multilingual_PP-OCRv3_det_infer \
    --model_filename inference.pdmodel \
    --params_filename inference.pdiparams \
    --save_file ./multilingual_det_infer.onnx \
    --opset_version 11 \
    --enable_onnx_checker True

# === 2. Convert Recognition Model ===
echo "Converting Recognition model (Japan PP-OCRv4)..."
paddle2onnx \
    --model_dir ./japan_PP-OCRv4_rec_infer \
    --model_filename inference.pdmodel \
    --params_filename inference.pdiparams \
    --save_file ./japan_rec_infer.onnx \
    --opset_version 11 \
    --enable_onnx_checker True

# === 3. Convert Classification Model ===
echo "Converting Classification model (CLS)..."
paddle2onnx \
    --model_dir ./ch_ppocr_mobile_v2.0_cls_infer \
    --model_filename inference.pdmodel \
    --params_filename inference.pdiparams \
    --save_file ./ch_ppocr_mobile_v2.0_cls_infer.onnx \
    --opset_version 11 \
    --enable_onnx_checker True

echo "All models converted! Now fixing detector input shape..."

# === 4. Fix Detector: Make 960x960 → dynamic x dynamic ===
python -c '
import onnx
from onnx import helper

model_path = "multilingual_det_infer.onnx"
model = onnx.load(model_path)
input_shape = model.graph.input[0].type.tensor_type.shape

changed = False
for i, dim in enumerate(input_shape.dim):
    if dim.dim_value == 960:
        dim.dim_value = 0
        dim.dim_param = ""
        print(f"  Fixed dimension {i}: 960 → dynamic")
        changed = True

if not changed:
    print("  No 960 found — already dynamic or different size")

fixed_path = "multilingual_det_infer_dynamic.onnx"
onnx.save(model, fixed_path)
print(f"  Saved fully dynamic detector: {fixed_path}")

# Verify
m = onnx.load(fixed_path)
s = [d.dim_value if d.dim_value else "dynamic" for d in m.graph.input[0].type.tensor_type.shape.dim]
print(f"  Final shape: {s}")
'

# === 5. Final Verification ===
echo "Final input shapes:"
python -c '
import onnx
files = [
    ("multilingual_det_infer_dynamic.onnx", "Detector (fixed)"),
    ("japan_rec_infer.onnx", "Recognition"),
    ("ch_ppocr_mobile_v2.0_cls_infer.onnx", "Classification")
]
for path, name in files:
    if not __import__("os").path.exists(path):
        print(f"{name}: [SKIPPED - file not found]")
        continue
    m = onnx.load(path)
    s = [d.dim_value if d.dim_value else "dynamic" for d in m.graph.input[0].type.tensor_type.shape.dim]
    print(f"{name}: {s}")
'

echo "=================================================="
echo "CONVERSION COMPLETE!"
echo "Ready models:"
ls -lh *.onnx 2>/dev/null || echo "No ONNX files found."
echo "Use 'multilingual_det_infer_dynamic.onnx' for detection (fully dynamic)"
echo "=================================================="