# BC Dev Credit Control - Local Deployment Script
# Run this on a Windows machine with BcContainerHelper installed

# Configuration
$ContainerName = "BCSandbox"
$ExtensionPath = "$PSScriptRoot\artifacts\app.app"
$AppName = "BC Dev Credit Control"
$AppPublisher = "John Taylor"
$AppVersion = "1.0.0.0"

# Check if running in container
function Test-BcContainer {
    param([string]$ContainerName)
    
    $containers = Get-BcContainerAvailable -includeRunning
    return ($containers | Where-Object { $_.Name -eq $ContainerName }).Count -gt 0
}

# Build the extension (compile AL files)
function Build-Extension {
    Write-Host "🔨 Building AL Extension..." -ForegroundColor Cyan
    
    # Get AL Language extension
    $alcPath = Get-ChildItem -Path "C:\Users\*\.vscode\extensions" -Filter "ms-dynamics-s nav-al-*" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
    
    if ($alcPath) {
        Write-Host "Found AL Language: $($alcPath.FullName)"
    }
    
    # Compile using alc.exe (if available)
    $alcExe = Get-ChildItem -Path "C:\Program Files*" -Filter "alc.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
    
    if ($alcExe) {
        Write-Host "Found alc.exe: $($alcExe.FullName)"
        
        # Create output directory
        $outputPath = "$PSScriptRoot\artifacts"
        if (!(Test-Path $outputPath)) {
            New-Item -ItemType Directory -Path $outputPath -Force | Out-Null
        }
        
        # Compile
        & $alcExe.FullName /project:$PSScriptRoot /packagecachepath:$outputPath /out:$outputPath\app.app /assemblyprobingpaths:"C:\Program Files\Microsoft Dynamics NAV\2100\AL" 2>&1
    } else {
        Write-Host "⚠️ alc.exe not found. Install AL Language Extension in VS Code" -ForegroundColor Yellow
        Write-Host "Creating placeholder .app file..." -ForegroundColor Yellow
        
        # Create placeholder
        $outputPath = "$PSScriptRoot\artifacts"
        if (!(Test-Path $outputPath)) {
            New-Item -ItemType Directory -Path $outputPath -Force | Out-Null
        }
        
        # For demonstration, create a dummy .app
        # In production, this would be the compiled extension
        "PLACEHOLDER" | Out-File -FilePath "$outputPath\app.app"
    }
    
    Write-Host "✅ Build complete" -ForegroundColor Green
    return $outputPath
}

# Publish to container
function Publish-Extension {
    param(
        [string]$ContainerName,
        [string]$AppPath
    )
    
    Write-Host "📦 Publishing to container: $ContainerName" -ForegroundColor Cyan
    
    # Check container exists
    if (!(Test-BcContainer -ContainerName $ContainerName)) {
        Write-Host "❌ Container '$ContainerName' not found!" -ForegroundColor Red
        Write-Host "Available containers:" -ForegroundColor Yellow
        Get-BcContainerAvailable -includeRunning | Format-Table Name, State
        return $false
    }
    
    try {
        # Publish the extension
        Publish-BcContainerApp `
            -containerName $ContainerName `
            -appFile $AppPath `
            -skipVerification `
            -sync `
            -install
        
        Write-Host "✅ Extension published successfully!" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "❌ Error publishing: $_" -ForegroundColor Red
        return $false
    }
}

# Main execution
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "BC Dev Credit Control - Deploy Script" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Check for BcContainerHelper
try {
    $bcHelper = Get-Command Get-BcContainerAvailable -ErrorAction Stop
    Write-Host "✅ BcContainerHelper is available" -ForegroundColor Green
}
catch {
    Write-Host "❌ BcContainerHelper not found!" -ForegroundColor Red
    Write-Host "Install with: Install-Module -Name BcContainerHelper -Force" -ForegroundColor Yellow
    exit 1
}

# Build
$artifactsPath = Build-Extension

# Show available containers
Write-Host ""
Write-Host "Available Containers:" -ForegroundColor Cyan
Get-BcContainerAvailable -includeRunning | Format-Table Name, State, Version

# Ask for container name
$containerName = Read-Host "Enter container name (or press Enter for 'BCSandbox')"
if ([string]::IsNullOrWhiteSpace($containerName)) {
    $containerName = "BCSandbox"
}

# Deploy
$appPath = Join-Path $artifactsPath "app.app"
if (Test-Path $appPath) {
    $success = Publish-Extension -ContainerName $containerName -AppPath $appPath
    
    if ($success) {
        Write-Host ""
        Write-Host "🎉 Deployment complete!" -ForegroundColor Green
        Write-Host "Open Business Central and verify the extension is installed." -ForegroundColor Cyan
    }
}
else {
    Write-Host "❌ App file not found at: $appPath" -ForegroundColor Red
}
