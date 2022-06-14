Get-WmiObject -Class Win32_UserAccount

Get-LocalUser #Gets local user accounts

New-LocalUser #Creates a local user account

Remove-LocalUser #Deletes local user accounts

Rename-LocalUser #Renames a local user account

Disable-LocalUser #Disables a local user account

Enable-LocalUser #Enables a local user account

Set-LocalUser #Modifies a local user account


#Create a local user called User03
$Password = Read-Host -AsSecureString
New-LocalUser "User03" -Password $Password -FullName "Third User" -Description "User 3"
