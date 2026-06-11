# Gemini CLI Autonomous Agent - Core Script
$ErrorActionPreference = 'Continue'
$InstallDir = $PSScriptRoot
$ConfigPath = Join-Path $InstallDir "config.json"

# Set Console encoding to UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   Gemini CLI Autonomous Agent v1.0       " -ForegroundColor White -BackgroundColor Blue
Write-Host "==========================================" -ForegroundColor Cyan

# 1. Check Node.js
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "[!] Node.js is NOT installed!" -ForegroundColor Yellow
    Write-Host "[*] This agent requires Node.js to function."
    Write-Host "[*] Opening download page... Please install Node.js and restart this app." -ForegroundColor Cyan
    Start-Process "https://nodejs.org/en/download/"
    Write-Host "`nPress any key to exit..."
    $null = [Console]::ReadKey()
    exit
}

# 2. Check/Install Gemini CLI
if (-not (Get-Command gemini -ErrorAction SilentlyContinue)) {
    Write-Host "[*] Gemini CLI not found globally. Installing..." -ForegroundColor Cyan
    npm install -g @google/gemini-cli@latest
    if (-not $?) {
        Write-Host "[ERROR] Failed to install Gemini CLI. Please check your internet connection." -ForegroundColor Red
        pause
        exit
    }
}

# 3. Authentication
if (-not (Test-Path $ConfigPath)) {
    Write-Host "`n[ AUTHENTICATION REQUIRED ]" -ForegroundColor Green
    Write-Host "How would you like to authenticate?"
    Write-Host "1) Google Account Login (Browser popup - recommended)"
    Write-Host "2) API Key (For headless or restricted environments)"
    
    $choice = Read-Host "Enter Choice [1 or 2]"
    
    if ($choice -eq "2") {
        Write-Host "`nYou can get a FREE API Key here: https://aistudio.google.com/app/apikey" -ForegroundColor Gray
        $key = Read-Host "Paste your Google AI Studio API Key"
        if ($key) {
            $config = @{ "GOOGLE_API_KEY" = $key }
            $config | ConvertTo-Json | Out-File $ConfigPath -Encoding utf8
            Write-Host "[+] API Key saved to config.json" -ForegroundColor Green
        } else {
            Write-Host "[!] No API key provided. Falling back to Google Login." -ForegroundColor Yellow
            gemini login
            @{ "AUTH_TYPE" = "google_login" } | ConvertTo-Json | Out-File $ConfigPath -Encoding utf8
        }
    } else {
        Write-Host "[*] Launching Google Login via browser..." -ForegroundColor Cyan
        gemini login
        @{ "AUTH_TYPE" = "google_login" } | ConvertTo-Json | Out-File $ConfigPath -Encoding utf8
    }
}

# 4. Load Auth if using API Key
if (Test-Path $ConfigPath) {
    $config = Get-Content $ConfigPath | ConvertFrom-Json
    if ($config.GOOGLE_API_KEY) {
        $env:GOOGLE_API_KEY = $config.GOOGLE_API_KEY
        Write-Host "[INFO] Using API Key authentication." -ForegroundColor Gray
    } else {
        Write-Host "[INFO] Using Google Account authentication." -ForegroundColor Gray
    }
}

# 5. Launch the Agent
Write-Host "`n[+] Starting Gemini CLI in YOLO Mode..." -ForegroundColor Green
Write-Host "------------------------------------------" -ForegroundColor Gray

# We run with --skip-trust and --yolo for maximum autonomy
gemini --skip-trust --approval-mode yolo

if ($LASTEXITCODE -ne 0) {
    Write-Host "`n[!] Gemini CLI exited with code $LASTEXITCODE" -ForegroundColor Red
    Write-Host "If this was a crash, try running 'gemini login' again."
    pause
}
