<#
.SYNOPSIS
Sets the OSDComputerName task sequence variable of a MEMC or MDT task sequence based on a device's operating system, chassis, and serial number.

.DESCRIPTION
Sets the OSDComputerName task sequence variable of a MEMC or MDT task sequence based on a device's operating system, chassis, and serial number. To be used in a MDT or MEMC operating system deployment task sequence.

.EXAMPLE
.\OSDrename.ps1 
Device name will be prefixed with CR- then coded for Operating System (X for Windows 10), then coded for chassis type (VM for virtual machine, L for laptop or W for desktop), and suffixed by it's serial number.

.NOTES
Version 1.0
#>

[string]$OperatingSystem = Get-WmiObject -class Win32_OperatingSystem | Select-Object -Property Caption -ExpandProperty Caption
[string]$SerialNumber = Get-WmiObject -Class Win32_BIOS | Select-Object -Property SerialNumber -ExpandProperty SerialNumber
[string]$Model = Get-WMIObject Win32_ComputerSystem | Select-Object -Property Model -ExpandProperty Model
[string]$Chassis = Get-WmiObject win32_systemenclosure | Select-Object -ExpandProperty chassistypes

If ($Model -contains "Virtual Machine") {$ChassisCode = "VM"} else {
    switch ($Chassis)
        {
        2 { $ChassisCode = "W" break}
        3 { $ChassisCode = "W" break}
        4 { $ChassisCode = "W" break}
        5 { $ChassisCode = "W" break}
        6 { $ChassisCode = "W" break}
        7 { $ChassisCode = "W" break}
        8 { $ChassisCode = "L" break}
        9 { $ChassisCode = "L" break}
        10 { $ChassisCode = "L" break}
        }
    }

switch ($OperatingSystem) {
    "Microsoft Windows 10 Enterprise" {$OperatingSystemCode = "X" break}
}

$OSDComputerName = "CR-" + $OperatingSystemCode + $ChassisCode + $SerialNumber

if ($OSDComputerName.length -gt 15) {
    $OSDComputerName = $OSDComputerName.subString(0,14)
    $OSDComputerName = $OSDComputerName -replace '[-]',''
}

$TSEnv = New-Object -COMObject Microsoft.SMS.TSEnvironment 
$TSEnv.Value("OSDComputerName") = "$OSDComputerName"