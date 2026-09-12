@echo off
cd /d "%~dp0.."

echo Fetching the latest pour...
git pull --ff-only
echo.
echo Done. Restart the relay to taste the new batch :3
pause >nul
