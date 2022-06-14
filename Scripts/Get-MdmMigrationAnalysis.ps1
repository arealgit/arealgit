Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process
$VerbosePreference="Continue"
Invoke-MdmMigrationAnalysisTool.ps1 -collectGPOReports -runAnalysisTool
