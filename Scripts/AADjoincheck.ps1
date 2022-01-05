#Check if device is connected to AD or AAD
dsregcmd /status

#AD Connect Directory Sync
Start-ADSyncSyncCycle -PolicyType Initial
