$PSversionTable

# View execution policy
Get-ExecutionPolicy -List

# Set execution policy to Remote Signed
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine

#List All Environment Variables
gci env:* | Sort-Object Name

