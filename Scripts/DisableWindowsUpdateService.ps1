$LocalSrv = Get-WmiObject Win32_service -filter "name='wuauserv'"
$LocalSrv.Change($null,$null,$null,$null,$null,$false,".\Guest","$null")
Set-Service wuauserv -StartupType Disabled
Stop-Service wuauserv