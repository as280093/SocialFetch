# 🛡️ Security Policy

We take the security of **SocialFetch** and our users seriously. Because this tool handles API tokens and runs scripts on your local machine, we are committed to ensuring it remains safe and secure.

## Supported Versions

We currently provide security updates and patches for the following versions:

| Version | Supported | Notes |
| :--- | :--- | :--- |
| **1.x** (Latest) | :white_check_mark: | Current stable release |
| < 1.0 | :x: | Legacy / Beta versions |

> [!NOTE]
> We strongly recommend always running the latest version of the script to ensure compatibility with third-party APIs (GitHub, Steam, AniList) and to receive the latest security patches.

## reporting a Vulnerability

**Please do not open public issues for security vulnerabilities.** Publicly disclosing a vulnerability can put the entire community at risk before a fix is available.

### How to Report
We utilize **GitHub Private Vulnerability Reporting**. This allows you to report issues directly to the maintainers without exposing the vulnerability to the public.

1.  Go to the **Security** tab of this repository.
2.  Click on **Report a vulnerability**.
3.  Fill in the details of the exploit or issue.
4.  Submit the report.

### What to Report
* **Token Leaks:** If you accidentally committed a `.env` file or see a way the script might log secrets to the console.
* **Arbitrary Code Execution:** If you find a way to make `main.ps1` execute malicious external code.
* **Logic Flaws:** Any bug that could lead to data corruption or unintended system modification.

### Our Response
* We aim to acknowledge all security reports within **48 hours**.
* We will keep you updated on the progress of the fix.
* Once fixed, we will publish a Security Advisory to notify the community.

---
**Thank you for helping keep SocialFetch safe and aesthetic.**
