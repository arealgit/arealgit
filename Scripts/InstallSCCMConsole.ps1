#Path should point to SCCM primary site server <install location\Tools\ConsoleSetup> or <Configuration Manager installation media>\SMSSETUP\BIN\I386

#copy the Console Setup folder to local computer
$path = ConsoleSetup

Copy-Item -Path

#Run AdminConsole.msi

ConsoleSetup.exe /q TargetDir="C:\Program Files\ConfigMgr Console" DefaultSiteServerName=MyServer.Contoso.com LangPackDir=C:\Downloads\ConfigMgr