Param (
 [Parameter(Mandatory=$true)]
 [string]$sourceWinDir,
 [Parameter(Mandatory=$true)]
 [string]$destinationWinDir
)
 
$dirs = @(
 "System32\WindowsPowerShell\v1.0\Modules\ActiveDirectory",
 "SysWOW64\WindowsPowerShell\v1.0\Modules\ActiveDirectory",
 "Microsoft.NET\assembly\GAC_32\Microsoft.ActiveDirectory.Management",
 "Microsoft.NET\assembly\GAC_32\Microsoft.ActiveDirectory.Management.Resources",
 "Microsoft.NET\assembly\GAC_64\Microsoft.ActiveDirectory.Management",
 "Microsoft.NET\assembly\GAC_64\Microsoft.ActiveDirectory.Management.Resources",
 "WinSxS\amd64_microsoft.activedir..anagement.resources_*",
 "WinSxS\amd64_microsoft.activedirectory.management_*",
 "WinSxS\msil_microsoft-windows-d..ivecenter.resources_*",
 "WinSxS\x86_microsoft.activedir..anagement.resources_*",
 "WinSxS\x86_microsoft.activedirectory.management_*"
);
$tempFileName = ([System.IO.Path]::GetTempFileName());
Write-Host "Saving acl of `"$($destinationWinDir)\WinSxS`" to `"$($tempFileName)`"";
Start-Process -FilePath icacls -ArgumentList "`"$($destinationWinDir)\WinSxS`" /save `"$($tempFileName)`"" -Wait -NoNewWindow;
Write-Host "Set administrators owner on `"$($destinationWinDir)\WinSxS`"";
Start-Process -FilePath takeown -ArgumentList "/F `"$($destinationWinDir)\WinSxS`" /A" -Wait -NoNewWindow;
Write-Host "Grant administrators full rights on `"$($destinationWinDir)\WinSxS`" with inheritance";
Start-Process -FilePath icacls -ArgumentList "`"$($destinationWinDir)\WinSxS`" /grant BUILTIN\Administrators:(F) /C /inheritance:e" -Wait -NoNewWindow;
 
$dirs | % {
 $source = "$($sourceWinDir)\$($_)";
 $destination = "$($destinationWinDir)\$($_)";
 if($_.Substring(0,6) -eq "WinSxS") {
 Get-ChildItem -Path $source | ? {$_.PSIsContainer} | % {
 Write-Host "Copying `"$($_.FullName)`" to `"$($destination | Split-Path)\$($_.Name)`"";
 $_ | Copy-Item -Destination "$($destination | Split-Path)\$($_.Name)" -Recurse;
 Write-Host "Set `"NT SERVICE\TrustedInstaller`" owner on `"$($destination | Split-Path)\$($_.Name)`" recursively";
 Start-Process -FilePath icacls -ArgumentList "`"$($destination | Split-Path)\$($_.Name)`" /setowner `"NT SERVICE\TrustedInstaller`" /T /C " -Wait -NoNewWindow;
 }
 }
 else {
 Write-Host "Copying `"$($source)`" to `"$($destination)`"";
 Copy-Item -Path $source -Destination $destination -Recurse;
 }
};
 
Write-Host "Set `"NT SERVICE\TrustedInstaller`" owner on `"$($destinationWinDir)\WinSxS`"";
Start-Process -FilePath icacls -ArgumentList "`"$($destinationWinDir)\WinSxS`" /setowner `"NT SERVICE\TrustedInstaller`" /C" -Wait -NoNewWindow;
Write-Host "Removing inheritance on `"$($destinationWinDir)\WinSxS`"";
Start-Process -FilePath icacls -ArgumentList "`"$($destinationWinDir)\WinSxS`" /C /inheritance:d" -Wait -NoNewWindow;
Write-Host "Restoring acl of `"$($destinationWinDir)\WinSxS`" from `"$($tempFileName)`"";
Start-Process -FilePath icacls -ArgumentList "`"$($destinationWinDir)`"\ /restore `"$($tempFileName)`" /C" -Wait -NoNewWindow;