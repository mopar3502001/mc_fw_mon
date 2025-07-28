# mc_fw_mon

(Download the .ZIP to get all files in one transaction)

Minecraft Firewall Monitor, Server Control and Backup Scripts
For All Minecraft server versions (Tested on Ubuntu Server 24.04 Pro LTS)
A lightweight Bash-based firewall and service monitoring system tailored for Minecraft Java Edition servers.

**Author:** mopar3502001  
**Version:** 1.3  
**Tested on:** Ubuntu 24.04 Pro LTS

I looked around quite extensively for a MC Java server control script or program that did exactly what I wanted, and I
couldn't find what I was looking for. I wanted something that would easily allow me to edit the server properties file
or the bukkit configuration file, would allow me to make changes to them, then apply them and easily restart the server.
Also as a requirement, a very easy way to create a backup of my MC server and store it on a local network share. I also
wanted to be able to view the MC server logs "live", and have either Rcon or server console access. Also what seemed
necessary was a way to watch for bad actors trying to access my server to possibly destroy all the hard work that was put
into creating these worlds. I wanted a quick summary of nefarious activity at login, and a way to view it on demand at any
time after logging in. Thus, this package, in its state of infancy, was born. This will eventually be developed into a
full-fledged Java MC server control package with all the bells and whistles, given enough time (fail2ban, packet/port flooding
prevention, etc.) These scripts are what I created after not finding exactly what I was looking for. Hopefully someone gets
some use out of them besides me. The interest of people in this project will dictate how much will be posted to this branch.
So, if you are interested in seeing much more sophisticated scripts or binaries come from this, please be sure to let me know.
I would be excited to make a real project out of this!
# This is a work in progress. This is just something I put together to control my MC Java server without having to put much
effort into it. If enough people show interest I will put much more effort into making this into a real thing. Heck,
I would even make it into a Debian distro or w/e people need to be able to run it. If nothing else and you know your
way around IPTables, Ubuntu services, etc., this is a decent starting point for something really nice.
Let me know if you have any suggestions!

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
