# Gemini Agent for Windows

A one-click launcher for Google's [Gemini CLI](https://github.com/google-gemini/gemini-cli) on Windows. It checks the setup, signs you in and starts the agent, so you don't have to do it by hand in a terminal.

## What it does

1. Checks that Node.js is installed. If it isn't, it opens the Node.js download page.
2. Installs Gemini CLI with npm if it is missing.
3. On the first run asks how to sign in: a Google account in the browser (recommended) or a Google AI Studio API key.
4. Starts Gemini CLI with `--skip-trust --approval-mode yolo`, so the agent edits files and runs commands without asking for approval each time (Gemini CLI calls this "yolo" mode).

Settings are kept in `config.json` next to the launcher, so the folder can be moved to another PC.

## Run

1. Download `GeminiAgent_v1.0.zip` from [Releases](https://github.com/Grollex/Gemini-Agent-Windows/releases).
2. Unzip it and run `GeminiAgent.exe`.

You need Windows 10 or 11, Node.js, and a Google account or a free API key from [Google AI Studio](https://aistudio.google.com/app/apikey).

## Good to know

- YOLO mode means the agent can change files and run commands without confirmation. Start it in a folder you are fine with it touching.
- If you choose the API key option, the key is stored in plain text in `config.json`. Don't share the folder with the key inside.
- `GeminiAgent.exe` is a small C# wrapper (`GeminiAgent.cs`) that starts `GeminiAgent.ps1`, which does the actual work.

## По-русски

Лаунчер Gemini CLI для Windows в один клик: проверяет Node.js, ставит Gemini CLI, помогает войти (Google-аккаунт или API-ключ) и запускает агента в режиме без подтверждений. Скачайте ZIP из [Releases](https://github.com/Grollex/Gemini-Agent-Windows/releases), распакуйте и запустите `GeminiAgent.exe`.
