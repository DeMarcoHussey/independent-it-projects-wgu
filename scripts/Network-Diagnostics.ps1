# Network-Diagnostics.ps1 — Simple Connectivity & Wi-Fi Check
Write-Host "=== Network Diagnostic Script ==="
Test-Connection -ComputerName "8.8.8.8" -Count 2 | Select-Object Address, ResponseTime
if (!(Test-Path "C:\Support")) { New-Item -ItemType Directory -Path "C:\Support" | Out-Null }
ipconfig /all | Out-File "C:\Support\network_log.txt"
netsh wlan show interfaces | Out-File -Append "C:\Support\network_log.txt"
Write-Host "Network diagnostics saved to C:\Support\network_log.txt"
