# GitHub Push Helper Script
# This script prepares your files and provides instructions for GitHub upload

Write-Host "🚀 GitHub Push Helper for Responsible Betting Advisor" -ForegroundColor Green
Write-Host "Repository: https://github.com/shaythegay13/serenitypocketai" -ForegroundColor Blue
Write-Host ""

# Check if files exist
$files = @("index.html", "README.md", "VERSION.txt")
$missingFiles = @()

foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "✅ Found: $file" -ForegroundColor Green
    } else {
        Write-Host "❌ Missing: $file" -ForegroundColor Red
        $missingFiles += $file
    }
}

if ($missingFiles.Count -eq 0) {
    Write-Host ""
    Write-Host "🎉 All files ready for GitHub!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📋 Quick Upload Steps:" -ForegroundColor Cyan
    Write-Host "1. Open your browser to: https://github.com/shaythegay13/serenitypocketai" -ForegroundColor White
    Write-Host "2. Click the 'Upload files' button" -ForegroundColor White
    Write-Host "3. Drag and drop these files:" -ForegroundColor White
    foreach ($file in $files) {
        Write-Host "   - $file" -ForegroundColor Yellow
    }
    Write-Host "4. Add commit message: 'Add Responsible Betting Advisor v1.1.0 with enhanced sports organization and duplicate prevention'" -ForegroundColor White
    Write-Host "5. Click 'Commit changes'" -ForegroundColor White
    Write-Host ""
    Write-Host "📦 Alternative: Use the ZIP file we created earlier" -ForegroundColor Gray
    Write-Host "File: serenitypocketai_v1.1.0.zip" -ForegroundColor Gray
    Write-Host ""
    Write-Host "✨ Features you're pushing:" -ForegroundColor Magenta
    Write-Host "   • Enhanced sports organization with league/association grouping" -ForegroundColor Cyan
    Write-Host "   • Duplicate game prevention in dropdown" -ForegroundColor Cyan
    Write-Host "   • Real sports API integration with fallback" -ForegroundColor Cyan
    Write-Host "   • Advanced emotional psychology analysis" -ForegroundColor Cyan
    Write-Host "   • Professional dark UI theme maintained" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "❌ Please ensure all files are present before uploading" -ForegroundColor Red
    Write-Host "Missing files: $($missingFiles -join ', ')" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Ready to push! 🚀" -ForegroundColor Green