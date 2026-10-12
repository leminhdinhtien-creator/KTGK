$ErrorActionPreference='Stop'
$taskRoot=Split-Path $PSScriptRoot -Parent
$taskDotnet=Join-Path $taskRoot '.runtime/dotnet9/dotnet.exe'
if(!(Test-Path $taskDotnet)) { $taskDotnet=(Get-Command dotnet).Source }
Set-Location (Join-Path $taskRoot 'Backend/aspnet-core/src/MyCompany.MyProject.Web.Mvc')
$env:ASPNETCORE_ENVIRONMENT='Development'
& $taskDotnet run --no-launch-profile --urls http://0.0.0.0:5100
