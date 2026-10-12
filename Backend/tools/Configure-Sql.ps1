$ErrorActionPreference='Stop'
$taskRoot=Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$taskConnectionString='Server=localhost;Database=ToeicReadingDB;Integrated Security=True;Encrypt=True;TrustServerCertificate=True;Connect Timeout=8;'
$taskConnection=[System.Data.SqlClient.SqlConnection]::new($taskConnectionString)
try { $taskConnection.Open(); Write-Host 'Connected to local ToeicReadingDB using the current Windows account.' }
finally { $taskConnection.Dispose() }
foreach($taskProject in @('MyCompany.MyProject.Web.Mvc','MyCompany.MyProject.Web.Host','MyCompany.MyProject.Migrator')) {
  $taskFile=Join-Path $taskRoot "Backend/aspnet-core/src/$taskProject/appsettings.Local.json"
  if(Test-Path $taskFile){
    $taskSettings=Get-Content $taskFile -Raw|ConvertFrom-Json
    $taskSettings.ConnectionStrings.Default=$taskConnectionString
  }else { $taskSettings=@{ConnectionStrings=@{Default=$taskConnectionString}} }
  $taskSettings|ConvertTo-Json -Depth 10|Set-Content $taskFile -Encoding utf8
}
Write-Host 'Configuration saved. No database outside ToeicReadingDB was accessed; no migration run by this script.'
