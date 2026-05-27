"use strict";

const CLOUD_ORIGIN = "https://cloud.dify.ai";
const MENU_PARENT_ID = "psdify";
const MENU_LOGIN_ID = "psdify-copy-login";
const MENU_ACCESS_TOKEN_ID = "psdify-copy-access-token";
const MENU_CSRF_TOKEN_ID = "psdify-copy-csrf-token";
const STORAGE_KEY = "selfHostedUrls";

// ── Cookie helpers ─────────────────────────────────────────────────────────

// Tries primaryName first; falls back to fallbackName.
// Needed because __Host- prefix cookies require HTTPS. Some self-hosted
// instances served over HTTP use the plain-name equivalents instead.
async function getCookieWithFallback(tabUrl, primaryName, fallbackName) {
  return (
    (await chrome.cookies.get({ url: tabUrl, name: primaryName })) ??
    (await chrome.cookies.get({ url: tabUrl, name: fallbackName }))
  );
}

// ── In-page toast ───────────────────────────────────────────────────────────

// Injects a toast notification into the Dify page. Uses Dify's own CSS
// custom properties (--color-components-panel-*, --background-image-toast-*,
// --color-text-*) so the toast blends with the current light/dark theme.
// Falls back to hardcoded values derived from Dify's theme CSS if the
// variables are not resolved.
async function showPageToast(tabId, type, message) {
  try {
    await chrome.scripting.executeScript({
      target: { tabId },
      func: (type, message) => {
        document.getElementById("__psdify_toast__")?.remove();

        // Type-specific gradient and icon colour, matching Dify's toast tokens.
        // Gradient variable names come from app/styles/tailwind-core.css.
        // Colour variable names come from Dify's Tailwind component tokens.
        const TYPES = {
          success: {
            gradientVar: "--background-image-toast-success-bg",
            gradientFallback:
              "linear-gradient(92deg, rgba(23,178,106,.25) 0%, rgba(255,255,255,0) 100%)",
            colorVar: "--color-text-success",
            colorFallback: "#12b76a",
            iconPath:
              "M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z",
          },
          error: {
            gradientVar: "--background-image-toast-error-bg",
            gradientFallback:
              "linear-gradient(92deg, rgba(240,68,56,.25) 0%, rgba(255,255,255,0) 100%)",
            colorVar: "--color-text-destructive",
            colorFallback: "#f04438",
            iconPath:
              "M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-8-5a.75.75 0 01.75.75v4.5a.75.75 0 01-1.5 0v-4.5A.75.75 0 0110 5zm0 10a1 1 0 100-2 1 1 0 000 2z",
          },
        };
        const t = TYPES[type] ?? TYPES.error;

        // Detect Dify's current theme for dark-mode-aware CSS fallbacks.
        const isDark =
          document.documentElement.dataset.theme === "dark";
        const bg = isDark
          ? "rgba(34,34,37,.95)"
          : "rgba(252,252,253,.95)";
        const border = isDark
          ? "rgba(200,206,218,.14)"
          : "rgba(16,24,40,.08)";
        const textPrimary = isDark ? "#f9fafb" : "#101828";
        const textSecondary = isDark ? "#d0d5dd" : "#344054";
        const gradientFallback = isDark
          ? t.gradientFallback.replace("rgba(255,255,255,0)", "rgba(0,0,0,0)")
          : t.gradientFallback;

        // Build the DOM.
        const wrap = document.createElement("div");
        wrap.id = "__psdify_toast__";
        wrap.style.cssText =
          "position:fixed;top:16px;right:16px;z-index:99999;" +
          "width:360px;max-width:calc(100vw - 2rem);" +
          "opacity:0;transform:translateY(-12px);" +
          "transition:opacity 300ms ease,transform 300ms ease;" +
          "pointer-events:none;";

        const card = document.createElement("div");
        card.style.cssText =
          "position:relative;overflow:hidden;border-radius:12px;" +
          `border:0.5px solid var(--color-components-panel-border,${border});` +
          `background:var(--color-components-panel-bg-blur,${bg});` +
          "box-shadow:0 4px 6px -1px rgba(16,24,40,.08),0 2px 4px -2px rgba(16,24,40,.06);" +
          "backdrop-filter:blur(5px);";

        const glow = document.createElement("div");
        glow.setAttribute("aria-hidden", "true");
        glow.style.cssText =
          "position:absolute;inset:-1px;pointer-events:none;opacity:.4;" +
          `background-image:var(${t.gradientVar},${gradientFallback});`;

        const row = document.createElement("div");
        row.style.cssText =
          "position:relative;display:flex;align-items:flex-start;gap:4px;padding:12px;";

        const iconWrap = document.createElement("div");
        iconWrap.style.cssText =
          "flex-shrink:0;display:flex;align-items:center;justify-content:center;padding:2px;" +
          `color:var(${t.colorVar},${t.colorFallback});`;
        // The icon path is hardcoded above, so innerHTML is safe here.
        iconWrap.innerHTML =
          `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor"` +
          ` style="width:20px;height:20px"><path fill-rule="evenodd" d="${t.iconPath}"` +
          ` clip-rule="evenodd"/></svg>`;

        const textWrap = document.createElement("div");
        textWrap.style.cssText = "flex:1;padding:4px;min-width:0;";

        const title = document.createElement("div");
        title.style.cssText =
          "font-size:14px;font-weight:600;line-height:20px;" +
          `color:var(--color-text-primary,${textPrimary});` +
          "word-break:break-word;font-family:inherit;";
        title.textContent = "PSDify Helper";

        const desc = document.createElement("div");
        desc.style.cssText =
          "font-size:12px;line-height:18px;margin-top:4px;" +
          `color:var(--color-text-secondary,${textSecondary});` +
          "word-break:break-word;font-family:inherit;";
        desc.textContent = message;

        textWrap.append(title, desc);
        row.append(iconWrap, textWrap);
        card.append(glow, row);
        wrap.appendChild(card);
        document.body.appendChild(wrap);

        // Animate in.
        requestAnimationFrame(() =>
          requestAnimationFrame(() => {
            wrap.style.opacity = "1";
            wrap.style.transform = "translateY(0)";
          })
        );

        // Auto-dismiss.
        setTimeout(() => {
          wrap.style.opacity = "0";
          wrap.style.transform = "translateY(-12px)";
          setTimeout(() => wrap.remove(), 300);
        }, 3000);
      },
      args: [type, message],
    });
  } catch {
    // If script injection fails, silently ignore.
  }
}

