/**
 * Defensive JSON helpers.
 *
 * A single malformed metadata/context row must never abort a whole search,
 * traversal, or session startup — all callers go through these helpers.
 */

/**
 * Parse a JSON string without throwing.
 * Non-string values are returned as-is (already-parsed objects pass through).
 *
 * @param {*} value
 * @param {*} fallback - returned when value is null/undefined or malformed
 */
export function safeJsonParse(value, fallback = null) {
  if (value == null) return fallback;
  if (typeof value !== 'string') return value;
  try {
    return JSON.parse(value);
  } catch {
    return fallback;
  }
}

/**
 * Parse a metadata/context column into a plain object.
 * Always returns an object (never null / array) so callers can read keys safely.
 */
export function parseMetadata(value) {
  const parsed = safeJsonParse(value, null);
  return parsed && typeof parsed === 'object' && !Array.isArray(parsed) ? parsed : {};
}
