---
name: "🐛 Bug Report"
about: "Report a module error or aesthetic glitch"
title: "[BUG] "
labels: bug
assignees: ''

---

## 🛑 Before you post
- [ ] I have checked that I am not leaking any private API tokens in this report.
- [ ] I have verified that I am using the latest version of SocialFetch.
- [ ] My voice hasn't accidentally enchanted the terminal (Medusa-charm check).

## 📝 Description
A clear and concise description of what the bug is.

## 🛠️ Environment Info
- **PowerShell Version:** (Run `$PSVersionTable.PSVersion` and paste here)
- **Fastfetch Version:** 
- **Module Name:** (e.g., `Steam.ps1`)

## 💻 Debug Logs
Run the following command in PowerShell and paste the **FULL** output below:

```powershell
powershell -File "bin/main.ps1" -Module <YourModuleName> -DebugMode
```

<details>
<summary>Click to expand Debug Logs</summary>

```text
PASTE YOUR FULL DEBUG OUTPUT HERE
```
</details>

## 📸 Screenshots
If applicable, add screenshots of your terminal output to help explain the problem.

## 🎯 Additional Context
Add any other context about the problem here (e.g., hardware constraints like a low-end laptop, specific Windows version, etc.).