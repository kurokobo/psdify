"use strict";

const STORAGE_KEY = "selfHostedUrls";

// ── Storage helpers ──────────────────────────────────────────────────────────

async function getUrls() {
  const result = await chrome.storage.local.get(STORAGE_KEY);
  return result[STORAGE_KEY] ?? [];
}

async function saveUrls(urls) {
  await chrome.storage.local.set({ [STORAGE_KEY]: urls });
}

// ── UI rendering ─────────────────────────────────────────────────────────────

async function renderUrlList() {
  const urls = await getUrls();
  const list = document.getElementById("url-list");

  if (urls.length === 0) {
    list.innerHTML = '<p class="empty">No self-hosted instances configured.</p>';
    return;
  }

  list.innerHTML = urls
    .map(
      (url, i) => `
      <div class="url-item">
        <span>${escapeHtml(url)}</span>
        <button class="remove-btn" data-index="${i}" type="button">Remove</button>
      </div>`
    )
    .join("");

  list.querySelectorAll(".remove-btn").forEach((btn) => {
    btn.addEventListener("click", () => removeUrl(Number(btn.dataset.index)));
  });
}

function escapeHtml(text) {
  return text
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}

// ── Add / remove ─────────────────────────────────────────────────────────────

async function addUrl(rawUrl) {
  let origin;
  try {
    origin = new URL(rawUrl).origin;
  } catch {
    showStatus("error", "Invalid URL. Please enter a valid address such as https://dify.example.com");
    return;
  }

  if (origin === "https://cloud.dify.ai") {
    showStatus("info", "cloud.dify.ai is supported by default and does not need to be added here.");
    return;
  }

  const pattern = `${origin}/*`;

  const granted = await chrome.permissions.request({ origins: [pattern] });
  if (!granted) {
    showStatus("info", "Permission was not granted. The URL was not added.");
    return;
  }

  const urls = await getUrls();
  if (!urls.includes(origin)) {
    urls.push(origin);
    await saveUrls(urls);
  }

  document.getElementById("url-input").value = "";
  await renderUrlList();
  showStatus("success", `${origin} added.`);
}

async function removeUrl(index) {
  const urls = await getUrls();
  if (index < 0 || index >= urls.length) return;

  const origin = urls[index];
  const pattern = `${origin}/*`;

  urls.splice(index, 1);
  await saveUrls(urls);

  // Chrome may normalise the origin pattern when it stores optional host
  // permissions (e.g. "https://example.com/*" → "https://example.com/").
  // Look up the exact stored entry so the remove call matches precisely.
  const all = await chrome.permissions.getAll();
  const exactPattern =
    (all.origins ?? []).find(
      (o) => o === pattern || o.startsWith(`${origin}/`)
    ) ?? pattern;

  const removed = await chrome.permissions
    .remove({ origins: [exactPattern] })
    .catch(() => false);

  await renderUrlList();

  if (removed) {
    showStatus("success", `${origin} removed.`);
  } else {
    showStatus(
      "error",
      `${origin} removed from list, but the browser permission could not be revoked automatically. Remove it manually from the extension's site settings.`
    );
  }
}

// ── Status display ────────────────────────────────────────────────────────────

let statusTimer;

function showStatus(type, message) {
  const el = document.getElementById("status");
  el.textContent = message;
  el.className = `status ${type}`;

  clearTimeout(statusTimer);
  statusTimer = setTimeout(() => {
    el.textContent = "";
    el.className = "status";
  }, 4000);
}

// ── Init ─────────────────────────────────────────────────────────────────────

document.getElementById("add-form").addEventListener("submit", (e) => {
  e.preventDefault();
  addUrl(document.getElementById("url-input").value.trim());
});

renderUrlList();
