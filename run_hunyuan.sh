#!/bin/bash

echo "🔥 Starting Hunyuan Video AI Setup..."

# Check GPU
if ! command -v nvidia-smi &> /dev/null; then
    echo "❌ NVIDIA GPU not found or drivers not installed. Exiting."
    exit 1
fi

# Update system
sudo apt update && sudo apt upgrade -y

# Install Python 3.10+ and pip
sudo apt install -y software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update
sudo apt install -y python3.10 python3.10-venv python3.10-distutils curl git ffmpeg unzip

# Set Python 3.10 as default
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.10 1
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1

# Install pip
curl -sS https://bootstrap.pypa.io/get-pip.py | sudo python3.10

# Clone the Hunyuan repo
mkdir -p ~/hunyuan
cd ~/hunyuan
git clone https://github.com/Tencent-Hunyuan/HunyuanVideo-Avatar.git app
cd app

# Install Python requirements
python3.10 -m pip install --upgrade pip
python3.10 -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
python3.10 -m pip install -r requirements.txt gradio==4.24.0

# Download model files
python3.10 scripts/download_models.py

# Start Gradio web UI
echo "✅ Setup complete. Access the web UI at http://<your-ip>:7860"
python3.10 app.py --listen --port 7860
