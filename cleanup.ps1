$files = @(
    "CLAUDE.md", "AGENTS.md", "GEMINI.md", 
    "CODEOWNERS", "CODE_OF_CONDUCT.md", "CONTRIBUTING.md", 
    "CLA.md", "SECURITY.md"
)
$dirs = @(
    ".claude", ".github", ".vscode", ".devcontainer"
)
$root = "l:\shared F\EXOME"

Get-ChildItem -Path $root -Recurse -Force -ErrorAction SilentlyContinue | Where-Object { 
    ($_.PSIsContainer -and $dirs -contains $_.Name) -or 
    (-not $_.PSIsContainer -and $files -contains $_.Name) 
} | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

Get-ChildItem -Path $root -Recurse -Force -ErrorAction SilentlyContinue | Where-Object { 
    ($_.PSIsContainer -and $dirs -contains $_.Name) -or 
    (-not $_.PSIsContainer -and $files -contains $_.Name) 
} | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
