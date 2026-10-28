// Formata segundos como mm:ss (ex.: 74 → "01:14").
export default function formatTime(seconds) {
  const minutes = Math.floor(seconds / 60) || 0;
  const secs = Math.floor(seconds - 60 * minutes) || 0;
  return (minutes < 10 ? "0" : "") + minutes + ":" + (secs < 10 ? "0" : "") + secs;
}
