import onnx
from onnx import helper

def make_detector_dynamic(onnx_path):
    print(f"Fixing dynamic shape for: {onnx_path}")
    model = onnx.load(onnx_path)
    
    # Find input tensor
    input_tensor = model.graph.input[0]
    shape = input_tensor.type.tensor_type.shape
    
    # Replace 960 with dynamic (empty dim_param)
    for i, dim in enumerate(shape.dim):
        if dim.dim_value == 960:
            dim.dim_value = 0
            dim.dim_param = ""  # makes it dynamic
            print(f"  -> Changed dimension {i} from 960 to 'dynamic'")
    
    # Save fixed model
    fixed_path = onnx_path.replace(".onnx", "_dynamic.onnx")
    onnx.save(model, fixed_path)
    print(f"Saved dynamic model: {fixed_path}")
    
    # Verify
    m = onnx.load(fixed_path)
    s = [d.dim_value if d.dim_value else 'dynamic' for d in m.graph.input[0].type.tensor_type.shape.dim]
    print(f"Final shape: {s}\n")
    
    return fixed_path

# Fix detector
make_detector_dynamic("multilingual_det_infer.onnx")