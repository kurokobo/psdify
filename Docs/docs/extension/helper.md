# PSDify Helper Browser Extension

PSDify Helper is a companion browser extension for Chrome and Edge that lets you copy a `Connect-Dify` login command or individual session tokens directly from the Dify console, without manually digging through developer tools.

!!! note "Chrome Web Store"

    PSDify Helper is available on the [Chrome Web Store](https://chromewebstore.google.com/detail/psdify-helper/ilhdadmkkcheoojjemdbklgelnaikhfp).
    It is also compatible with Microsoft Edge via the Chrome Web Store.

## What You Can Do

After logging in to Dify, right-click anywhere on a console page to find the **PSDify Helper** submenu with three options:

| Menu item | What is copied |
| --- | --- |
| **Copy Login Command** | A multiline PowerShell snippet that sets environment variables and calls `Connect-Dify` |
| **Copy Access Token** | The raw `access_token` value from your browser session |
| **Copy CSRF Token** | The raw `csrf_token` value from your browser session |

The extension reads session cookies already stored in your browser and does **not** make any additional network requests.

### Copied Login Command

Selecting **Copy Login Command** places the following on your clipboard (token values are filled in automatically):

```powershell
Import-Module PSDify
$env:PSDIFY_URL="https://cloud.dify.ai"
$env:PSDIFY_AUTH_METHOD="AccessToken"
$env:PSDIFY_ACCESS_TOKEN="eyJhbGci..."
$env:PSDIFY_CSRF_TOKEN="eyJhbGci..."
Connect-Dify
```

Paste it into your PowerShell session and you are authenticated immediately — no password or email code required.

This is especially useful when:

- You are using **Dify Cloud Edition**, where only email-based code authentication is available interactively.
- You are using a **self-hosted Dify instance** and want to avoid entering credentials manually in your terminal.
- Your Dify instance is Enterprise edition and uses **SSO (Single Sign-On)**, where direct password login is not supported.

## Requirements

- Google Chrome or Microsoft Edge
- Dify **1.9.2 or later** (earlier versions do not use session cookies)

## Installation

### Chrome Web Store

Install PSDify Helper directly from the [Chrome Web Store](https://chromewebstore.google.com/detail/psdify-helper/ilhdadmkkcheoojjemdbklgelnaikhfp).
The same extension is also compatible with Microsoft Edge via the Chrome Web Store.

### Manual Installation (Load Unpacked)

Until the extension is available on the Chrome Web Store, install it as an unpacked extension:

1. Download or clone the [PSDify repository](https://github.com/kurokobo/psdify).
2. Open Chrome or Edge and navigate to `chrome://extensions/` (Chrome) or `edge://extensions/` (Edge).
3. Enable **Developer mode** using the toggle in the page.
4. Click **Load unpacked**.
5. Select the `Extension/` folder inside the repository.

The PSDify Helper icon will appear in your browser toolbar.

## Configuration

### Using with Self-Hosted Dify Instances

By default, the extension is active only on `https://cloud.dify.ai`.
To enable it for a self-hosted instance:

1. Open Chrome or Edge and navigate to `chrome://extensions/` (Chrome) or `edge://extensions/` (Edge).
2. Click the **Details** button for the PSDify Helper extension, then select **Extension options**.
3. Enter the base URL of your instance (e.g., `https://dify.example.com`) and click **Add**.
4. Chrome (or Edge) will show a permission dialog asking you to allow access to that site. Click **Allow**.

The URL is added to the list and the context menu becomes active on that instance.
You can add multiple instances and remove them at any time from the same options page.

!!! note

    After removing a URL from the options page, you may need to reload `chrome://extensions/` to see the change reflected in the site access list.

## Usage

1. Log in to your Dify instance in Chrome or Edge as you normally would.
2. Right-click anywhere on the page.
3. Hover over **PSDify Helper** in the context menu.
4. Select the desired action.

A toast notification will appear on the page confirming that the content was copied to the clipboard.

1. Switch to your PowerShell session and paste the copied command.

## Notes

- The extension reads `access_token` and `csrf_token` cookies stored by the browser when you log in to Dify. These cookies are HttpOnly and not accessible via JavaScript; the extension accesses them through the `chrome.cookies` API.
- The tokens are valid only for the current browser session. If you log out or the session expires, log in to Dify again before using the extension.
- The `AccessToken` authentication method used by the copied command requires **Dify 1.9.2 or later**. For earlier versions, use `Password` or `Code` authentication instead.

## Privacy Policy

PSDify Helper does not collect, transmit, or share any user data.

The extension reads `access_token` and `csrf_token` cookies from your active Dify session solely to copy their values to your clipboard. This happens only when you explicitly select a menu item. The cookie values are never sent to any external server, never written to local storage, and are not retained after the copy operation completes.

The only data written to persistent storage is the list of self-hosted Dify instance URLs you add via the options page. This list is stored locally in your browser using `chrome.storage.local` and is never shared with or transmitted to any third party.
