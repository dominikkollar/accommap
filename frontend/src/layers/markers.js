import L from "leaflet";
import "leaflet.markercluster";
import { priceColor, typeIcon } from "../utils/colors.js";
import { buildPopupHtml } from "../components/popup.js";

function createCircleMarker(feature) {
  const { lat, lng } = { lat: feature.geometry.coordinates[1], lng: feature.geometry.coordinates[0] };
  const props = feature.properties;
  const color = priceColor(props.price_per_bed);

  return L.circleMarker([lat, lng], {
    radius: 8,
    fillColor: color,
    color: "#fff",
    weight: 1.5,
    opacity: 1,
    fillOpacity: 0.85,
  }).bindPopup(buildPopupHtml(props), { maxWidth: 280 });
}

export function buildMarkerLayer(geojson) {
  const cluster = L.markerClusterGroup({
    maxClusterRadius: 50,
    iconCreateFunction(cluster) {
      const count = cluster.getChildCount();
      return L.divIcon({
        html: `<div class="cluster-icon">${count}</div>`,
        className: "",
        iconSize: L.point(36, 36),
      });
    },
  });

  L.geoJSON(geojson, {
    pointToLayer(feature, latlng) {
      return createCircleMarker(feature);
    },
  }).addTo(cluster);

  return cluster;
}
