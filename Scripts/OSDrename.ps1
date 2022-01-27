$SerialNumber = (Get-WmiObject -Class Win32_BIOS | Select-Object SerialNumber).SerialNumber

$Chassis = Get-WmiObject win32_systemenclosure | select-object -expandproperty chassistypes
$ChassisCode = ""

switch ($Chassis)
{
2 { $ChassisCode = "W"}
3 { $ChassisCode = "W"}
4 { $ChassisCode = "W"}
5 { $ChassisCode = "W"}
6 { $ChassisCode = "W"}
7 { $ChassisCode = "W"}
8 { $ChassisCode = "L"}
9 { $ChassisCode = "L"}
10 { $ChassisCode = "L"}
}

$OSDComputerName = "CR-" + $ChassisCode + $SerialNumber

Rename-Computer -ComputerName $env:computername -NewName $OSDComputerName
