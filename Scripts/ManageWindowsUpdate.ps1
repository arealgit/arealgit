install-module PSWindowsUpdate
import-module PSWindowsUpdate

Get-WindowsUpdate

Install-WindowsUpdate

Add-WUServiceManager -MicrosoftUpdate

Invoke-WUJob -ComputerName $computer -Script {ipmo PSWindowsUpdate; Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot} -RunNow -Confirm:$false | Out-File "\server\share\logs\$computer-$(Get-Date -f yyyy-MM-dd)-MSUpdates.log" -Force

Get-WindowsUpdate - KBArticleID "KB5002324", "KB5002325" - Install