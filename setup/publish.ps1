<#!
.SYNOPSIS
  Publishes the professional GitHub profile repo (<username>/<username>).
.DESCRIPTION
  Detects your GitHub username via gh CLI, replaces placeholders, initializes git,
  creates the public profile repository, and pushes it. No admin rights required.
#!>

[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot

function Resolve-Tool([string]$name, [string]$portable) {
    $cmd = Get-Command $name -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    if (Test-Path $portable) { return $portable }
    throw "$name not found. Install it or place it at: $portable"
}

$git = Resolve-Tool 'git' "$root\..\.tools\git\cmd\git.exe"
$gh  = Resolve-Tool 'gh'  "$root\..\.tools\gh\bin\gh.exe"

Write-Host "`n==> Checking GitHub login..." -ForegroundColor Cyan
try {
    $login = (& $gh api user --jq .login).Trim()
} catch {
    throw "Not logged in. Run: gh auth login   (then re-run this script)"
}
if (-not $login) { throw "Could not read your username. Run: gh auth login" }
Write-Host "    Logged in as: $login" -ForegroundColor Green

# Optional profile details
$apiName  = (& $gh api user --jq '.name // ""').Trim()
$apiEmail = (& $gh api user --jq '.email // ""').Trim()
$apiCity  = (& $gh api user --jq '.location // ""').Trim()

$displayName = Read-Host "Display name [$apiName]"
if ([string]::IsNullOrWhiteSpace($displayName)) { $displayName = $apiName }
if ([string]::IsNullOrWhiteSpace($displayName)) { $displayName = $login }

$email = Read-Host "Public email [$apiEmail]"
if ([string]::IsNullOrWhiteSpace($email)) {
    $email = if ($apiEmail) { $apiEmail } else { "$login@users.noreply.github.com" }
}

$city = Read-Host "Your city [$apiCity]"
if ([string]::IsNullOrWhiteSpace($city)) { $city = if ($apiCity) { $apiCity } else { 'Earth' } }

$handle  = Read-Host "LinkedIn slug (leave blank to remove link)"
$twitter = Read-Host "X/Twitter handle without @ (leave blank to remove link)"

Write-Host "`n==> Replacing placeholders..." -ForegroundColor Cyan
$nameNoSpaces = ($displayName -replace '\s', '')

$files = Get-ChildItem -Path $root -Recurse -File |
         Where-Object { $_.FullName -notmatch '\\\.git\\' -and $_.Extension -in '.md', '.svg', '.yml', '.yaml' }

foreach ($f in $files) {
    $text = [System.IO.File]::ReadAllText($f.FullName)
    $text = $text.Replace('YOUR_USERNAME', $login)
    $text = $text.Replace('YOUR NAME', $displayName)
    $text = $text.Replace('YOUR_NAME', $nameNoSpaces)
    $text = $text.Replace('YOUR_EMAIL', $email)
    $text = $text.Replace('YOUR_CITY', $city)
    $text = $text.Replace('your-linkedin', $(if ($handle) { $handle } else { $login }))
    $text = $text.Replace('your-twitter', $(if ($twitter) { $twitter } else { $login }))
    [System.IO.File]::WriteAllText($f.FullName, $text)
}
Write-Host "    Done." -ForegroundColor Green

Write-Host "`n==> Initializing git..." -ForegroundColor Cyan
if (-not (Test-Path "$root\.git")) {
    & $git init $root | Out-Null
}
& $git -C $root config user.name "$displayName"
& $git -C $root config user.email "$email"
& $git -C $root add -A
& $git -C $root commit -m "feat: professional GitHub profile" | Out-Null
& $git -C $root branch -M main

Write-Host "`n==> Creating and pushing $login/$login ..." -ForegroundColor Cyan
try {
    & $gh repo create "$login/$login" --public --source=$root --remote=origin --push
} catch {
    Write-Host "    Repo may already exist — trying plain push..." -ForegroundColor Yellow
    & $git -C $root push -u origin main
}

Write-Host "`n✨ DONE! Your profile: https://github.com/$login" -ForegroundColor Green
Write-Host "   (It can take a few seconds to render. Hard-refresh if needed.)`n" -ForegroundColor Gray
