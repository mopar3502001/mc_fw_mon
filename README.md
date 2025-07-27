# mc_fw_mon
Minecraft Firewall Monitor
For All Minecraft server versions (Tested on Ubuntu Server 24.04 Pro LTS)
A lightweight Bash-based firewall and service monitoring system tailored for Minecraft Java Edition servers.

**Author:** mopar3502001  
**Version:** 1.3  
**Tested on:** Ubuntu 24.04 Pro LTS

## Features

- Real-time firewall drop summary on login (via MOTD)
- Daily and monthly summaries
- Top offending IP addresses
- Port-specific intrusion breakdown (e.g., Minecraft on <CUSTOM_MC_PORT>)
- RCON access check and segmentation
- Service control script (`./server`) with options for:
  - Starting/stopping the Minecraft server
  - Accessing the console
  - Editing config files
  - Running backups
  - Viewing live/full logs
  
## Requirements

- Ubuntu with `iptables` (not `ufw`)
- `rsyslog` configured to capture kernel log entries to `/var/log/fwlog.log`
- Minecraft Java Edition server (PaperMC recommended)
- `systemd` service for Minecraft
- Optional: `screen`, `mcrcon`

## Warning

> **This tool is for advanced users only.**
> 
> - You must be familiar with managing `iptables` rules directly.
> - You must know how to configure `rsyslog`.
> - No support is provided for UFW-to-iptables migration or log forwarding.
> - This repo is provided *as-is*, with no warranty or guarantee.

## Installation

### 1. Clone the Repo
[bash]
git clone https://github.com/YOURUSERNAME/minecraft-fwlog-monitor.git
cd minecraft-fwlog-monitor

### 2. Deploy the MOTD Script
[bash]
sudo cp fwlog-summary.sh /etc/update-motd.d/99-fwlog-summary
sudo chmod +x /etc/update-motd.d/99-fwlog-summary

### 3. Deploy the Server Control Script
[bash]
sudo cp mc-server-control.sh /usr/local/bin/server
sudo chmod +x /usr/local/bin/server
```

### 4. Set Up Log Forwarding (rsyslog)
Create `/etc/rsyslog.d/fwlog.conf`:
[rsyslog]
:msg, contains, "EXTDROP" /var/log/fwlog.log
:msg, contains, "INTDROP" /var/log/fwlog.log
:msg, contains, "MC-DROP" /var/log/fwlog.log
& stop

Then:
[bash]
sudo systemctl restart rsyslog

### 5. Apply Your iptables Rules
Example:
[bash]
iptables -A INPUT -p tcp -s 10.0.0.0/24 --dport 25575 -j ACCEPT
iptables -A INPUT -p tcp --dport 25575 -j LOG --log-prefix "RCON-BLOCK: " --log-level 4
iptables -A INPUT -p tcp --dport 25575 -j DROP
iptables -A INPUT -p tcp --dport <CUSTOM_MC_PORT> -j LOG --log-prefix "MC-DROP: " --log-level 4
iptables -A INPUT -p tcp --dport <CUSTOM_MC_PORT> -j DROP
```
Then:
[bash]
sudo iptables-save > /etc/iptables/rules.v4

## Sample Output

==== Firewall Drop Summary (Today) ====
Total dropped connection attempts today: 518
 - EXTDROP: 518
 - INTDROP: 0
Top 3 Offending IPs (Today):
 <ATTACKER_IP_1> (222)
 <ATTACKER_IP_2> (192)
 <ATTACKER_IP_3> (48)
Last Intrusion Attempt (Today):
 EXTDROP: 07/27/2025 10:41:21 from <ATTACKER_IP_1>
========================================

==== Firewall Drop Summary (Monthly) ====
Total dropped connection attempts this month: 1066
 - EXTDROP: 1066
 - INTDROP: 0
Top 3 Offending IPs (Monthly):
 <ATTACKER_IP_2> (474)
 <ATTACKER_IP_1> (344)
 <ATTACKER_IP_3> (120)
Last Intrusion Attempt (Monthly):
 EXTDROP: 07/27/2025 10:41:21 from <ATTACKER_IP_1>
==========================================

### 2. Port-Specific Drop Summary (e.g., Minecraft Port)

==== Port <CUSTOM_MC_PORT> Drops (Today) ====
Dropped attempts on port <CUSTOM_MC_PORT> today: 0
Top 3 Offending IPs (Today on port <CUSTOM_MC_PORT>):
 No offenders detected.
Last Intrusion Attempt (Today on port <CUSTOM_MC_PORT>):
 None recorded
========================================

==== Port <CUSTOM_MC_PORT> Drops (Monthly) ====
Dropped attempts on port <CUSTOM_MC_PORT> this month: 0
Top 3 Offending IPs (Monthly on port <CUSTOM_MC_PORT>):
 No offenders detected.
Last Intrusion Attempt (Monthly on port <CUSTOM_MC_PORT>):
 None recorded
==========================================

## License
MIT (or specify otherwise)

---

## Contributions
PRs welcome only for documentation or portability enhancements. No support for basic iptables or syslog questions.
