import { typeIcon } from "../utils/colors.js";

const SERVICE_LABELS = {
  breakfast_included: "🍳 Breakfast",
  pool: "🏊 Pool",
  spa_wellness: "💆 Spa",
  wine_tasting: "🍷 Wine tasting",
  pet_friendly: "🐾 Pets OK",
};

export function buildPopupHtml(props) {
  const price = props.price_per_bed != null
    ? `<div class="popup-price">${Math.round(props.price_per_bed).toLocaleString()} ${props.currency || "CZK"} / bed</div>`
    : `<div class="popup-price" style="color:#aaa">Price unknown</div>`;

  const stars = props.stars ? "⭐".repeat(props.stars) : "";
  const rating = props.rating ? `<span style="color:#f39c12">▲ ${props.rating}</span>` : "";

  const badges = Object.entries(SERVICE_LABELS)
    .filter(([key]) => props[key])
    .map(([, label]) => `<span class="badge">${label}</span>`)
    .join("");

  const link = props.source_url
    ? `<a class="popup-link" href="${props.source_url}" target="_blank" rel="noopener">View on ${props.source} ↗</a>`
    : "";

  return `
    <div class="popup-card">
      <h3>${typeIcon(props.type)} ${props.name}</h3>
      <span class="popup-type">${props.type || "accommodation"}</span>
      ${stars} ${rating}
      <div style="font-size:0.78rem;color:#666;margin-top:2px">${props.city || ""}</div>
      ${price}
      ${badges ? `<div class="popup-badges">${badges}</div>` : ""}
      ${link}
    </div>
  `;
}
