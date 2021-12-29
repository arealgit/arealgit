if (Get-Module -ListAvailable -Name AzureAD) {
    Write-Host "Module exists"
} 
else {
    Install-Module AzureAD
}