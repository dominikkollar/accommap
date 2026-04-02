/**
 * Price-to-colour mapping for map markers.
 * Price bands are in CZK per bed per night.
 */
export const PRICE_BANDS = [
  { max: 500,  color: "#2dc653", label: "< 500 CZK" },
  { max: 1000, color: "#57cc99", label: "500–1000 CZK" },
  { max: 1500, color: "#f4d03f", label: "1000–1500 CZK" },
  { max: 2500, color: "#f39c12", label: "1500–2500 CZK" },
  { max: 4000, color: "#e74c3c", label: "2500–4000 CZK" },
  { max: Infinity, color: "#8e44ad", label: "> 4000 CZK" },
];

export function priceColor(pricePerBed) {
  if (pricePerBed == null) return "#aaa";
  for (const band of PRICE_BANDS) {
    if (pricePerBed <= band.max) return band.color;
  }
  return "#8e44ad";
}

export function typeIcon(type) {
  const icons = {
    hotel:     "🏨",
    pension:   "🏡",
    hostel:    "🛏️",
    apartment: "🏢",
    agro:      "🌾",
    wellness:  "💆",
    camping:   "⛺",
    winery:    "🍷",
    other:     "📍",
  };
  return icons[type] || "📍";
}
