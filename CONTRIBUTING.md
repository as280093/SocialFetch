# 🤝 Contributing to SocialFetch

First off, thank you for considering contributing to **SocialFetch**! It's people like you who make the terminal a more aesthetic place.

To maintain the project's performance (especially for users on lower-end hardware) and security, please follow these guidelines.

---

## 🏗️ Technical Standards

### 1. No Web Scraping
We have a **Strict Official API Policy**. 
* **Allowed:** Using `Invoke-RestMethod` or `Invoke-WebRequest` against official REST or GraphQL endpoints.
* **Prohibited:** Using Puppeteer, Selenium, or regex to parse HTML from a website. 
* **Why?** Scraping is brittle, violates many ToS, and can lead to IP bans for our users.

### 2. PowerShell Best Practices
To keep the codebase professional and bug-free:
* **Approved Verbs:** All functions must use [Official PowerShell Verbs](https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/approved-verbs-for-windows-powershell-commands) (e.g., `Get-SocialStats` instead of `Fetch-Stats`).
* **Variable Names:** Avoid automatic variables like `$Profile`, `$Error`, or `$Host`. Use descriptive names like `$SimklData`.
* **Error Handling:** Always wrap API calls in a `try/catch` block.

---

## 🧩 Adding a New Module

If you want to add a new platform (e.g., `Letterboxd.ps1`), follow this workflow:

### Step 1: Create the script
Place your new script in the `src/` directory.

### Step 2: Use the Template
Every module should accept the `$Context` and `$DebugMode` parameters.

```powershell
param ($Context, $DebugMode)

# 1. Define your Nerd Font icons (Hex format)
$Icons = @([char]0xeb42, [char]0xf005) 

# 2. Get User/Token from Context
$User = $Context.Settings["PlatformName"]
$Token = $Context.Secrets["PLATFORM_TOKEN"]

# 3. Fetch Data
try {
    $Data = Invoke-RestMethod -Uri "[https://api.platform.com/v1/$User](https://api.platform.com/v1/$User)"
    
    # 4. Return the standard Object
    return @{
        Text = "{0} $($Data.total) {1} $($Data.stars)"
        Icons = $Icons
    }
} catch {
    if ($DebugMode) { Write-Error $_ }
    return $null
}