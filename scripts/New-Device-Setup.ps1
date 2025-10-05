# New-Device-Setup.ps1 — Sample Imaging Script (Simulation)
Write-Host "=== Starting Imaging Simulation ==="
$ComputerName = "CITY-PC-" + (Get-Random -Minimum 1000 -Maximum 9999)
Write-Host "[1] Assigning Computer Name: $ComputerName"
Write-Host "[2] Installing Base Apps: Chrome, Zoom, 7-Zip"
Write-Host "[3] Checking Windows Updates (Simulated)"
Write-Host "[4] Creating Support Folder with Contact Info"
New-Item -ItemType Directory -Path "C:\Support" -ErrorAction SilentlyContinue | Out-Null
"Help Desk: helpdesk@phila.gov" | Out-File "C:\Support\README.txt"
Write-Host "=== Imaging Complete. Reboot Recommended. ==="
