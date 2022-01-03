Install-Module MSOnline
Connect-MsolService

New-MsolUser –UserPrincipalName cgodinez@M365x45438867.onmicrosoft.com -DisplayName “Cody Godinez” -FirstName “Cody” -LastName “Godinez” -Password ‘Pa55w.rd’ -ForceChangePassword $false -UsageLocation “US”
Get-MsolUser
