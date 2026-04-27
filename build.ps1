$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $repoRoot

$venvPath = Join-Path $repoRoot ".venv"
$venvPython = Join-Path $venvPath "Scripts\python.exe"
$dbtExe = Join-Path $venvPath "Scripts\dbt.exe"
$requirementsFile = Join-Path $repoRoot "requirements.txt"

function Get-PythonMajorMinor {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Command,
        [string[]]$Args = @()
    )

    try {
        $version = & $Command @($Args + @("-c", "import sys; print(f'{sys.version_info[0]}.{sys.version_info[1]}')")) 2>$null
        if ($LASTEXITCODE -eq 0 -and $version) {
            return $version.Trim()
        }
    }
    catch {
        return $null
    }

    return $null
}

function Find-CompatiblePython {
    $candidates = @(
        @{ Command = "py"; Args = @("-3.14") },
        @{ Command = "py"; Args = @("-3.13") },
        @{ Command = "py"; Args = @("-3.12") },
        @{ Command = "python3.14"; Args = @() },
        @{ Command = "python3.13"; Args = @() },
        @{ Command = "python3.12"; Args = @() },
        @{ Command = "python"; Args = @() }
    )

    foreach ($candidate in $candidates) {
        $version = Get-PythonMajorMinor -Command $candidate.Command -Args $candidate.Args
        if ($version -in @("3.14", "3.13", "3.12")) {
            return $candidate
        }
    }

    return $null
}

function Install-CompatiblePythonIfPossible {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        return $false
    }

    Write-Host "No compatible Python found. Attempting to install Python 3.13 with winget..."
    winget install --id PythonSoftwareFoundation.Python.3.13 --source winget --accept-source-agreements --accept-package-agreements --silent | Out-Host
    return $true
}

if (-not (Test-Path $requirementsFile)) {
    throw "requirements.txt was not found at $requirementsFile"
}

$python = Find-CompatiblePython
if (-not $python) {
    $attemptedInstall = Install-CompatiblePythonIfPossible
    if ($attemptedInstall) {
        $python = Find-CompatiblePython
    }
}

if (-not $python) {
    throw "Could not find a compatible Python interpreter. Install Python 3.12, 3.13, or 3.14, then re-run .\build.ps1"
}

Write-Host "Using Python launcher: $($python.Command) $($python.Args -join ' ')"

Write-Host "[1/3] Creating virtual environment..."
$needsNewVenv = -not (Test-Path $venvPython)

if (-not $needsNewVenv) {
    $venvVersion = & $venvPython -c "import sys; print(f'{sys.version_info[0]}.{sys.version_info[1]}')"
    if ($venvVersion -notin @("3.14", "3.13", "3.12")) {
        Write-Host "Existing .venv uses Python $venvVersion, recreating with Python 3.14/3.13/3.12..."
        Remove-Item -Recurse -Force $venvPath
        $needsNewVenv = $true
    }
}

if ($needsNewVenv) {
    & $python.Command @($python.Args + @("-m", "venv", $venvPath))
}

Write-Host "[2/3] Installing packages..."
& $venvPython -m pip install --upgrade pip
& $venvPython -m pip install -r $requirementsFile

$venvVersion = & $venvPython -c "import sys; print(f'{sys.version_info[0]}.{sys.version_info[1]}')"
if ($venvVersion -eq "3.14") {
    Write-Host "Applying Python 3.14 compatibility override for dbt dependency chain (mashumaro)..."
    & $venvPython -m pip install mashumaro==3.20 --no-deps
}

Write-Host "[3/3] Validating dbt installation..."
& $dbtExe --version

Write-Host "Build completed successfully."
