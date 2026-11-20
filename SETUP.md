# 🚀 How to publish your professional GitHub profile

Your profile page is driven by a **special repository**. That's the whole secret:

> Create a **public** repo named **exactly your username** → `github.com/<username>/<username>` → put a `README.md` in it → GitHub renders it on your profile.

That repository is this folder. Here's how to get it live.

---

## ✅ Method A — Automatic (recommended)

### 1. Sign in to GitHub CLI

Install Git + GitHub CLI if needed, then:

```powershell
gh auth login
```

Choose: **GitHub.com → HTTPS → Login with a web browser**. Copy the one-time code, paste it in the browser, done.

Verify:

```powershell
gh auth status
```

### 2. Run the publish script

```powershell
powershell -ExecutionPolicy Bypass -File "setup\publish.ps1"
```

It will:
1. Read your username from GitHub automatically
2. Replace every placeholder (`Barathvenkatesh`, `Barath Venkatesh`, etc.)
3. Rename the folder to your username
4. `git init` → commit → `main` branch
5. Create the public repo `<username>/<username>` and push

Then open **https://github.com/\<your-username\>** — your profile is live. 🎉

---

## ✅ Method B — Manual (no script)

If you prefer typing the commands yourself:

```powershell
# 1. Go into the profile folder
cd "C:\Users\acer\Documents\Default Project\github-profile"

# 2. Replace placeholders in every file, e.g. in VS Code:
#    Ctrl+Shift+H  ->  find "Barathvenkatesh"  ->  replace with your username
#    Repeat for: Barath Venkatesh, Barathvenkatesh, Barathvenkatesh@users.noreply.github.com, India,
#                Barathvenkatesh, Barathvenkatesh

# 3. Initialize git
git init
git add .
git commit -m "feat: professional GitHub profile"
git branch -M main

# 4. Create the repo on GitHub (requires gh CLI) and push
gh repo create Barathvenkatesh/Barathvenkatesh --public --source=. --remote=origin --push
```

> ⚠️ **Important:** the repo name must be `Barathvenkatesh` — **not** `Barathvenkatesh.github.io`.
> `.github.io` is only for a GitHub Pages *website*. The profile README uses the plain username repo.

---

## 🔧 Customize after publishing

| What | Where |
|---|---|
| Name, bio, about text | `README.md` |
| Header title & subtitle | `assets/header.svg` → the `<text>` elements |
| Typing phrases | `assets/typing.svg` → the four `<text>` blocks |
| Tech badges | `README.md` → **Tech Stack** section (grab more from [shields.io](https://shields.io)) |
| Projects | `README.md` → **Featured Projects** section |
| Social links | `README.md` → **Connect With Me** section |
| Contribution snake | `.github/workflows/snake.yml` (auto-updates daily) |

Every change is just: `git add .` → `git commit -m "..."` → `git push`.

---

## 🧩 Why some cards appear later

- **Stats, streak, trophies, activity graph** are generated from your GitHub data. They populate once you have public repos/commits — usually instantly, sometimes after a cache refresh.
- **Contribution snake** appears after the `.github/workflows/snake.yml` action runs the first time (push to `main` or daily at 00:00 UTC). Until then, `assets/snake.svg` shows a friendly placeholder.
- All external images are standard community services. If one is down, your profile still renders — only that one card is missing.

---

## 📦 Bonus — publish the whiteboard as a second repo

```powershell
cd "C:\Users\acer\Documents\Default Project\whiteboard"
git init
git add .
git commit -m "Initial commit: Collaborative Whiteboard"
git branch -M main
gh repo create Barathvenkatesh/collaborative-whiteboard --public --source=. --remote=origin --push
```

Then the **View Repository** badge on your profile links to real code.

---

## 🆘 Troubleshooting

| Problem | Fix |
|---|---|
| `gh: command not found` | Install GitHub CLI: `winget install GitHub.cli`, or use portable ZIP from `https://github.com/cli/cli/releases` |
| `git: command not found` | Install Git: `winget install Git.Git`, or download `MinGit` portable ZIP from `git-for-windows/git` releases |
| Repo created but profile unchanged | Confirm repo name is **exactly** your username and `README.md` is at the root (not in a subfolder) |
| Badges show "invalid" | Check for un-replaced `Barathvenkatesh` placeholders |
| MSI install cancelled / UAC | Use the portable ZIP method — no admin needed |
