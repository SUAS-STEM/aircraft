$ErrorActionPreference = "Stop"

Write-Host "SUAS@STEM Ground Control Software Dependency Installer"
Write-Host "------------------------------------------------------"
Write-Host "The installer will download dependecies and build tools"
Write-Host "into the extern/ folder as necessary. This will take "
Write-Host "some time, depending on your Internet speed."
Write-Host "Downloaded dependecies are retained when installed. To"
Write-Host "fully reinstall, simply delete the extern/ folder."

$externDir = Join-Path (Get-Location) "extern"
New-Item -ItemType Directory -Path $externDir -Force | Out-Null

if (-not (Get-Command cmake -ErrorAction SilentlyContinue)) {
    Write-Host "Installing CMake..."
    winget install --id Kitware.CMake -e --source winget
    $env:Path += ";C:\Program Files\CMake\bin"
} else {
    Write-Host "CMake already installed."
}

if (-not (Get-Command cl -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Visual Studio Build Tools..."
    
    winget install --id Microsoft.VisualStudio.2022.BuildTools -e --source winget `
        --override "--quiet --wait --norestart --nocache `
        --add Microsoft.VisualStudio.Workload.VCTools `
        --add Microsoft.VisualStudio.Component.Windows11SDK.22621"
} else {
    Write-Host "MSVC Build Tools already installed."
}

$mavsdkPath = Join-Path $externDir "mavsdk"

if (-not (Test-Path $mavsdkPath)) {
    Write-Host "Downloading MAVSDK..."
    
    $url = "https://github.com/mavlink/MAVSDK/releases/latest/download/mavsdk-windows-x64.zip"
    $zipPath = "$env:TEMP\mavsdk.zip"

    if (Test-Path $zipPath) { Remove-Item $zipPath -Force }

    Invoke-WebRequest -Uri $url -OutFile $zipPath

    Expand-Archive -Path $zipPath -DestinationPath $mavsdkPath -Force

    Remove-Item $zipPath -Force
}

$opencvPath = Join-Path $externDir "opencv"

if (-not (Test-Path $opencvPath)) {
    Write-Host "Downloading OpenCV..."

    $releaseInfo = Invoke-RestMethod -Uri "https://api.github.com/repos/opencv/opencv/releases/latest"
    $latestTag = $releaseInfo.tag_name

    $opencvExe = "$env:TEMP\opencv-windows.exe"

    if (Test-Path $opencvExe) { Remove-Item $opencvExe -Force }

    $url = "https://github.com/opencv/opencv/releases/download/$latestTag/opencv-$latestTag-windows.exe"
    Write-Host "Fetching OpenCV $latestTag from $url"
    Invoke-WebRequest -Uri $url -OutFile $opencvExe
    Start-Process -FilePath $opencvExe -ArgumentList "-o`"$externDir`"", "-y" -Wait -NoNewWindow
    Remove-Item $opencvExe -Force
} else {
    Write-Host "OpenCV already present."
}

$jsonPath = Join-Path $externDir "json"

if (-not (Test-Path $jsonPath)) {
    Write-Host "Installing nlohmann::json (header-only)..."

    New-Item -ItemType Directory -Path $jsonPath -Force | Out-Null

    $url = "https://github.com/nlohmann/json/releases/latest/download/json.hpp"
    $outFile = Join-Path $jsonPath "json.hpp"

    Invoke-WebRequest -Uri $url -OutFile $outFile
} else {
    Write-Host "nlohmann::json already present."
}
