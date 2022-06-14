Move-Item -Path C:\test.txt -Destination E:\Temp\tst.txt

Move-Item -Path C:\Temp -Destination C:\Logs

Move-Item -Path .\*.txt -Destination C:\Logs

Get-ChildItem -Path ".\*.txt" -Recurse | Move-Item -Destination "C:\TextFiles"

Move-Item "HKLM:\software\mycompany\*" "HKLM:\software\mynewcompany"

Move-Item -LiteralPath 'Logs[Sept`06]' -Destination 'Logs[2006]'

New-Item -Path . -Name "testfile1.txt" -ItemType "file" -Value "This is a text string."

New-Item -Path "c:\" -Name "logfiles" -ItemType "directory"

New-Item -ItemType "directory" -Path "c:\ps-test\scripts"

New-Item -ItemType "file" -Path "c:\ps-test\test.txt", "c:\ps-test\Logs\test.log"

Get-ChildItem -Path C:\Temp\

Directory:  C:\Temp

Mode                LastWriteTime     Length Name
----                -------------     ------ ----
d-----        5/15/2019   6:45 AM        1   One
d-----        5/15/2019   6:45 AM        1   Two
d-----        5/15/2019   6:45 AM        1   Three

New-Item -Path C:\Temp\* -Name temp.txt -ItemType File | Select-Object FullName

FullName
--------
C:\Temp\One\temp.txt
C:\Temp\Three\temp.txt
C:\Temp\Two\temp.txt