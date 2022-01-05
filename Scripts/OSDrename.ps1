$SerialNumber = (Get-WmiObject -Class Win32_BIOS | Select-Object SerialNumber).SerialNumber
$OSDComputerName = "Contoso-" + $SerialNumber

Rename-Computer -ComputerName $env:computername -NewName $OSDComputerName
