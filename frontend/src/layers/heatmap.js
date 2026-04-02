import L from "leaflet";
// leaflet.heat must be imported after leaflet
import "leaflet.heat";

export async function buildHeatmapLayer(apiBase = "/api") {
  const resp = await fetch(`${apiBase}/map/heatmap`);
  const points = await resp.json(); // [[lat, lng, intensity], ...]

  return L.heatLayer(points, {
    radius: 25,
    blur: 15,
    maxZoom: 13,
    gradient: {
      0.0: "#2dc653",
      0.3: "#57cc99",
      0.5: "#f4d03f",
      0.7: "#f39c12",
      1.0: "#e74c3c",
    },
  });
}
