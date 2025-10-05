# Wi-Fi Diagnostics (macOS)

**Quick reads from \wdutil info\:**
- RSSI and Noise → SNR = RSSI − Noise (≥25 dB is good; your sample ~48 dB).
- Channel/Band: prefer 5 GHz/80 MHz when possible.
- Tx Rate: rough indicator of link quality; varies with environment.

**Commands**
\\\ash
sudo wdutil info
sudo wdutil diagnose -q -f ~/Desktop/wdutil-diagnostics
sudo wdutil dump --duration 120
\\\

**What to capture in tickets**
- RSSI, Noise, SNR, Channel, Tx Rate
- Gateway ping + packet loss
- DNS resolution results
