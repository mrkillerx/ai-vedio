#!/bin/bash

echo "🚀 Setting up Hunyuan Video AI in /workspace ..."

cd /workspace || exit 1

# Clone repo only if not exists
if [ ! -d "/workspace/HunyuanVideo-Avatar" ]; then
    git clone https://github.com/Tencent-Hunyuan/HunyuanVideo-Avatar.git
fi

cd /workspace/HunyuanVideo-Avatar || exit 1

# Install dependencies
sudo apt-get update
sudo apt-get install -y git ffmpeg curl python3.10 python3.10-venv python3.10-distutils

# Install pip
curl -sS https://bootstrap.pypa.io/get-pip.py | python3.10

# Install Python packages
python3.10 -m pip install --upgrade pip
python3.10 -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
python3.10 -m pip install -r requirements.txt gradio

# Download model weights (if not already done)
if [ ! -f "checkpoints/hunyuan_v2.safetensors" ]; then
    echo "📦 Downloading model files..."
    python3.10 scripts/download_models.py
fi

# Start Gradio server
echo "✅ Setup done. Access UI at http://<your-ip>:7860"
python3.10 app.py --listen --port 7860
