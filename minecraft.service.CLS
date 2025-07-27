# If you change the name of this service you will need to change all references in the other scripts to match it also!
# Changing this service name to something different will break all of the other scripts (server control, backup, etc)

[Unit]
Description=Minecraft Server Startup Service

[Service]
User=[your username here]
Group=[your group name here]
WorkingDirectory=/your/minecraft/server/location/
# Following the "/java " are the java JVM arguments. Tailor these to best suit your own configuration!
# This config is for a 32 gig system so watch out! Too much memory allocation can cause problems!
ExecStart=screen -S mc -d -m /usr/bin/java -Xms12G -Xmx12G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=16M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:+PerfDisableSharedMem -XX:SurvivorRatio=32 -XX:+UseLargePages -jar /MinecraftServer/MinecraftServers/Current/paper-1.21.4-231.jar
RestartSec=30
Restart=always
Type=forking

[Install]
WantedBy=multi-user.target
