Set-CsPhoneNumberAssignment -Identity user1@contoso.com -PhoneNumber +12065551234 -PhoneNumberType CallingPlan

$loc=Get-CsOnlineLisLocation -City Vancouver
Set-CsPhoneNumberAssignment -Identity user2@contoso.com -PhoneNumber +12065551224 -PhoneNumberType CallingPlan -LocationId $loc.LocationId

Set-CsPhoneNumberAssignment -Identity user3@contoso.com -EnterpriseVoiceEnabled $true

