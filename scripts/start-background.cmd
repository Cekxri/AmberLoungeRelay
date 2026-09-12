@echo off
cd /d "%~dp0.."

if not exist "proxy.mjs" (
    echo [ERROR] proxy.mjs not found. Run this from the project folder.
    pause
    exit /b 1
)

if not exist "logs" mkdir "logs"
set "CC_STREAM_IDLE_MS=300000"
set "CC_NONSTREAM_IDLE_MS=300000"

powershell -NoProfile -Command "$p = Start-Process -FilePath 'node' -ArgumentList 'proxy.mjs' -WorkingDirectory '%~dp0..' -WindowStyle Hidden -RedirectStandardOutput '%~dp0..\logs\relay.log' -RedirectStandardError '%~dp0..\logs\relay.err.log' -PassThru; $p.Id | Set-Content -LiteralPath '%~dp0..\logs\relay.pid'; Write-Output ('Amber Lounge Relay is open in the background ~ PID ' + $p.Id)"

echo.
echo Log file: %~dp0..\logs\relay.log
echo To close the bar, run scripts\stop.cmd
ping -n 4 127.0.0.1 >nul
