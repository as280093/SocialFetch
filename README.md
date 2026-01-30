<h1 align="center">
  <br>
  <img src="assets/SocialFetch.png" alt="SocialFetch" width="200">
  <br>
  SocialFetch
  <br>
</h1>

<div align="center">

![GitHub Stars](https://img.shields.io/github/stars/as280093/SocialFetch?style=for-the-badge&color=cba6f7&logo=github)
![GitHub Forks](https://img.shields.io/github/forks/as280093/SocialFetch?style=for-the-badge&color=89b4fa&logo=git)
![GitHub License](https://img.shields.io/github/license/as280093/SocialFetch?style=for-the-badge&color=a6e3a1)
![PowerShell Version](https://img.shields.io/badge/PowerShell-5.1%2B-blue?style=for-the-badge&logo=powershell)
<br>
<div align="center">

<a href="https://github.com/as280093/SocialFetch/releases/latest">
  <img src="https://img.shields.io/github/v/release/as280093/SocialFetch?style=for-the-badge&color=f38ba8&logo=windows&label=Download%20Stable" alt="Download Stable">
</a>

<a href="https://github.com/as280093/SocialFetch/releases">
  <img src="https://img.shields.io/github/v/release/as280093/SocialFetch?include_prereleases&style=for-the-badge&color=orange&logo=github&label=Download%20Beta" alt="Download Beta">
</a>

</div>

**A modular, aesthetic dashboard companion for Fastfetch.**
*Turn your terminal into a real-time progress tracker.*

[ ✨ Features ](#-features) • [ 📦 Installation ](#-installation--setup) • [ 🔑 Tokens ](#-key--token-guide) • [ 🤝 Contributing ](#-contributing--issues) • [ 📄 License ](#-license)

</div>

---

## 💡 Why SocialFetch?

Standard fetch tools provide a static snapshot of your hardware. **SocialFetch** makes your terminal feel alive by pulling your actual, real-time progress. Whether it's tracking **42,813 Manga chapters** on Kitsu or your **1,540 Reddit karma**, SocialFetch brings your digital life into your terminal dashboard.

---

## ✨ Features

* **🖥️ Windows Native:** Built from the ground up to leverage PowerShell 5.1+ and Windows Terminal capabilities.
* **⚡ Smart Caching:** Automatic JSON-based caching ensures Fastfetch remains instant, even on low-end hardware.
* **🧩 Fully Modular:** Add or remove platforms easily by dropping `.ps1` scripts into the `src/` directory.

---

---

## 📦 Installation & Setup

### Option A: The "Normal" Way (Download Zip)
*Recommended for most users.*

1.  Click the **[Download Latest](https://github.com/as280093/SocialFetch/releases/latest)** button above.
2.  Download the `SocialFetch-vX.X.zip` file.
3.  Extract the folder into your Fastfetch config directory:
    * **Path:** `%USERPROFILE%\.config\fastfetch\`
    * *You should end up with a folder named `SocialFetch` inside `fastfetch`.*

### Option B: The "Developer" Way (Git Clone)
*Use this if you plan to edit the code or contribute.*

### 1. Clone the Repository
Open PowerShell and clone the project into your Fastfetch configuration directory:
```powershell
cd $env:USERPROFILE\.config\fastfetch
git clone [https://github.com/as280093/SocialFetch.git](https://github.com/as280093/SocialFetch.git) SocialFetch
```

### 2. Configure Environment
Prepare your configuration files by renaming the examples:
* Rename `.env.example` to `.env`
* Rename `config/settings.conf.example` to `config/settings.conf`

### 3. Add to Fastfetch
Update your `config.jsonc` using the `%USERPROFILE%` variable to ensure universal path compatibility:

```jsonc
{
    "type": "command",
    "key": "Reddit   ",
    "keyColor": "red",
    "text": "%USERPROFILE%/.config/fastfetch/SocialFetch/bin/run.bat Reddit red"
}
```

---

## 🔑 Key & Token Guide

SocialFetch follows a **Strict Official API Policy**. 
> [!IMPORTANT]
> **No Web Scraping:** To ensure long-term stability and user security, SocialFetch **only** supports official REST APIs. We do not support modules that use headless browsers (Puppeteer/Selenium) or unofficial scraping methods that violate Platform Terms of Service.

| Platform | Access Type | How to Get |
| :--- | :--- | :--- |
| **GitHub** | Public / Private | [GitHub Developer Settings](https://github.com/settings/tokens) |
| **Steam** | Public Data | [Steam Web API Key](https://steamcommunity.com/dev/apikey) |
| **Simkl** | OAuth 2.0 | [Simkl API Settings](https://simkl.com/settings/developer/) |
| **AniList** | GraphQL API | [AniList Developer Portal](https://anilist.co/settings/developer) |

### 🛠️ GitHub Stats Detail
* **Public Mode:** If no `GITHUB_TOKEN` is provided in `.env`, the script fetches only public repositories and followers using the `users/$User` endpoint.
* **Private Mode:** Providing a token with `read:user` scope allows the script to hit the `/user` endpoint to include your private repositories and gists in the total count.
---

## 🤝 Contributing & Issues

### 🛡️ Module Guidelines
If you want to contribute a new platform module (`src/PlatformName.ps1`), you must follow these rules:
1. **Official APIs Only:** Your module must use `Invoke-RestMethod` or `Invoke-WebRequest` against an official endpoint.
2. **Approved Verbs:** PowerShell functions must use approved verbs (e.g., `Get-Stats`, `Invoke-Fetch`).
3. **No Secrets in Code:** Use the `$Context.Secrets` object to access tokens. Never hardcode keys.
4. **Caching:** All data must be returned to `main.ps1` for centralized JSON caching.

### 🐛 Bug Reports & Troubleshooting

If a module isn't displaying correctly or you see an error, please [Open an Issue](https://github.com/as280093/SocialFetch/issues) with the following details:

1. **Environment:** Your PowerShell version (Run `$PSVersionTable.PSVersion` in your terminal).
2. **The Module:** Which platform is failing? (e.g., `AniList.ps1`, `Steam.ps1`).
3. **Debug Logs:** This is the most important part! Run the module manually in Debug Mode and paste the output.

#### How to run in Debug Mode:
Open PowerShell and run the controller script with the `-DebugMode` flag:

```powershell
powershell -File "%USERPROFILE%\.config\fastfetch\SocialFetch\bin\main.ps1" -Module Reddit -DebugMode
```

> [!TIP]
> Replacing `Reddit` with the name of the failing module (e.g., `Anilist`) will help isolate the issue. If the error contains your **Private API Tokens**, please censor them before posting!

## 📄 License

SocialFetch is distributed under the **MIT License**.

---
<p align="center">Built for the community. Stay aesthetic.</p>

---

## 📈 Activity & Growth
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=as280093/SocialFetch&type=Date&theme=dark">
  <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=as280093/SocialFetch&type=Date">
  <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=as280093/SocialFetch&type=Date&theme=dark">
</picture>