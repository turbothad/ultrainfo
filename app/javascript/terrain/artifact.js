const SCHEMA_VERSION = 1
const PROJECTION = {
  type: "linear-lat-lng-bounds",
  x_axis: "longitude-west-to-east",
  z_axis: "latitude-north-to-south",
  elevation_unit: "feet"
}
const GENERATED_AT = /^(?<year>\d{4})-(?<month>0[1-9]|1[0-2])-(?<day>0[1-9]|[12]\d|3[01])T(?:[01]\d|2[0-3]):[0-5]\d:[0-5]\dZ$/

export async function loadTerrainArtifact(reference, { raceSlug }) {
  validateReference(reference)

  const response = await fetch(reference.path)
  if (!response.ok) throw new Error(`Terrain artifact request failed: HTTP ${response.status}`)

  const bytes = new Uint8Array(await response.arrayBuffer())
  const digest = await sha256(bytes)
  if (digest !== reference.sha256) throw new Error("Terrain artifact SHA-256 digest does not match")

  let artifact
  try {
    artifact = JSON.parse(new TextDecoder().decode(bytes))
  } catch (_error) {
    throw new Error("Terrain artifact JSON is invalid")
  }

  validateArtifact(artifact, { raceSlug })
  return artifact
}

function validateReference(reference) {
  if (!reference || reference.status !== "generated") invalid("reference status is invalid")
  if (typeof reference.path !== "string" || !reference.path.startsWith("/terrain/")) invalid("reference path is invalid")
  if (reference.schema_version !== SCHEMA_VERSION) invalid("reference schema version is unsupported")
  if (reference.projection !== PROJECTION.type) invalid("reference projection is unsupported")
  if (typeof reference.sha256 !== "string" || !/^[0-9a-f]{64}$/.test(reference.sha256)) invalid("reference SHA-256 digest is invalid")
}

function validateArtifact(artifact, { raceSlug }) {
  if (!artifact || artifact.schema_version !== SCHEMA_VERSION) invalid("schema version is unsupported")
  if (!sameProjection(artifact.projection)) invalid("projection is unsupported")
  if (artifact.race?.slug !== raceSlug) invalid("Race slug does not match")
  if (blank(artifact.race?.name)) invalid("Race name is missing")
  if (!Number.isInteger(artifact.race?.year)) invalid("Race year is missing")
  if (!validGeneratedAt(artifact.generated_at)) invalid("generated at metadata is invalid")
  if ([artifact.source?.label, artifact.source?.url, artifact.source?.attribution].some(blank)) invalid("source metadata is incomplete")

  const grid = artifact.grid
  if (!grid || !Number.isInteger(grid.size) || grid.size < 2) invalid("grid size is invalid")
  if (!Number.isInteger(grid.zoom)) invalid("grid zoom is missing")
  if (!Array.isArray(grid.elevations_ft) || grid.elevations_ft.length !== grid.size * grid.size) invalid("grid elevations do not match its size")
  if (!grid.elevations_ft.every(Number.isFinite)) invalid("grid elevations must be numeric")
  if (!Number.isFinite(grid.min_ft) || !Number.isFinite(grid.max_ft) || grid.min_ft > grid.max_ft) invalid("grid elevation range is invalid")

  const bounds = grid.bounds
  if (!bounds || ![bounds.min_lat, bounds.max_lat, bounds.min_lng, bounds.max_lng].every(Number.isFinite)) invalid("grid bounds are invalid")
  if (bounds.min_lat >= bounds.max_lat || bounds.min_lng >= bounds.max_lng) invalid("grid bounds are invalid")
  const segments = artifact.course_grade_profile?.segments
  if (!Array.isArray(segments)) invalid("course grade profile is invalid")
  for (const segment of segments) {
    if (!segment || !coordinatePair(segment.from) || !coordinatePair(segment.to)) invalid("course grade segment coordinates are invalid")
    if (!Number.isFinite(segment.grade_pct)) invalid("course grade segment grade is invalid")
    if (!["flat", "moderate", "steep"].includes(segment.steepness)) invalid("course grade segment steepness is invalid")
  }
}

function coordinatePair(value) {
  return Array.isArray(value) && value.length === 2 && value.every(Number.isFinite)
}

function blank(value) {
  return typeof value !== "string" || value.trim().length === 0
}

function validGeneratedAt(value) {
  const match = typeof value === "string" && value.match(GENERATED_AT)
  if (!match) return false

  const year = Number(match.groups.year)
  const month = Number(match.groups.month)
  const day = Number(match.groups.day)
  const daysInMonth = [31, leapYear(year) ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  return day <= daysInMonth[month - 1]
}

function leapYear(year) {
  return year % 4 === 0 && (year % 100 !== 0 || year % 400 === 0)
}

function sameProjection(projection) {
  return projection && Object.keys(projection).length === Object.keys(PROJECTION).length &&
    projection.type === PROJECTION.type &&
    projection.x_axis === PROJECTION.x_axis &&
    projection.z_axis === PROJECTION.z_axis &&
    projection.elevation_unit === PROJECTION.elevation_unit
}

async function sha256(bytes) {
  if (!globalThis.crypto?.subtle) throw new Error("Terrain artifact SHA-256 validation is unavailable")

  const digest = await globalThis.crypto.subtle.digest("SHA-256", bytes)
  return Array.from(new Uint8Array(digest), (byte) => byte.toString(16).padStart(2, "0")).join("")
}

function invalid(message) {
  throw new Error(`Invalid Terrain artifact: ${message}`)
}
