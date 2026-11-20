<#!
.SYNOPSIS
  Non-interactive publisher: uses the GitHub token already saved by Git Credential Manager.
#!>
$ErrorActionPreference = 'Stop'

$gcm = "C:\Program Files\Git\ucrt64\bin\git-credential-manager.exe"
$gh  = "C:\Users\acer\Documents\Default Project\.tools\gh\bin\gh.exe"
$src = "C:\Users\acer\Documents\Default Project\github-profile"

# 1. Read stored GitHub credential (never printed)
$cred = "protocol=https`nhost=github.com`n`n" | & $gcm get 2>$null
$env:GH_TOKEN = (($cred | Where-Object { $_ -like 'password=*' }) -replace '^password=', '').Trim()
if (-not $env:GH_TOKEN) { throw 'No saved GitHub credential found.' }

$login = (& $gh api user --jq .login).Trim()
if (-not $login) { throw 'Could not determine GitHub username.' }
Write-Host "==> GitHub user: $login" -ForegroundColor Cyan

# Editable defaults (change these in the file if you like, then re-run)
$display = 'Barath Venkatesh'
$email   = "$login@users.noreply.github.com"
$city    = 'India'

# 2. Replace placeholders in all text assets
$files = Get-ChildItem -Path $src -Recurse -File | Where-Object {
    $_.Extension -in '.md', '.svg', '.yml', '.yaml' -and $_.FullName -notmatch '\\\.git\\'
}
foreach ($f in $files) {
    $t = [System.IO.File]::ReadAllText($f.FullName)
    $t = $t.Replace('YOUR_USERNAME', $login)
    $t = $t.Replace('YOUR NAME', $display)
    $t = $t.Replace('YOUR_NAME', $login)
    $t = $t.Replace('YOUR_EMAIL', $email)
    $t = $t.Replace('YOUR_CITY', $city)
    $t = $t.Replace('your-linkedin', $login)
    $t = $t.Replace('your-twitter', $login)
    [System.IO.File]::WriteAllText($f.FullName, $t)
}
Write-Host '==> Placeholders replaced' -ForegroundColor Green

# 3. Drop social badges we have no real handles for (avoid dead links)
$readme = Join-Path $src 'README.md'
$t = [System.IO.File]::ReadAllText($readme)
$t = (($t -split "`n") | Where-Object {
    $_ -notmatch 'linkedin\.com/in/' -and $_ -notmatch 'x\.com/'
}) -join "`n"
[System.IO.File]::WriteAllText($readme, $t)

# 4. Rename folder to match the required repo name
$dest = Join-Path (Split-Path $src -Parent) $login
if (-not (Test-Path $dest)) { Move-Item -Path $src -Destination $dest }
$repo = $dest
Write-Host "==> Repo folder: $repo" -ForegroundColor Cyan

# 5. Git init + first commit
& git init $repo | Out-Null
& git -C $repo config user.name $display
& git -C $repo config user.email $email
& git -C $repo add -A
& git -C $repo commit -m 'feat: professional GitHub profile' | Out-Null
& git -C $repo branch -M main
Write-Host '==> Committed on main' -ForegroundColor Green

# 6. Create public profile repo and push
& $gh repo create "$login/$login" --public --source=$repo --remote=origin --push
if ($LASTEXITCODE -ne 0) { throw 'Failed to create/push repository.' }

Write-Host "`nSUCCESS -> https://github.com/$login" -ForegroundColor Green
