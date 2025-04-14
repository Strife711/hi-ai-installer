#!/bin/bash
# ==========================================================
#  hi-ai Installer for Zorin OS 17.2
#  Author: Paul Legaspi
#  Project: Nexus OS Assistant
#  GitHub: https://github.com/Strife711/hi-ai-installer
#  Date: April 2025
# ==========================================================

echo "🧠 hi-ai Installer for Zorin OS 17.2 (by Paul Legaspi)"
echo "🔧 Installing dependencies..."

sudo apt update
sudo apt install -y python3 python3-pip python3-venv git curl

echo "💡 Creating virtual environment..."
python3 -m venv ~/.hi-ai-env
source ~/.hi-ai-env/bin/activate

echo "📦 Installing Python packages..."
~/.hi-ai-env/bin/pip install --break-system-packages --upgrade pip
~/.hi-ai-env/bin/pip install --break-system-packages openai==0.28 termcolor tqdm

echo "📁 Writing hi-ai script..."
cat << 'EOF' > ~/.hi-ai.py
#!/usr/bin/env python3
# ==========================================================
#  hi-ai Assistant Core Script
#  Author: Paul Legaspi
#  Description: Linux AI assistant with OpenAI backend
# ==========================================================

import openai
import subprocess
import os
import sys
import time
import json
from datetime import datetime

CONFIG_PATH = os.path.expanduser("~/.hi-ai-config.json")

def load_config():
    if os.path.exists(CONFIG_PATH):
        with open(CONFIG_PATH, 'r') as f:
            return json.load(f)
    return {}

def save_config(config):
    with open(CONFIG_PATH, 'w') as f:
        json.dump(config, f, indent=2)

config = load_config()
if not config.get("api_key"):
    api_key = input("🔑 Enter your OpenAI API key: ").strip()
    config["api_key"] = api_key
    save_config(config)

openai.api_key = config["api_key"]

def ask(prompt):
    try:
        response = openai.ChatCompletion.create(
            model="gpt-4",
            messages=[
                {"role": "system", "content": "You are a Linux assistant that returns Linux commands only."},
                {"role": "user", "content": prompt}
            ]
        )
        return response["choices"][0]["message"]["content"]
    except Exception as e:
        return f"❌ OpenAI Error: {e}"

def run():
    print("🧠 Nexus is online. Type anything. Type 'exit' to quit.")
    while True:
        user_input = input("[You] > ").strip()
        if user_input.lower() in ["exit", "quit"]:
            print("👋 Goodbye.")
            break
        command = ask(user_input)
        print(f"⚡ Running: {command}")
        try:
            output = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT, text=True)
            print(output)
        except subprocess.CalledProcessError as e:
            print(f"⚠️ {e.output}")

if __name__ == "__main__":
    run()
EOF

chmod +x ~/.hi-ai.py

echo "📎 Creating launcher script..."
sudo tee /usr/local/bin/hi-ai > /dev/null << 'EOF'
#!/bin/bash
# Nexus launcher - by Paul Legaspi
source /home/$USER/.hi-ai-env/bin/activate
python3 /home/$USER/.hi-ai.py
EOF

sudo chmod +x /usr/local/bin/hi-ai
sudo chown $USER:$USER /usr/local/bin/hi-ai

echo "✅ hi-ai installed. Just type: hi-ai"
