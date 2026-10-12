$ErrorActionPreference = 'Stop'

$destination = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'nem\scripts\images'
$repository = 'https://raw.githubusercontent.com/wyscigufa9/nem_helper/main/images'

$icons = @(
    'smokegrenade.svg',
    'flashbang.svg',
    'hegrenade.svg',
    'molotov.svg',
    'decoy.svg'
)

New-Item -ItemType Directory -Path $destination -Force | Out-Null

$failed = @()
foreach ($icon in $icons) {
    $url = "$repository/$icon"
    $path = Join-Path $destination $icon
    try {
        $tempPath = "$path.download"
        Invoke-WebRequest -Uri $url -OutFile $tempPath -UseBasicParsing
        if ((Get-Item $tempPath).Length -eq 0) { throw 'Downloaded file is empty.' }
        Move-Item -Path $tempPath -Destination $path -Force
        Write-Host "[OK] $icon" -ForegroundColor Green
    }
    catch {
        Remove-Item -Path "$path.download" -ErrorAction SilentlyContinue
        $failed += $icon
        Write-Host "[FAILED] $icon - $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`nIcons directory: $destination"
if ($failed.Count -gt 0) {
    Write-Host "Failed downloads: $($failed -join ', ')" -ForegroundColor Red
    exit 1
}
Write-Host 'All grenade icons installed successfully.' -ForegroundColor Green
