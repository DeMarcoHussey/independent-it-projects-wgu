# Network-Diagnostics.ps1 — Connectivity & Wi-Fi Check (Enhanced)
$LogDir  = "C:\Support"
$LogFile = Join-Path $LogDir ("network_log_{0}.txt" -f (Get-Date -Format "yyyyMMdd_HHmmss"))

if (!(Test-Path $LogDir)) { New-Item -ItemType Directory -Path $LogDir | Out-Null }

"=== Network Diagnostics ==="            | Tee-Object -FilePath $LogFile
"Timestamp: $(Get-Date -Format o)"       | Tee-Object -FilePath $LogFile -Append
"Computer: $env:COMPUTERNAME"            | Tee-Object -FilePath $LogFile -Append
"User: $env:USERNAME"                    | Tee-Object -FilePath $LogFile -Append
"------------------------------------"   | Tee-Object -FilePath $LogFile -Append

# 1) IP configuration
"IPCONFIG /ALL"                          | Tee-Object -FilePath $LogFile -Append
ipconfig /all                            | Tee-Object -FilePath $LogFile -Append

# 2) Default gateway reachability
$gateway = (Get-NetIPConfiguration | Where-Object {$_.IPv4DefaultGateway}).IPv4DefaultGateway.NextHop
"Default Gateway: $gateway"              | Tee-Object -FilePath $LogFile -Append
if ($gateway) {
  Test-Connection -ComputerName $gateway -Count 2 -Quiet | Out-Null
  "Gateway reachable: $?"                 | Tee-Object -FilePath $LogFile -Append
}

# 3) External connectivity (DNS + ICMP)
$hosts = @("8.8.8.8","1.1.1.1","www.microsoft.com","www.phila.gov")
"Connectivity tests:"                    | Tee-Object -FilePath $LogFile -Append
foreach ($h in $hosts) {
  try {
    $res = Test-Connection -ComputerName $h -Count 2 -ErrorAction Stop |
      Select-Object Address,ResponseTime
    "  $h`n$($res | Out-String)"         | Tee-Object -FilePath $LogFile -Append
  } catch {
    "  $h: FAILED ($($_.Exception.Message))" | Tee-Object -FilePath $LogFile -Append
  }
}

# 4) DNS resolution sanity
"DNS Resolution:"                         | Tee-Object -FilePath $LogFile -Append
try { Resolve-DnsName www.microsoft.com -ErrorAction Stop | Out-String | Tee-Object -FilePath $LogFile -Append }
catch { "  Resolve failed: $($_.Exception.Message)" | Tee-Object -FilePath $LogFile -Append }

# 5) Wi-Fi details (if wireless)
"Wi-Fi Interfaces:"                       | Tee-Object -FilePath $LogFile -Append
netsh wlan show interfaces                | Tee-Object -FilePath $LogFile -Append

# 6) Summary
"------------------------------------"    | Tee-Object -FilePath $LogFile -Append
"Summary:"                                | Tee-Object -FilePath $LogFile -Append
"  Gateway: $gateway"                     | Tee-Object -FilePath $LogFile -Append
"  Log saved to: $LogFile"                | Tee-Object -FilePath $LogFile -Append

Write-Host "Network diagnostics saved to $LogFile"
