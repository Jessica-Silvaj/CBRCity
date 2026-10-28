const resourceName = typeof GetParentResourceName === "function" ? GetParentResourceName() : "Night_Hit";
const isFiveM = typeof GetParentResourceName === "function";
const sounds = {};
const activeHitFeeds = new Map();
const defaults = Object.freeze({
  soundId: 0,
  visualState: 0,
  hitFeedState: false,
  bodySound: 0,
  volume: 0.5,
  color: "#2E8B57",
});

let state = { ...defaults };
let saveTimer = null;
let panelOpen = false;
let visualTimer = null;

const panel = document.getElementById("settings-panel");
const volumeSlider = document.getElementById("volume-slider");
const volumeLabel = document.getElementById("vol-label");
const hitFeedToggle = document.getElementById("hitfeed-toggle");
const colorPicker = document.getElementById("theme-color");
const colorValue = document.getElementById("color-value");
const saveState = document.getElementById("save-state");
const saveStateText = document.getElementById("save-state-text");
const hitmarker = document.getElementById("hitmarker-container");

async function post(endpoint, payload = {}) {
  if (!isFiveM) return { ok: true, preview: true };

  try {
    const response = await fetch(`https://${resourceName}/${endpoint}`, {
      method: "POST",
      headers: { "Content-Type": "application/json; charset=UTF-8" },
      body: JSON.stringify(payload),
    });

    if (!response.ok) return null;
    const text = await response.text();
    return text ? JSON.parse(text) : { ok: true };
  } catch (_) {
    return null;
  }
}

function clamp(value, min, max, fallback) {
  const number = Number(value);
  return Number.isFinite(number) ? Math.min(max, Math.max(min, number)) : fallback;
}

function normalizeColor(value) {
  const color = String(value || "").toUpperCase();
  return /^#[0-9A-F]{6}$/.test(color) ? color : defaults.color;
}

function normalizeSettings(input = {}) {
  return {
    soundId: Math.floor(clamp(input.soundId, 0, 11, defaults.soundId)),
    visualState: Math.floor(clamp(input.visualState, 0, 5, defaults.visualState)),
    hitFeedState: input.hitFeedState === true,
    bodySound: Math.floor(clamp(input.bodySound, 0, 10, defaults.bodySound)),
    volume: clamp(input.volume, 0, 1, defaults.volume),
    color: normalizeColor(input.color),
  };
}

function hexToRgb(hex) {
  const value = parseInt(hex.slice(1), 16);
  return `${(value >> 16) & 255}, ${(value >> 8) & 255}, ${value & 255}`;
}

function setThemeColor(color) {
  state.color = normalizeColor(color);
  document.documentElement.style.setProperty("--accent", state.color);
  document.documentElement.style.setProperty("--accent-rgb", hexToRgb(state.color));
  colorPicker.value = state.color;
  colorValue.textContent = state.color;
}

function loadAudio(id, path) {
  const audio = new Audio(path);
  audio.preload = "auto";
  audio.volume = state.volume;
  sounds[id] = audio;
}

for (let index = 1; index <= 10; index += 1) loadAudio(index, `sounds/kill${index}.mp3`);
for (let index = 1; index <= 5; index += 1) loadAudio(50 + index, `sounds/valorant${index}.mp3`);

function playSound(id) {
  const audio = sounds[id];
  if (!audio) return;
  const preview = audio.cloneNode();
  preview.volume = state.volume;
  preview.play().catch(() => { });
}

function triggerVisual(id) {
  const effect = Math.floor(clamp(id, 0, 5, 0));
  if (effect <= 0) return;

  if (visualTimer) clearTimeout(visualTimer);
  hitmarker.classList.remove("trigger");
  hitmarker.dataset.effect = "0";
  void hitmarker.offsetWidth;
  hitmarker.dataset.effect = String(effect);
  hitmarker.classList.add("trigger");

  const cleanupDelay = document.documentElement.classList.contains("effect-preview") ? 6000 : 900;
  visualTimer = setTimeout(() => {
    hitmarker.classList.remove("trigger");
    hitmarker.dataset.effect = "0";
    visualTimer = null;
  }, cleanupDelay);
}

function setActive(selector, id) {
  document.querySelectorAll(selector).forEach((button) => {
    button.classList.toggle("active", Number(button.dataset.id) === id);
  });
}

function renderState() {
  const percentage = Math.round(state.volume * 100);
  volumeSlider.value = String(percentage);
  volumeLabel.textContent = `${percentage}%`;
  hitFeedToggle.checked = state.hitFeedState;
  Object.values(sounds).forEach((audio) => { audio.volume = state.volume; });
  setThemeColor(state.color);
  setActive(".sound-option", state.soundId);
  setActive(".hit-sound-option", state.bodySound);
  setActive(".visual-option", state.visualState);
}

function showSaveState(text, saving = false) {
  saveStateText.textContent = text;
  saveState.classList.toggle("saving", saving);
}

