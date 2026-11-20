# 🛠️ Maintain your GitHub profile

Your profile page renders from this repository because it is named exactly **`Barathvenkatesh/Barathvenkatesh`**. Any change you push to `README.md` shows up on https://github.com/Barathvenkatesh within seconds.

## Make a change

```powershell
cd "C:\Users\acer\Documents\Default Project\Barathvenkatesh"
# edit README.md or any file in assets/
git add .
git commit -m "update: describe your change"
git push
```

## What's where

| Goal | File |
|---|---|
| Bio, about, projects, roadmap, links | `README.md` |
| Banner title / subtitle | `assets/header.svg` → the `<text>` tags |
| Rotating intro phrases | `assets/typing.svg` → four `<text>` blocks |
| Whiteboard mockup | `assets/whiteboard-preview.svg` |
| Tech stack badges | `README.md` → **Tech Stack** (more at [shields.io](https://shields.io)) |
| Contribution snake | `.github/workflows/snake.yml` — regenerates daily, commits `assets/snake.svg` |

## Stats cards

The stats, streak, trophy, and activity cards read your public GitHub data from community services. They fill in automatically as you commit and build repos. If a service is briefly down, only that one card is missing — the rest of the profile still renders.

## Add your real social links

The LinkedIn/X badges were removed because no handles were available. To add them, paste these into the **Connect With Me** section of `README.md`:

```markdown
<a href="https://www.linkedin.com/in/YOUR-HANDLE/"><img src="https://img.shields.io/badge/LinkedIn-Connect-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn" /></a>
<a href="https://x.com/YOUR-HANDLE"><img src="https://img.shields.io/badge/Twitter-Follow-1DA1F2?style=for-the-badge&logo=x&logoColor=white" alt="Twitter" /></a>
```

## Also publish your whiteboard project

```powershell
cd "C:\Users\acer\Documents\Default Project\whiteboard"
git init
git add .
git commit -m "Initial commit: Collaborative Whiteboard"
git branch -M main
gh repo create Barathvenkatesh/collaborative-whiteboard --public --source=. --remote=origin --push
```

Then update the **View Repository** badge in your profile README — it already points to that repo name.
