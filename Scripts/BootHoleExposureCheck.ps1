<#
.SYNOPSIS
Tests whether a system is exposed to BootHole vulnerabilities, as published in Microsoft Security Advisory ADV200011. 
Looks like any computer which trusts the Microsoft Corporation UEFI CA 2011 security store is exposed.

.DESCRIPTION
This script retrieves the ASCI encoded version information from the bytes property of the object retruned by Get-SecureBootUEFI command.

.EXAMPLE
Get-BootholeExposure
>>true
#>

function Get-BootHoleExposure {
[System.Text.Encoding]::ASCII.GetString((Get-SecureBootUEFI db).bytes) -match 'Microsoft Corporation UEFI CA 2011'    
}

