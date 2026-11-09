# Windows version of setup.sh: installs the extensions in extensions.txt and copies config\keybindings.json and
# config\settings.json into VS Code's User folder (copies, since symlinks need admin or Developer Mode). Re-run after
# pulling or editing the repo. Safe to re-run.
#
# Device-only extras (work logins, servers, JDK paths, extensions) live outside the repo in %APPDATA%\lazycode:
#   settings.json   a JSON object appended to config\settings.json
#   extensions.txt  more extensions to install
#   mcp.json        VS Code's MCP servers (copied)
$ErrorActionPreference = 'Stop'

$Repo = $PSScriptRoot
$Local = Join-Path $env:APPDATA 'lazycode'
$Usr = Join-Path $env:APPDATA 'Code\User'
New-Item -ItemType Directory -Force $Usr | Out-Null
$utf8 = New-Object System.Text.UTF8Encoding $false

function Put($path, $text) {
    if ((Test-Path $path) -and ([IO.File]::ReadAllText($path) -eq $text)) { return }
    if (Test-Path $path) { Copy-Item $path "$path.bak" -Force }
    [IO.File]::WriteAllText($path, $text, $utf8)
    Write-Host "  updated $(Split-Path -Leaf $path)"
}

Write-Host "==> lazycode: settings + keybindings into $Usr"
Put (Join-Path $Usr 'keybindings.json') ([IO.File]::ReadAllText((Join-Path $Repo 'config\keybindings.json')))

$settings = [IO.File]::ReadAllText((Join-Path $Repo 'config\settings.json'))
$localSettings = Join-Path $Local 'settings.json'
if (Test-Path $localSettings) {
    # both files are JSONC (comments, trailing commas), so splice them as text; later keys win in VS Code
    $base = ($settings -replace '\}\s*\z', '') -replace ',?\s*\z', ",`n"
    $extra = ([IO.File]::ReadAllText($localSettings) -replace '\A\s*\{[ \t]*\r?\n?', '') -replace '\s*\}\s*\z', ''
    $settings = "// Built by setup.ps1 from config\settings.json + $localSettings`: edit those and re-run.`n" +
        "// Changes made here are overwritten (the previous file is kept as settings.json.bak).`n" +
        "$base`n  // -- device-only ($localSettings) --`n$extra`n}`n"
}
Put (Join-Path $Usr 'settings.json') $settings

$mcp = Join-Path $Local 'mcp.json'
if (Test-Path $mcp) { Put (Join-Path $Usr 'mcp.json') ([IO.File]::ReadAllText($mcp)) }

Write-Host "==> lazycode: extensions"
$have = code --list-extensions 2>$null
$want = @(Get-Content (Join-Path $Repo 'extensions.txt'))
if (Test-Path (Join-Path $Local 'extensions.txt')) { $want += Get-Content (Join-Path $Local 'extensions.txt') }
foreach ($e in $want | Where-Object { $_ -and $_ -notmatch '^#' }) {
    if ($have -notcontains $e) { code --install-extension $e 2>&1 | Out-Null }
}
