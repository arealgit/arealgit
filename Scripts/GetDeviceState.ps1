function Get-DeviceState

<#
.SYNOPSIS
Runs dsregcmd with the status switch and parses the output to return a hash table of the Device State.

.DESCRIPTION
Runs dsregcmd with the status switch and parses the string output to return a dsregcmd object.

.EXAMPLE
GetDsRegCmdStatus | Where-Object {$_.'Device State'.AzureAdJoined -eq 'Yes'}
#>

$DeviceState = [Ordered]@{}
$Status = dsregcmd /status

$DeviceName = $Status | Select-String "Device Name"
$AADjoined = $Status | Select-String "AzureAdJoined"
$EnterpriseJoined = $Status | Select-String "EnterpriseJoined"
$DomainJoined = $Status | Select-String "DomainJoined"
if($DomainJoined) {
    $DomainName = $Status | Select-String "DomainName"
    $DomainName = $DomainName.Substring(0,10)
}


if($AADjoined -match "YES") {
    [bool]$DeviceState.AzureAdJoined = 1
    } else {[bool]$DeviceState.AzureAdJoined = 0}

if($EnterpriseJoined -match "YES") {
    [bool]$DeviceState.EnterpriseJoined = 1
    } else {[bool]$DeviceState.EnterpriseJoined = 0}

if($DomainJoined -match "YES") {
    [bool]$DeviceState.DomainJoined = 1
    } else {
        [bool]$DeviceState.DomainJoined = 0
        }

if($DomainName) {
    [string]$DeviceState.DomainName = 
    }