// ── Context menu management ──────────────────────────────────────────────────

async function getSelfHostedUrls() {
  const result = await chrome.storage.local.get(STORAGE_KEY);
  return result[STORAGE_KEY] ?? [];
}

async function updateContextMenu() {
  try {
    await chrome.contextMenus.remove(MENU_PARENT_ID);
  } catch {
    // Menu item did not exist yet; ignore
  }

  const selfHostedUrls = await getSelfHostedUrls();
  const patterns = [
    `${CLOUD_ORIGIN}/*`,
    ...selfHostedUrls.map((url) => `${url}/*`),
  ];

  chrome.contextMenus.create({
    id: MENU_PARENT_ID,
    title: "PSDify Helper",
    contexts: ["page"],
    documentUrlPatterns: patterns,
  });
  chrome.contextMenus.create({
    id: MENU_LOGIN_ID,
    parentId: MENU_PARENT_ID,
    title: "Copy Login Command",
    contexts: ["page"],
  });
  chrome.contextMenus.create({
    id: MENU_ACCESS_TOKEN_ID,
    parentId: MENU_PARENT_ID,
    title: "Copy Access Token",
    contexts: ["page"],
  });
  chrome.contextMenus.create({
    id: MENU_CSRF_TOKEN_ID,
    parentId: MENU_PARENT_ID,
    title: "Copy CSRF Token",
    contexts: ["page"],
  });
}

chrome.runtime.onInstalled.addListener(updateContextMenu);
chrome.permissions.onAdded.addListener(updateContextMenu);
chrome.permissions.onRemoved.addListener(updateContextMenu);

// ── Context menu click handler ───────────────────────────────────────────────

chrome.contextMenus.onClicked.addListener(async (info, tab) => {
  const { menuItemId } = info;
  if (
    menuItemId !== MENU_LOGIN_ID &&
    menuItemId !== MENU_ACCESS_TOKEN_ID &&
    menuItemId !== MENU_CSRF_TOKEN_ID
  )
    return;

  let origin;
  try {
    origin = new URL(tab.url).origin;
  } catch {
    await showPageToast(tab.id, "error", "Could not determine the page URL.");
    return;
  }

  // Read cookies from the browser's store.
  // chrome.cookies can access HttpOnly cookies, unlike document.cookie.
  // Try __Host- prefix first (required for HTTPS). Some self-hosted instances
  // running over plain HTTP use unprefixed names, so fall back to those.
  const [accessTokenCookie, csrfTokenCookie] = await Promise.all([
    getCookieWithFallback(tab.url, "__Host-access_token", "access_token"),
    getCookieWithFallback(tab.url, "__Host-csrf_token", "csrf_token"),
  ]);

  if (!accessTokenCookie || !csrfTokenCookie) {
    await showPageToast(
      tab.id,
      "error",
      "Not logged in to Dify. Please log in first."
    );
    return;
  }

  // Determine what to copy and the success message.
  let text;
  let successMessage;
  if (menuItemId === MENU_LOGIN_ID) {
    text = [
      `$env:PSDIFY_URL="${origin}"`,
      `$env:PSDIFY_AUTH_METHOD="AccessToken"`,
      `$env:PSDIFY_ACCESS_TOKEN="${accessTokenCookie.value}"`,
      `$env:PSDIFY_CSRF_TOKEN="${csrfTokenCookie.value}"`,
      `Connect-Dify`,
    ].join("\n");
    successMessage = "Login command copied to clipboard.";
  } else if (menuItemId === MENU_ACCESS_TOKEN_ID) {
    text = accessTokenCookie.value;
    successMessage = "Access token copied to clipboard.";
  } else {
    text = csrfTokenCookie.value;
    successMessage = "CSRF token copied to clipboard.";
  }

  // Copy to clipboard via an injected script (navigator.clipboard is
  // unavailable in service workers).
  try {
    await chrome.scripting.executeScript({
      target: { tabId: tab.id },
      func: (t) => navigator.clipboard.writeText(t),
      args: [text],
    });
    await showPageToast(tab.id, "success", successMessage);
  } catch {
    await showPageToast(tab.id, "error", "Failed to write to clipboard.");
  }
});
