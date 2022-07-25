
$CollectionID = "PKISB0015B"
$Computers = Get-Content "C:\Users\anthony\Desktop\computers.txt" 

$Computers| foreach { Add-CMDeviceCollectionDirectMembershipRule -CollectionId PKISB0015B -ResourceID (Get-CMDevice -Name $_).ResourceID }