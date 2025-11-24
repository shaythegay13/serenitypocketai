# PowerShell Script to Prepare Files for GitHub Push
# This script creates a ZIP file with your code for easy upload to GitHub

Write-Host "🚀 Preparing Responsible Betting Advisor for GitHub Push" -ForegroundColor Green
Write-Host "Repository: https://github.com/shaythegay13/serenitypocketai.git" -ForegroundColor Blue

# Create a temporary directory for packaging
$tempDir = "$env:TEMP\serenitypocketai_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

Write-Host "📁 Created temporary directory: $tempDir" -ForegroundColor Yellow

# Copy the main application file
$sourceFile = ".\index.html"
$destFile = "$tempDir\index.html"

if (Test-Path $sourceFile) {
    Copy-Item -Path $sourceFile -Destination $destFile -Force
    Write-Host "✅ Copied index.html to package" -ForegroundColor Green
    
    # Create a README file with project information
    $readmeContent = @'
# Responsible Betting Advisor

An AI-powered betting advisor with real-time sports data integration and emotional psychology analysis.

## Features

### 🏈 Enhanced Sports Organization
- Sports properly categorized by league/association with visual indicators
- 9+ sports coverage: NFL, NBA, MLB, NHL, Soccer, Tennis, MMA/UFC, Boxing, Golf
- Clear league grouping helps users identify betting locations

### 🎯 Duplicate Game Prevention
- Set-based filtering prevents duplicate games in dropdown
- Clean game selection without repetition

### 🤖 Dual-Agent AI Analysis
- **Analytical Agent**: Technical betting analysis, EV considerations, statistical factors
- **Safety Agent**: Harm reduction, emotional psychology, risk assessment
- **Unified Recommendation**: Combined analysis with confidence scoring

### 💡 Emotional Psychology Analysis
- Advanced emotional state detection
- Betting slip parsing for risk patterns
- Recovery recommendations based on emotional triggers
- Chasing behavior identification

### 📊 Real Sports Data Integration
- Live sportsbook API integration
- Comprehensive mock data fallback system
- Auto-population of game data, team records, injuries, weather

## How to Use

1. **Select Sport**: Choose from organized sports categories
2. **Pick Current Game**: Games automatically populate without duplicates
3. **Enter Bet Details**: Amount, type, teams, emotional state
4. **Get AI Analysis**: Receive comprehensive betting recommendation
5. **Review Safety Check**: Understand risk factors and harm reduction advice

## Technical Details

- **API Integration**: Sportsbook API with RapidAPI integration
- **Frontend**: Vanilla HTML/CSS/JavaScript with professional dark theme
- **AI Analysis**: Client-side dual-agent system with emotional psychology
- **Data Sources**: Real sports data with comprehensive fallback databases

## Risk Assessment

The system evaluates:
- Financial risk (bet size vs budget percentage)
- Emotional risk (current emotional state, recent outcomes)
- Game factors (injuries, weather, team records)
- Behavioral patterns (chasing, frequency, emotional triggers)

## Recommendations

Recommendations include:
- **PLACE BET**: Low risk scenario with favorable conditions
- **DON'T PLACE BET**: High risk due to emotional/financial factors
- **PROCEED WITH CAUTION**: Moderate risk requiring careful consideration

---

*This advisor is informational and does not provide financial advice. Always gamble responsibly.*
'@
    
    Set-Content -Path "$tempDir\README.md" -Value $readmeContent
    Write-Host "✅ Created README.md" -ForegroundColor Green
    
    # Create a version info file
    $versionInfo = @"
Version: 1.1.0
Date: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
Changes:
- Enhanced sports organization with league/association grouping
- Implemented duplicate game prevention
- Added comprehensive emotional psychology analysis
- Integrated real sports API with fallback system
- Expanded sports coverage to 9+ categories
"@
    
    Set-Content -Path "$tempDir\VERSION.txt" -Value $versionInfo
    Write-Host "✅ Created version info" -ForegroundColor Green
    
    # Create ZIP file
    $zipFile = ".\serenitypocketai_v1.1.0.zip"
    Compress-Archive -Path "$tempDir\*" -DestinationPath $zipFile -Force
    
    Write-Host "🎉 Package created successfully!" -ForegroundColor Green
    Write-Host "📦 ZIP file: $zipFile" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Next Steps:" -ForegroundColor Cyan
    Write-Host "1. Go to: https://github.com/shaythegay13/serenitypocketai" -ForegroundColor White
    Write-Host "2. Click 'Upload files'" -ForegroundColor White
    Write-Host "3. Drag and drop the ZIP file contents" -ForegroundColor White
    Write-Host "4. Add commit message and push" -ForegroundColor White
    Write-Host ""
    Write-Host "Alternative: Extract ZIP and upload individual files" -ForegroundColor Gray
    
    # Clean up temp directory
    Remove-Item -Path $tempDir -Recurse -Force
    
} else {
    Write-Host "❌ index.html not found in current directory" -ForegroundColor Red
    Write-Host "Make sure you're in the correct directory" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Script completed! 🚀" -ForegroundColor Green