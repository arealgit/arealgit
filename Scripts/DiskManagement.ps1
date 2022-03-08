Get-WmiObject Win32_logicaldisk -ComputerName RemoteComputerName | Select-Object @{Name="Drive";E={$_.DeviceID}},
@{Name="Size(GB)";E={[math]::Round($_.size/1gb)}},
@{Name="Free Space(GB)";E={[math]::Round($_.freespace/1gb)}},
@{Name="%Free Space";E={"{0:N2}" -f (($_.freespace/$_.size)*100)}}