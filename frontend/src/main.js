import L from "leaflet";
import { buildMarkerLayer } from "./layers/markers.js";
import { buildHeatmapLayer } from "./layers/heatmap.js";
import { addLegend } from "./layers/legend.js";

const API_BASE = "/api";

// ── Map init ──────────────────────────────────────────────────────────────────
const map = L.map("map", {
  center: [49.1, 16.6],
  zoom: 9,
  zoomControl: true,
});

L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
  attribution: '© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
  maxZoom: 19,
}).addTo(map);

addLegend(map);

// ── State ─────────────────────────────────────────────────────────────────────
let currentMarkerLayer = null;
let currentHeatLayer = null;
let currentView = "markers";

const overlay = document.getElementById("loading-overlay");
const statsContent = document.getElementById("stats-content");

// ── Data fetching ─────────────────────────────────────────────────────────────
async function loadGeoJSON(filters = {}) {
  const params = new URLSearchParams();
  if (filters.type)       params.set("type", filters.type);
  if (filters.min_price)  params.set("min_price", filters.min_price);
  if (filters.max_price && filters.max_price < 5000) params.set("max_price", filters.max_price);

  const resp = await fetch(`${API_BASE}/map/geojson?${params}`);
  return resp.json();
}

async function loadStats() {
  const [summary, byType] = await Promise.all([
    fetch(`${API_BASE}/stats/summary`).then(r => r.json()),
    fetch(`${API_BASE}/stats/by-type`).then(r => r.json()),
  ]);
  return { summary, byType };
}

// ── Render ────────────────────────────────────────────────────────────────────
async function renderMarkers(filters = {}) {
  overlay.classList.remove("hidden");
  try {
    const geojson = await loadGeoJSON(filters);
    if (currentMarkerLayer) map.removeLayer(currentMarkerLayer);
    currentMarkerLayer = buildMarkerLayer(geojson);
    if (currentView === "markers") currentMarkerLayer.addTo(map);
  } finally {
    overlay.classList.add("hidden");
  }
}

async function renderHeatmap() {
  overlay.classList.remove("hidden");
  try {
    if (!currentHeatLayer) currentHeatLayer = await buildHeatmapLayer(API_BASE);
    if (currentView === "heatmap") currentHeatLayer.addTo(map);
  } finally {
    overlay.classList.add("hidden");
  }
}

async function renderStats() {
  try {
    const { summary, byType } = await loadStats();
    const fmt = (v) => v != null ? Number(v).toLocaleString("cs-CZ") : "–";

    let html = `
      <div class="stat-row"><span class="stat-label">Total listings</span><span class="stat-value">${fmt(summary.total_accommodations)}</span></div>
      <div class="stat-row"><span class="stat-label">Avg price/bed</span><span class="stat-value">${fmt(summary.avg_price_per_bed)} CZK</span></div>
      <div class="stat-row"><span class="stat-label">Min price/bed</span><span class="stat-value">${fmt(summary.min_price_per_bed)} CZK</span></div>
      <div class="stat-row"><span class="stat-label">Max price/bed</span><span class="stat-value">${fmt(summary.max_price_per_bed)} CZK</span></div>
      <br/><strong style="font-size:0.8rem;color:#555">By type (avg/bed)</strong><br/>
    `;
    for (const row of byType) {
      html += `<div class="stat-row"><span class="stat-label">${row.type || "other"}</span><span class="stat-value">${fmt(row.avg_price_per_bed)} CZK (${row.count})</span></div>`;
    }
    statsContent.innerHTML = html;
  } catch {
    statsContent.innerHTML = `<em style="color:#aaa">Stats unavailable</em>`;
  }
}

// ── View toggle ───────────────────────────────────────────────────────────────
document.querySelectorAll(".view-btn").forEach(btn => {
  btn.addEventListener("click", async () => {
    document.querySelectorAll(".view-btn").forEach(b => b.classList.remove("active"));
    btn.classList.add("active");
    currentView = btn.dataset.view;

    if (currentView === "markers") {
      if (currentHeatLayer) map.removeLayer(currentHeatLayer);
      if (currentMarkerLayer) currentMarkerLayer.addTo(map);
    } else {
      if (currentMarkerLayer) map.removeLayer(currentMarkerLayer);
      await renderHeatmap();
    }
  });
});

// ── Filters ───────────────────────────────────────────────────────────────────
const priceSlider = document.getElementById("filter-max-price");
const priceOutput = document.getElementById("price-output");
priceSlider.addEventListener("input", () => {
  priceOutput.textContent = `${Number(priceSlider.value).toLocaleString()} CZK`;
});

function getFilters() {
  return {
    type: document.getElementById("filter-type").value || undefined,
    max_price: Number(priceSlider.value),
    min_stars: document.getElementById("filter-stars").value || undefined,
    breakfast: document.getElementById("f-breakfast").checked || undefined,
    pool: document.getElementById("f-pool").checked || undefined,
    spa: document.getElementById("f-spa").checked || undefined,
    parking: document.getElementById("f-parking").checked || undefined,
  };
}

document.getElementById("apply-filters").addEventListener("click", () => {
  renderMarkers(getFilters());
  if (currentHeatLayer) { map.removeLayer(currentHeatLayer); currentHeatLayer = null; }
});

document.getElementById("reset-filters").addEventListener("click", () => {
  document.getElementById("filter-type").value = "";
  document.getElementById("filter-stars").value = "";
  priceSlider.value = 5000;
  priceOutput.textContent = "5000 CZK";
  ["f-breakfast", "f-pool", "f-spa", "f-parking", "f-wine", "f-pet"].forEach(id => {
    document.getElementById(id).checked = false;
  });
  renderMarkers();
});

// ── Boot ──────────────────────────────────────────────────────────────────────
(async () => {
  await Promise.all([renderMarkers(), renderStats()]);
})();
