$LocalSrv = Get-WmiObject Win32_service -filter "name='wuauserv'"
$LocalSrv.Change($null,$null,$null,$null,$null,$false,"LocalSystem","$null")
Set-Service wuauserv -StartupType Automatic
Start-Service wuauserv