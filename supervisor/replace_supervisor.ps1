# replace_supervisor.ps1
# Updates "Home Assistant" references in the supervisor to "EXOME"
# Run from: l:\shared F\EXOME\supervisor
#
# Usage: powershell -ExecutionPolicy Bypass -File replace_supervisor.ps1

$ErrorActionPreference = "Stop"

$supervisorDir = "l:\shared F\EXOME\supervisor\supervisor"

Write-Host "=== EXOME Supervisor Branding Update ==="
Write-Host ""

$pyFiles = Get-ChildItem -Path $supervisorDir -Recurse -Filter "*.py" -File
Write-Host "Found $($pyFiles.Count) .py files in supervisor/"

$count = 0
foreach ($file in $pyFiles) {
    $content = Get-Content $file.FullName -Raw
    $original = $content

    # Replace user-facing strings and docstrings
    $content = $content -replace 'Home Assistant Operating System', 'EXOME Operating System'
    $content = $content -replace 'Home Assistant Operating-System', 'EXOME Operating-System'
    $content = $content -replace 'Home Assistant Core', 'EXOME Core'
    $content = $content -replace 'Home Assistant OS', 'EXOME OS'
    $content = $content -replace 'Home Assistant Supervisor', 'EXOME Supervisor'
    $content = $content -replace 'home assistant', 'EXOME'
    $content = $content -replace 'Home Assistant', 'EXOME'

    if ($content -ne $original) {
        Set-Content $file.FullName -Value $content -NoNewline
        $count++
    }
}
Write-Host "Updated $count files in supervisor/"

# Also handle tests
$testDir = "l:\shared F\EXOME\supervisor\tests"
if (Test-Path $testDir) {
    $testFiles = Get-ChildItem -Path $testDir -Recurse -Filter "*.py" -File
    Write-Host "Found $($testFiles.Count) .py test files"

    $testCount = 0
    foreach ($file in $testFiles) {
        $content = Get-Content $file.FullName -Raw
        $original = $content

        $content = $content -replace 'Home Assistant Operating System', 'EXOME Operating System'
        $content = $content -replace 'Home Assistant Operating-System', 'EXOME Operating-System'
        $content = $content -replace 'Home Assistant Core', 'EXOME Core'
        $content = $content -replace 'Home Assistant OS', 'EXOME OS'
        $content = $content -replace 'Home Assistant Supervisor', 'EXOME Supervisor'
        $content = $content -replace 'home assistant', 'EXOME'
        $content = $content -replace 'Home Assistant', 'EXOME'

        if ($content -ne $original) {
            Set-Content $file.FullName -Value $content -NoNewline
            $testCount++
        }
    }
    Write-Host "Updated $testCount test files"
}

Write-Host ""
Write-Host "=== Supervisor branding update complete! ==="
