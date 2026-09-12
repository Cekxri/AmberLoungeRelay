@echo off
cd /d "%~dp0.."

powershell -NoProfile -Command "$ids = @{}; $pidPath = '%~dp0..\logs\relay.pid'; if (Test-Path -LiteralPath $pidPath) { $procId = (Get-Content -LiteralPath $pidPath -Raw).Trim(); $p = Get-Process -Id $procId -ErrorAction SilentlyContinue; if ($p -and $p.ProcessName -eq 'node') { $ids[$p.Id] = $true } }; $conns = Get-NetTCPConnection -LocalPort 3050 -State Listen -ErrorAction SilentlyContinue; foreach ($c in $conns) { $p = Get-Process -Id $c.OwningProcess -ErrorAction SilentlyContinue; if ($p -and $p.ProcessName -eq 'node') { $ids[$p.Id] = $true } }; if ($ids.Count -gt 0) { foreach ($id in $ids.Keys) { Stop-Process -Id $id -ErrorAction SilentlyContinue }; Write-Output ('Closed the bar ~ stopped: ' + (($ids.Keys) -join ', ')) } else { Write-Output 'No relay was running (nothing owns port 3050).' }; Remove-Item -LiteralPath $pidPath -ErrorAction SilentlyContinue"

ping -n 3 127.0.0.1 >nul
