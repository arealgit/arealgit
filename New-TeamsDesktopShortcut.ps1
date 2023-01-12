If (-not (Test-Path $env:USERPROFILE\Desktop\Teams.lnk)) {

try {

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\Teams.lnk")
$Shortcut.TargetPath = "$env:USERPROFILE\AppData\Local\Microsoft\Teams\Update.exe"
$Shortcut.Arguments = '--processStart Teams.exe'
$Shortcut.WorkingDirectory = "$env:USERPROFILE\AppData\Local\Microsoft\Teams"
$Shortcut.Save()
} catch {throw $_.Exception.Message}
}
