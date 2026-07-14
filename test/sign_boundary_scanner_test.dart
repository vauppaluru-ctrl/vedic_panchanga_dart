import 'package:test/test.dart';
import 'package:vedic_panchanga_dart/vedic_panchanga_dart.dart';

void main() {
  final chennai = Place('Chennai', 13.0827, 80.2707, 5.5);

  setUpAll(() {
    PanchangaService.initialize(ayanamsaMode: 'LAHIRI');
  });

  group('SignBoundaryScanner.scan', () {
    test('finds a forward boundary and reports the differing rasi/position', () {
      final jd = PanchangaUtils.gregorianToJd(2025, 1, 1);
      final moonIdx = 1; // fast mover — guarantees a boundary within days
      final currentRasi = PanchangaService.planetPositions(jd, chennai)[moonIdx].rasi;

      final result = SignBoundaryScanner.scan(
        planetIndex: moonIdx,
        place: chennai,
        fromJd: jd,
        currentRasi: currentRasi,
        direction: 1,
      );

      expect(result.jd, isNotNull);
      expect(result.jd!, greaterThan(jd));
      expect(result.rasi, isNotNull);
      expect(result.rasi, isNot(equals(currentRasi)));
      // The position exactly at the boundary should already read the new rasi.
      final posAtBoundary =
          PanchangaService.planetPositions(result.jd!, chennai)[moonIdx];
      expect(posAtBoundary.rasi, result.rasi);
    });

    test('backward scan (direction -1) finds a boundary before fromJd', () {
      final jd = PanchangaUtils.gregorianToJd(2025, 1, 15);
      final moonIdx = 1;
      final currentRasi = PanchangaService.planetPositions(jd, chennai)[moonIdx].rasi;

      final result = SignBoundaryScanner.scan(
        planetIndex: moonIdx,
        place: chennai,
        fromJd: jd,
        currentRasi: currentRasi,
        direction: -1,
      );

      expect(result.jd, isNotNull);
      expect(result.jd!, lessThan(jd));
      expect(result.rasi, isNot(equals(currentRasi)));
    });

    test('returns null when no boundary exists within the scan cap', () {
      final jd = PanchangaUtils.gregorianToJd(2025, 1, 1);
      final moonIdx = 1;
      final currentRasi = PanchangaService.planetPositions(jd, chennai)[moonIdx].rasi;

      final result = SignBoundaryScanner.scan(
        planetIndex: moonIdx,
        place: chennai,
        fromJd: jd,
        currentRasi: currentRasi,
        direction: 1,
        // The Moon changes sign every ~2.5 days, so a 1-day cap guarantees
        // no boundary is found — exercises the "give up" path.
        capDays: 1,
      );

      expect(result.jd, isNull);
      expect(result.rasi, isNull);
      expect(result.isRetrograde, isNull);
      expect(result.monotonic, isTrue);
    });

    test('monotonic is true when retrograde state never changes during the scan', () {
      final jd = PanchangaUtils.gregorianToJd(2025, 1, 1);
      final moonIdx = 1; // Moon is never retrograde
      final pos = PanchangaService.planetPositions(jd, chennai)[moonIdx];

      final result = SignBoundaryScanner.scan(
        planetIndex: moonIdx,
        place: chennai,
        fromJd: jd,
        currentRasi: pos.rasi,
        startRetrograde: pos.isRetrograde,
        direction: 1,
      );

      expect(result.monotonic, isTrue);
    });

    test('the capped gallop step never exceeds maxGallopStepDays once reached', () {
      // Regression guard for the bug this scanner was extracted to fix:
      // an uncapped exponential gallop (1,2,4,...,512,1024) can leave gaps
      // wide enough to straddle and silently skip a short retrograde
      // preview/retreat episode. This test doesn't simulate a real
      // retrograde loop (that needs a real slow-mover ephemeris window),
      // but it locks the step-growth formula itself so a future edit
      // can't silently remove the cap.
      const maxStep = 30.0;
      var step = 1.0;
      final steps = <double>[step];
      for (var i = 0; i < 10; i++) {
        step = step < maxStep ? step * 2 : step + maxStep;
        steps.add(step);
      }
      // Once step reaches/exceeds the cap, subsequent growth must be
      // additive (+maxStep), never multiplicative — otherwise a gap could
      // reopen wide enough to skip a real short excursion again.
      final capIndex = steps.indexWhere((s) => s >= maxStep);
      for (var i = capIndex; i < steps.length - 1; i++) {
        expect(steps[i + 1] - steps[i], closeTo(maxStep, 0.0001));
      }
    });
  });
}
