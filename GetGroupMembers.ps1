
$ADGroup = Read-Host -Prompt 'Input name of group'
$ADGroupMembers = Get-AdgroupMember $ADgroup
foreach ($member in $ADGRoupMembers {get-aduser $member.samaccountname -properties displayname | select displayname,samaccountname,name}
