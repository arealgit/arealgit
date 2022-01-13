<#
.SYNOPSIS
Runs dsregcmd with the status switch and parses the output to return a hash table of the Device State.

.DESCRIPTION
Runs dsregcmd with the status switch and parses the string output to return a dsregcmd object.

.EXAMPLE
Get-DeviceState | Where-Object {$_.AzureAdJoined -eq 'True'}
#>

function Get-DeviceState() {
    $DeviceState = New-Object PSObject
    $Status = dsregcmd /status
    $AADjoined = $Status | Select-String "AzureAdJoined"
    $EnterpriseJoined = $Status | Select-String "EnterpriseJoined"
    $DomainJoined = $Status | Select-String "DomainJoined"
    $DomainName = $Status | Select-String "DomainName" | Out-String
    $DeviceName = $Status | Select-String "Device Name" | Out-String

    if($AADjoined -match "YES") {
        Add-Member -InputObject $DeviceState -MemberType NoteProperty -Name AzureADJoined -Value $true
        } else {
            Add-Member -InputObject $DeviceState -MemberType NoteProperty -Name AzureADJoined -Value $false
            }

    if($EnterpriseJoined -match "YES") {
        Add-Member -InputObject $DeviceState -MemberType NoteProperty -Name EnterpriseJoined -Value $true
        } else {
            Add-Member -InputObject $DeviceState -MemberType NoteProperty -Name EnterpriseJoined -Value $false
            }

    if($DomainJoined -match "YES") {
        Add-Member -InputObject $DeviceState -MemberType NoteProperty -Name DomainJoined -Value $true
        } else {
            Add-Member -InputObject $DeviceState -MemberType NoteProperty -Name DomainJoined -Value $false
            }

    if($DomainName) {
        Add-Member -InputObject $DeviceState -MemberType NoteProperty -Name DomainName -Value $DomainName.Trim().TrimStart("DomainName : ")
        }

    Add-Member -InputObject $DeviceState -MemberType NoteProperty -Name DeviceName -Value ($DeviceName.Trim() -replace "Device Name : ",'')

    Return $DeviceState
    }
 
