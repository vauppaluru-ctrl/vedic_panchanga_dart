import 'panchanga_models.dart';
import 'panchanga_service.dart';

/// Result of a [SignBoundaryScanner.scan] call.
class SignBoundaryScanResult {
  /// Julian Day of the boundary, or null if none was found within the scan
  /// cap (a transit already longer than the cap — safely treated as fully
  /// standing, with no boundary nearby). This is the DIFFERING side of the
  /// final bisection bracket — i.e. the first instant confirmed to already
  /// be in the new/different rasi.
  final double? jd;

  /// The other side of the same final bracket — the last instant still
  /// confirmed to be in `currentRasi`, i.e. just before the crossing. Both
  /// sides are within [SignBoundaryScanner.scan]'s `precisionDays` of the
  /// true crossing, so which one a caller wants is a matter of convention,
  /// not correctness — exposed so a caller migrating from a scanner that
  /// picked the other side can reproduce its exact prior date instead of
  /// silently shifting by a fraction of a day. Null iff [jd] is null.
  final double? sameSideJd;

  /// The rasi (1-12) on the OTHER side of the boundary from where the scan
  /// started — null if [jd] is null.
  final int? rasi;

  /// The planet's retrograde state on the other side of the boundary —
  /// null if [jd] is null.
  final bool? isRetrograde;

  /// False if the planet's retrograde state ever differed from
  /// [SignBoundaryScanner.scan]'s `startRetrograde` at any point actually
  /// sampled during the scan (only meaningful when `startRetrograde` was
  /// supplied — always true otherwise). See [SignBoundaryScanner.scan]'s
  /// doc comment for what a non-monotonic result means and why callers
  /// should usually discard the date when it's false.
  final bool monotonic;

  const SignBoundaryScanResult({
    required this.jd,
    required this.sameSideJd,
    required this.rasi,
    required this.isRetrograde,
    required this.monotonic,
  });
}

/// Finds the Julian Day a planet's zodiac sign (rasi) changes, without
/// sampling every day one at a time.
///
/// Gallops outward from a known starting point (doubling the day offset
/// each step, capped at [SignBoundaryScanner.maxGallopStepDays] of growth)
/// until the rasi differs from the start, then bisects that bracket down
/// to [SignBoundaryScanner.defaultPrecisionDays] — cheap even for
/// Rahu/Ketu's ~2-year-per-sign transits (a handful of ephemeris
/// evaluations, not hundreds of linear day-steps).
///
/// The gallop step is capped rather than left to grow unboundedly, because
/// an uncapped exponential step (1, 2, 4, ... 512, 1024 days) can leave
/// gaps wide enough to straddle an ENTIRE short retrograde preview/retreat
/// episode — a slow mover dips into the next sign, stations retrograde,
/// and backs out — without any sample ever landing inside it, silently
/// erasing that episode from a result built by repeated calls. Real
/// preview windows for slow movers run weeks to months, so capping growth
/// at [maxGallopStepDays] guarantees a sample lands inside any episode of
/// that length or longer, while keeping the sample count bounded (a
/// ~900-day sign occupancy costs a handful of exponential samples plus a
/// few dozen linear ones, not hundreds).
class SignBoundaryScanner {
  static const double defaultCapDays = 1200;
  static const double defaultMaxGallopStepDays = 30;
  static const double defaultPrecisionDays = 1.0;

  /// Scans from [fromJd] (where [planetIndex] occupies [currentRasi]) in
  /// [direction] (+1 = forward in time, -1 = backward) for the nearest
  /// Julian Day where its rasi differs.
  ///
  /// Pass [startRetrograde] (the planet's retrograde state at [fromJd]) to
  /// get a [SignBoundaryScanResult.monotonic] signal: it comes back false
  /// if the retrograde state ever flips during the scan, meaning a planet
  /// stationed and reversed somewhere in the scanned range — a single
  /// scalar boundary date is unsafe to report as-is in that case (it may
  /// describe a multi-pass loop, not one clean crossing). Omit it (leave
  /// null) if you don't need that signal; `monotonic` is then always true.
  static SignBoundaryScanResult scan({
    required int planetIndex,
    required Place place,
    required double fromJd,
    required int currentRasi,
    int direction = 1,
    bool? startRetrograde,
    double capDays = defaultCapDays,
    double maxGallopStepDays = defaultMaxGallopStepDays,
    double precisionDays = defaultPrecisionDays,
  }) {
    var monotonic = true;
    var sameJd = fromJd;
    double? diffJd;
    PlanetPosition? diffPos;
    var step = 1.0;

    while (step <= capDays) {
      final sampleJd = fromJd + direction * step;
      final pos = PanchangaService.planetPositions(sampleJd, place)[planetIndex];
      if (startRetrograde != null && pos.isRetrograde != startRetrograde) {
        monotonic = false;
      }
      if (pos.rasi != currentRasi) {
        diffJd = sampleJd;
        diffPos = pos;
        break;
      }
      sameJd = sampleJd;
      step = step < maxGallopStepDays ? step * 2 : step + maxGallopStepDays;
    }
    if (diffJd == null) {
      return SignBoundaryScanResult(
          jd: null, sameSideJd: null, rasi: null, isRetrograde: null, monotonic: monotonic);
    }

    var lo = sameJd;
    var hi = diffJd;
    var hiPos = diffPos!;
    while ((hi - lo).abs() > precisionDays) {
      final mid = (lo + hi) / 2;
      final pos = PanchangaService.planetPositions(mid, place)[planetIndex];
      if (startRetrograde != null && pos.isRetrograde != startRetrograde) {
        monotonic = false;
      }
      if (pos.rasi == currentRasi) {
        lo = mid;
      } else {
        hi = mid;
        hiPos = pos;
      }
    }
    return SignBoundaryScanResult(
      jd: hi,
      sameSideJd: lo,
      rasi: hiPos.rasi,
      isRetrograde: hiPos.isRetrograde,
      monotonic: monotonic,
    );
  }
}
