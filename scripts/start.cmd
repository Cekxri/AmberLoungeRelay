@echo off
title Cider CC UwU :3
cd /d "%~dp0.."

if not exist "proxy.mjs" (
    echo [ERROR] proxy.mjs not found. Run this from the project folder.
    pause
    exit /b 1
)

set "CC_STREAM_IDLE_MS=300000"
set "CC_NONSTREAM_IDLE_MS=300000"

rem PROXY_PORT moves the relay off 3050; scripts\stop.cmd reads the same variable. :3
if defined PROXY_PORT set "PORT=%PROXY_PORT%"

echo ============================================================
echo   Cider CC UwU ~ pulling up a stool :3
echo   URL:    http://127.0.0.1:3050
echo   Models: http://127.0.0.1:3050/v1/models
echo   Stop:   close this window (or Ctrl+C)
echo ============================================================
echo.

node proxy.mjs

echo.
echo The bar is closed. Press any key to tidy up.
pause >nul
