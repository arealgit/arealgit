#Prepare session
Set-ExecutionPolicy Bypass -Force

#Install Azure Active Directory PowerShell module for Graph
Install-Module AzureAD

#Import Azure Active Direcotry module
Import-Module AzureAD

#Connect to Azure AD
$AzureAdCred = Get-Credential
Connect-AzureAD -Credential $AzureAdCred