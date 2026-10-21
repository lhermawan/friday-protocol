<#
.SYNOPSIS
    FRIDAY-PROTOCOL: One-Line OWASP ZAP Baseline DAST Runner for Windows
.DESCRIPTION
    Runs automated containerized dynamic application security testing (DAST)
    against a target URL and produces an HTML vulnerability report.
.EXAMPLE
    .\run-zap-baseline.ps1 -TargetUrl "http://localhost:8000"
#>

[CmdletBinding()]
param (
    [string]$TargetUrl = "http://localhost:8000",
    [string]$ReportFile = "zap-baseline-report.html"
)

$ErrorActionPreference = "Stop"
$OutputDir = Join-Path (Get-Location) "reports\security"

if (!(Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

Write-Host "====================================================================" -ForegroundColor Cyan
Write-Host "🛡️ FRIDAY-PROTOCOL DAST Scanner (OWASP ZAP Baseline - Windows)" -ForegroundColor Yellow
Write-Host "Target  : $TargetUrl"
Write-Host "Report  : $OutputDir\$ReportFile"
Write-Host "====================================================================" -ForegroundColor Cyan

# Replace localhost/127.0.0.1 with host.docker.internal for container networking
$DockerTarget = $TargetUrl.Replace("localhost", "host.docker.internal").Replace("127.0.0.1", "host.docker.internal")

# Run ZAP container
docker run --rm `
  -v "${OutputDir}:/zap/wrk/:rw" `
  zaproxy/zap-stable `
  zap-baseline.py -t "$DockerTarget" -r "$ReportFile" -I

Write-Host "====================================================================" -ForegroundColor Green
Write-Host "✅ DAST Scan Completed! Report saved to: $OutputDir\$ReportFile" -ForegroundColor Green
Write-Host "====================================================================" -ForegroundColor Green