async function saveSettings(immediate = false) {
  if (saveTimer) {
    clearTimeout(saveTimer);
    saveTimer = null;
  }

  if (!immediate) {
    showSaveState("SALVANDO...", true);
    saveTimer = setTimeout(() => saveSettings(true), 180);
    return;
  }

  showSaveState("SALVANDO...", true);
  const result = await post("saveSettings", state);
  showSaveState(result && result.ok ? "ALTERAÇÕES APLICADAS" : "ERRO AO SALVAR", false);
}

function openPanel(settings) {
  state = normalizeSettings(settings);
  renderState();
  showSaveState("CONFIGURAÇÕES CARREGADAS", false);
  panel.style.display = "flex";
  requestAnimationFrame(() => panel.classList.add("visible"));
  panelOpen = true;
}

async function closePanel() {
  if (!panelOpen) return;
  panelOpen = false;
  panel.classList.remove("visible");
  await saveSettings(true);
  await post("closeUiCallback");
  setTimeout(() => {
    if (!panelOpen) panel.style.display = "none";
  }, 150);
}

volumeSlider.addEventListener("input", () => {
  state.volume = Number(volumeSlider.value) / 100;
  volumeLabel.textContent = `${volumeSlider.value}%`;
  Object.values(sounds).forEach((audio) => { audio.volume = state.volume; });
  saveSettings();
});

hitFeedToggle.addEventListener("change", () => {
  state.hitFeedState = hitFeedToggle.checked;
  saveSettings();
});

colorPicker.addEventListener("input", () => {
  setThemeColor(colorPicker.value);
  saveSettings();
});

document.querySelectorAll(".hit-sound-option").forEach((button) => {
  button.addEventListener("click", () => {
    state.bodySound = Number(button.dataset.id);
    setActive(".hit-sound-option", state.bodySound);
    if (state.bodySound > 0) playSound(state.bodySound);
    saveSettings();
  });
});

document.querySelectorAll(".sound-option").forEach((button) => {
  button.addEventListener("click", () => {
    state.soundId = Number(button.dataset.id);
    setActive(".sound-option", state.soundId);
    if (state.soundId > 0) playSound(state.soundId === 11 ? 51 : state.soundId);
    saveSettings();
  });
});

document.querySelectorAll(".visual-option").forEach((button) => {
  button.addEventListener("click", () => {
    state.visualState = Number(button.dataset.id);
    setActive(".visual-option", state.visualState);
    triggerVisual(state.visualState);
    saveSettings();
  });
});

document.getElementById("reset-settings-btn").addEventListener("click", () => {
  state = { ...defaults };
  renderState();
  saveSettings(true);
});

document.getElementById("close-btn").addEventListener("click", closePanel);
document.addEventListener("keyup", (event) => {
  if (event.key === "Escape") closePanel();
});

function showHitFeed(passport) {
  const container = document.getElementById("hitfeed-container");
  const key = String(passport);
  const previous = activeHitFeeds.get(key);
  if (previous) previous.remove();

  const item = document.createElement("div");
  item.className = "hitfeed-item";
  item.innerHTML = '<svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="8"/><circle cx="12" cy="12" r="3"/><path d="M12 2v3m0 14v3M2 12h3m14 0h3"/></svg><div><small>JOGADOR ATINGIDO</small><strong></strong></div>';
  item.querySelector("strong").textContent = `PASSAPORTE ${key}`;
  container.appendChild(item);
  activeHitFeeds.set(key, item);

  setTimeout(() => {
    if (activeHitFeeds.get(key) === item) activeHitFeeds.delete(key);
    item.remove();
  }, 2500);
}

window.addEventListener("message", ({ data }) => {
  if (!data || typeof data !== "object") return;

  if (data.action === "openUi") {
    openPanel(data.settings || {
      soundId: data.currentSound,
      visualState: data.currentVisual,
      hitFeedState: data.currentHitFeed,
      bodySound: data.bodySound,
      volume: data.volumeLvl,
      color: data.color,
    });
  } else if (data.action === "syncSettings") {
    state = normalizeSettings(data.settings);
    renderState();
  } else if (data.action === "playKillEffect") {
    if (Number(data.soundType) > 0) playSound(Number(data.soundType));
    triggerVisual(Number(data.playVisual));
  } else if (data.action === "playHitSound") {
    const soundType = Math.floor(clamp(data.soundType, 0, 10, state.bodySound));
    if (soundType > 0) playSound(soundType);
  } else if (data.action === "showHitFeed") {
    showHitFeed(data.targetId);
  }
});

renderState();

if (isFiveM) post("nuiReady");

// Permite revisar a interface diretamente no navegador com ?preview=1.
const previewParams = new URLSearchParams(window.location.search);
if (previewParams.has("preview")) {
  openPanel(defaults);
}

if (previewParams.has("effect")) {
  document.documentElement.classList.add("effect-preview");
  panel.style.display = "none";
  panelOpen = false;
  setTimeout(() => triggerVisual(Number(previewParams.get("effect"))), 50);
}
