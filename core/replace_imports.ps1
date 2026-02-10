# replace_imports.ps1
# Replaces Python import references from 'homeassistant' to 'exome'
# IMPORTANT: Only replaces Python import patterns, NOT arbitrary substrings
# Run from: l:\shared F\EXOME\core
#
# Usage: powershell -ExecutionPolicy Bypass -File replace_imports.ps1

$ErrorActionPreference = "Stop"

$coreDir = "l:\shared F\EXOME\core"
$targetDir = Join-Path $coreDir "exome"
$testDir = Join-Path $coreDir "tests"
$scriptDir = Join-Path $coreDir "script"
$pylintDir = Join-Path $coreDir "pylint"

# These patterns target Python import statements and package references only.
# They avoid replacing third-party package names like 'atomicwrites-homeassistant'
# or Android app IDs like 'io.homeassistant.companion.android'
$replacements = @(
    # Python imports: from homeassistant... / import homeassistant...
    @{ Pattern = '(?m)^(\s*from\s+)homeassistant'; Replace = '${1}exome' },
    @{ Pattern = '(?m)^(\s*import\s+)homeassistant'; Replace = '${1}exome' },
    # String references to the module in code: "homeassistant.xyz" (dotted module paths)
    @{ Pattern = '"homeassistant\.'; Replace = '"exome.' },
    @{ Pattern = "'homeassistant\."; Replace = "'exome." },
    # Bare module name references in quotes
    @{ Pattern = '"homeassistant"'; Replace = '"exome"' },
    @{ Pattern = "'homeassistant'"; Replace = "'exome'" }
)

function Update-PythonFiles {
    param (
        [string]$Directory,
        [string]$Label
    )

    if (-not (Test-Path $Directory)) {
        Write-Host "Skipping $Label (not found: $Directory)"
        return
    }

    $pyFiles = Get-ChildItem -Path $Directory -Recurse -Filter "*.py" -File
    Write-Host "Found $($pyFiles.Count) .py files in $Label"

    $count = 0
    foreach ($file in $pyFiles) {
        $content = Get-Content $file.FullName -Raw
        $original = $content
        foreach ($r in $replacements) {
            $content = $content -replace $r.Pattern, $r.Replace
        }
        if ($content -ne $original) {
            Set-Content $file.FullName -Value $content -NoNewline
            $count++
        }
    }
    Write-Host "Updated $count files in $Label"
}

Write-Host "=== EXOME Import Replacement ==="
Write-Host ""

# Phase 1: Python source directories
Update-PythonFiles -Directory $targetDir -Label "exome/"
Update-PythonFiles -Directory $testDir -Label "tests/"
Update-PythonFiles -Directory $scriptDir -Label "script/"
Update-PythonFiles -Directory $pylintDir -Label "pylint/"

# Phase 2: Config files (targeted replacements only)
Write-Host ""
Write-Host "Processing config files..."

# pyproject.toml - specific lines only
$pyprojectPath = Join-Path $coreDir "pyproject.toml"
if (Test-Path $pyprojectPath) {
    $content = Get-Content $pyprojectPath -Raw
    # Package name and entry point
    $content = $content -replace 'name = "homeassistant"', 'name = "exome"'
    $content = $content -replace 'hass = "homeassistant\.__main__:main"', 'exome = "exome.__main__:main"'
    $content = $content -replace 'include = \["homeassistant\*"\]', 'include = ["exome*"]'
    $content = $content -replace 'source = \["homeassistant"\]', 'source = ["exome"]'
    # Filter warnings that reference homeassistant module paths (not third-party)
    $content = $content -replace ':homeassistant\.', ':exome.'
    Set-Content $pyprojectPath -Value $content -NoNewline
    Write-Host "Updated: pyproject.toml"
}

# mypy.ini
$mypyPath = Join-Path $coreDir "mypy.ini"
if (Test-Path $mypyPath) {
    $content = Get-Content $mypyPath -Raw
    # Module paths in mypy config
    $content = $content -replace '\[mypy-homeassistant\.', '[mypy-exome.'
    $content = $content -replace 'homeassistant\.', 'exome.'
    Set-Content $mypyPath -Value $content -NoNewline
    Write-Host "Updated: mypy.ini"
}

# .strict-typing
$strictTypingPath = Join-Path $coreDir ".strict-typing"
if (Test-Path $strictTypingPath) {
    $content = Get-Content $strictTypingPath -Raw
    $content = $content -replace 'homeassistant\.', 'exome.'
    $content = $content -replace '^homeassistant$', 'exome'
    Set-Content $strictTypingPath -Value $content -NoNewline
    Write-Host "Updated: .strict-typing"
}

# CODEOWNERS
$codeownersPath = Join-Path $coreDir "CODEOWNERS"
if (Test-Path $codeownersPath) {
    $content = Get-Content $codeownersPath -Raw
    $content = $content -replace '/homeassistant/', '/exome/'
    Set-Content $codeownersPath -Value $content -NoNewline
    Write-Host "Updated: CODEOWNERS"
}

# MANIFEST.in
$manifestPath = Join-Path $coreDir "MANIFEST.in"
if (Test-Path $manifestPath) {
    $content = Get-Content $manifestPath -Raw
    $content = $content -replace 'homeassistant', 'exome'
    Set-Content $manifestPath -Value $content -NoNewline
    Write-Host "Updated: MANIFEST.in"
}

# .core_files.yaml
$coreFilesPath = Join-Path $coreDir ".core_files.yaml"
if (Test-Path $coreFilesPath) {
    $content = Get-Content $coreFilesPath -Raw
    $content = $content -replace 'homeassistant/', 'exome/'
    Set-Content $coreFilesPath -Value $content -NoNewline
    Write-Host "Updated: .core_files.yaml"
}

Write-Host ""
Write-Host "=== Import replacement complete! ==="
Write-Host ""
Write-Host "NOTE: Third-party package names (e.g. atomicwrites-homeassistant,"
Write-Host "      home-assistant-bluetooth, io.homeassistant.companion.android)"
Write-Host "      were intentionally NOT modified."
