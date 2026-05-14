$ErrorActionPreference = 'Stop'

$RepoName = 'kue-chip2-web-emulator'
$Owner = 'szkr01'
$Repo = "$Owner/$RepoName"

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
  throw 'GitHub CLI (gh) is required. Install it first: winget install --id GitHub.cli'
}
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
  throw 'Git is required. Install it first: winget install --id Git.Git'
}

if (-not (Test-Path .git)) {
  git init
  git branch -M main
}

git add .
git commit -m 'Initial KUE-CHIP2 web emulator'
if ($LASTEXITCODE -ne 0) {
  Write-Host 'No new commit was created. Continuing.'
}

# Create the repository when absent; otherwise reuse it.
gh repo view $Repo *> $null
if ($LASTEXITCODE -ne 0) {
  gh repo create $Repo --public --source . --remote origin --push
} else {
  git remote remove origin 2>$null
  git remote add origin "https://github.com/$Repo.git"
  git push -u origin main
}
if ($LASTEXITCODE -ne 0) { throw 'Repository creation or push failed.' }

# Enable GitHub Pages with GitHub Actions as the source.
gh api --method POST "/repos/$Repo/pages" -f build_type=workflow
if ($LASTEXITCODE -ne 0) {
  gh api --method PUT "/repos/$Repo/pages" -f build_type=workflow
}
if ($LASTEXITCODE -ne 0) { throw 'GitHub Pages setup failed.' }

# Trigger deployment workflow.
gh workflow run 'Deploy GitHub Pages' --repo $Repo
if ($LASTEXITCODE -ne 0) { throw 'Workflow dispatch failed. It may be available after GitHub indexes the workflow; rerun this command after a short delay.' }

Write-Host "Repository: https://github.com/$Repo"
Write-Host "Pages:      https://$Owner.github.io/$RepoName/"
