<#
.SYNOPSIS
Runs dsregcmd with the status switch and parses the output to return a hash table of the Device State.

.DESCRIPTION
Runs dsregcmd with the status switch and parses the string output to return a dsregcmd object.

.EXAMPLE
Get-DeviceState | Where-Object {$_.AzureAdJoined -eq 'True'}
#>

function Get-DeviceState {
    [PSCustomObject]$DeviceState
    $Status = dsregcmd /status
    $AADjoined = $Status | Select-String "AzureAdJoined"
    $EnterpriseJoined = $Status | Select-String "EnterpriseJoined"
    $DomainJoined = $Status | Select-String "DomainJoined"
    $DomainName = $Status | Select-String "DomainName" | Out-String
    $DeviceName = $Status | Select-String "Device Name" | Out-String

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
        [string]$DeviceState.DomainName = $DomainName.Trim().TrimStart("DomainName : ")
        }

    $DeviceState.DeviceName = $DeviceName.Trim().TrimStart('Device Name : ')
    }
