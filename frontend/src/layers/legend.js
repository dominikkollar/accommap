import L from "leaflet";
import { PRICE_BANDS } from "../utils/colors.js";

export function addLegend(map) {
  const legend = L.control({ position: "bottomright" });

  legend.onAdd = function () {
    const div = L.DomUtil.create("div", "price-legend");
    div.innerHTML = `
      <h4>Price / bed / night</h4>
      ${PRICE_BANDS.map(b =>
        `<div class="legend-item">
          <div class="legend-dot" style="background:${b.color}"></div>
          <span>${b.label}</span>
        </div>`
      ).join("")}
      <div class="legend-item" style="margin-top:4px">
        <div class="legend-dot" style="background:#aaa"></div>
        <span>Price unknown</span>
      </div>
    `;
    return div;
  };

  legend.addTo(map);
  return legend;
}
