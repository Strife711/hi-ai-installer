# hi-ai-installer
Installs the hi-ai assistant on Zorin OS 17.2 with OpenAI integration, command execution, and self-repair logic.
This installer script sets up the hi-ai assistant for Zorin OS 17.2.

✅ Key Features:
- Creates a Python virtual environment to avoid pip system conflicts (PEP 668 compliant)
- Installs `openai==0.28` to avoid breaking changes in newer versions
- Automatically fixes pip installation issues on Zorin and Debian-based systems
- Prompts user for their own OpenAI API key at first launch (no key hardcoded)
- Installs dependencies including: openai, termcolor, tqdm, and more
- Installs `hi-ai` launcher to /usr/local/bin so it can be used globally
- Full ChatGPT-powered assistant that can run Linux commands and self-repair using GPT feedback

📦 Installer filename:
`hi-ai-installer-zorin-20250413.sh`

🧠 Usage:
```bash
cd ~/Downloads
chmod +x hi-ai-installer-zorin-20250413.sh
./hi-ai-installer-zorin-20250413.sh
hi-ai
