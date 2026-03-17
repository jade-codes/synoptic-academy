# ============================================================
# Synoptic Academy - Push Docs to GitHub (PowerShell)
# Uploads all markdown files in the docs/ folder to the repo
#
# USAGE:
# 1. Place this script in the same folder as your docs/ directory
# 2. In PowerShell: Unblock-File .\push-docs.ps1
# 3. Then: .\push-docs.ps1
# ============================================================

$GITHUB_USER = gh api user --jq ".login"
$REPO = "$GITHUB_USER/synoptic-academy"

Write-Host ""
Write-Host "Pushing docs to $REPO" -ForegroundColor Cyan
Write-Host ""

$docsPath = Join-Path $PSScriptRoot "docs"

if (-not (Test-Path $docsPath)) {
    Write-Host "ERROR: docs/ folder not found at $docsPath" -ForegroundColor Red
    Read-Host "Press Enter to close"
    exit 1
}

$files = Get-ChildItem -Path $docsPath -Filter "*.md"

if ($files.Count -eq 0) {
    Write-Host "ERROR: No .md files found in docs/" -ForegroundColor Red
    Read-Host "Press Enter to close"
    exit 1
}

Write-Host "Found $($files.Count) docs to push:" -ForegroundColor Yellow
foreach ($f in $files) { Write-Host "  - $($f.Name)" }
Write-Host ""

foreach ($file in $files) {
    $remotePath = "docs/$($file.Name)"
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($content)
    $encoded = [Convert]::ToBase64String($bytes)

    Write-Host "Pushing $($file.Name)..." -ForegroundColor Yellow

    # Check if file already exists (need SHA to update)
    $existing = $null
    try {
        $existing = gh api repos/$REPO/contents/$remotePath 2>$null | ConvertFrom-Json
    } catch {}

    if ($existing -and $existing.sha) {
        # Update existing file
        $body = @{
            message = "Update $($file.Name)"
            content = $encoded
            sha     = $existing.sha
        } | ConvertTo-Json

        $body | gh api repos/$REPO/contents/$remotePath --method PUT --input - | Out-Null
        Write-Host "  Updated: $remotePath" -ForegroundColor Green
    } else {
        # Create new file
        $body = @{
            message = "Add $($file.Name)"
            content = $encoded
        } | ConvertTo-Json

        $body | gh api repos/$REPO/contents/$remotePath --method PUT --input - | Out-Null
        Write-Host "  Created: $remotePath" -ForegroundColor Green
    }

    Start-Sleep -Milliseconds 500
}

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " All docs pushed!" -ForegroundColor Green
Write-Host " https://github.com/$REPO/tree/main/docs" -ForegroundColor White
Write-Host "============================================================"
Write-Host ""
Read-Host "Press Enter to close"
