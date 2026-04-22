import 'package:test/test.dart';
import 'package:vedic_panchanga_dart/src/compatibility/compatibility_constants.dart';
import 'package:vedic_panchanga_dart/src/compatibility/compatibility_models.dart';
import 'package:vedic_panchanga_dart/src/compatibility/ashtakoota.dart';

void main() {
  // ─── Utility function tests ───────────────────────────────────────────

  group('raasiFromNakshatraPada', () {
    test('Ashwini P1 → Mesha (1)', () {
      expect(Ashtakoota.raasiFromNakshatraPada(1, 1), 1);
    });
    test('Revati P4 → Meena (12)', () {
      expect(Ashtakoota.raasiFromNakshatraPada(27, 4), 12);
    });
    test('Krittika P1 → Mesha (1)', () {
      expect(Ashtakoota.raasiFromNakshatraPada(3, 1), 1);
    });
    test('Krittika P2 → Vrishabha (2)', () {
      expect(Ashtakoota.raasiFromNakshatraPada(3, 2), 2);
    });
  });

  group('countStars', () {
    test('same star returns 1', () {
      expect(Ashtakoota.countStars(1, 1), 1);
    });
    test('27 to 1 wraps to 2', () {
      expect(Ashtakoota.countStars(27, 1), 2);
    });
    test('1 to 27 returns 27', () {
      expect(Ashtakoota.countStars(1, 27), 27);
    });
    test('13 to 15 returns 3', () {
      expect(Ashtakoota.countStars(13, 15), 3);
    });
  });

  group('countRasis', () {
    test('same rasi returns 1', () {
      expect(Ashtakoota.countRasis(1, 1), 1);
    });
    test('12 to 1 wraps to 2', () {
      expect(Ashtakoota.countRasis(12, 1), 2);
    });
  });

  // ─── Test Case 1: Ashwini(1) P1 × Swati(15) P1 — North ──────────────

  group('Test 1: Ashwini(1) P1 × Swati(15) P1 — North', () {
    late CompatibilityResult result;
    setUp(() {
      final ak = Ashtakoota(
        person1Nakshatra: 1,
        person1Pada: 1,
        person2Nakshatra: 15,
        person2Pada: 1,
      );
      result = ak.computeCompatibility();
    });

    test('total score = 27.0', () {
      expect(result.totalScore, 27.0);
    });
    test('varna = 1', () {
      expect(result.kootaResults[0].score, 1.0);
    });
    test('vasiya = 0.5', () {
      expect(result.kootaResults[1].score, 0.5);
    });
    test('tara = 1.5', () {
      expect(result.kootaResults[2].score, 1.5);
    });
    test('gana = 6', () {
      expect(result.kootaResults[3].score, 6.0);
    });
    test('yoni = 0', () {
      expect(result.kootaResults[4].score, 0.0);
    });
    test('maitri = 3.0', () {
      expect(result.kootaResults[5].score, 3.0);
    });
    test('bhakut = 7', () {
      expect(result.kootaResults[6].score, 7.0);
    });
    test('nadi = 8', () {
      expect(result.kootaResults[7].score, 8.0);
    });
    test('mahendra = false', () {
      expect(result.naaluPoruthamChecks[0].passed, false);
    });
    test('vedha = true', () {
      expect(result.naaluPoruthamChecks[1].passed, true);
    });
    test('rajju = true', () {
      expect(result.naaluPoruthamChecks[2].passed, true);
    });
    test('sthree dheerga = true', () {
      expect(result.naaluPoruthamChecks[3].passed, true);
    });
    test('verdict = Very Good Match', () {
      expect(result.verdict, 'Very Good Match');
    });
  });

  // ─── Test Case 2: Hasta(13) P1 × Bharani(2) P1 — North ──────────────

  group('Test 2: Hasta(13) P1 × Bharani(2) P1 — North', () {
    late CompatibilityResult result;
    setUp(() {
      final ak = Ashtakoota(
        person1Nakshatra: 13,
        person1Pada: 1,
        person2Nakshatra: 2,
        person2Pada: 1,
      );
      result = ak.computeCompatibility();
    });

    test('total score = 18.5', () {
      expect(result.totalScore, 18.5);
    });
    test('varna = 0', () {
      expect(result.kootaResults[0].score, 0.0);
    });
    test('vasiya = 0.5', () {
      expect(result.kootaResults[1].score, 0.5);
    });
    test('tara = 1.5', () {
      expect(result.kootaResults[2].score, 1.5);
    });
    test('gana = 5', () {
      expect(result.kootaResults[3].score, 5.0);
    });
    test('yoni = 3', () {
      expect(result.kootaResults[4].score, 3.0);
    });
    test('maitri = 0.5', () {
      expect(result.kootaResults[5].score, 0.5);
    });
    test('bhakut = 0', () {
      expect(result.kootaResults[6].score, 0.0);
    });
    test('nadi = 8', () {
      expect(result.kootaResults[7].score, 8.0);
    });
    test('mahendra = false', () {
      expect(result.naaluPoruthamChecks[0].passed, false);
    });
    test('vedha = true', () {
      expect(result.naaluPoruthamChecks[1].passed, true);
    });
    test('rajju = true', () {
      expect(result.naaluPoruthamChecks[2].passed, true);
    });
    test('sthree dheerga = false', () {
      expect(result.naaluPoruthamChecks[3].passed, false);
    });
  });

  // ─── Test Case 3: Mrigashira(5) P2 × Mrigashira(5) P2 — North ───────

  group('Test 3: Mrigashira(5) P2 × Mrigashira(5) P2 — North', () {
    late CompatibilityResult result;
    setUp(() {
      final ak = Ashtakoota(
        person1Nakshatra: 5,
        person1Pada: 2,
        person2Nakshatra: 5,
        person2Pada: 2,
      );
      result = ak.computeCompatibility();
    });

    test('total score = 25.0', () {
      expect(result.totalScore, 25.0);
    });
    test('varna = 1', () {
      expect(result.kootaResults[0].score, 1.0);
    });
    test('vasiya = 2.0', () {
      expect(result.kootaResults[1].score, 2.0);
    });
    test('tara = 0.0', () {
      expect(result.kootaResults[2].score, 0.0);
    });
    test('gana = 6', () {
      expect(result.kootaResults[3].score, 6.0);
    });
    test('yoni = 4', () {
      expect(result.kootaResults[4].score, 4.0);
    });
    test('maitri = 5.0', () {
      expect(result.kootaResults[5].score, 5.0);
    });
    test('bhakut = 7', () {
      expect(result.kootaResults[6].score, 7.0);
    });
    test('nadi = 0', () {
      expect(result.kootaResults[7].score, 0.0);
    });
    test('mahendra = false', () {
      expect(result.naaluPoruthamChecks[0].passed, false);
    });
    test('vedha = true', () {
      expect(result.naaluPoruthamChecks[1].passed, true);
    });
    test('rajju = false', () {
      expect(result.naaluPoruthamChecks[2].passed, false);
    });
    test('sthree dheerga = false', () {
      expect(result.naaluPoruthamChecks[3].passed, false);
    });
  });

  // ─── Test Case 4: Ashwini(1) P1 × Revati(27) P4 — North ─────────────

  group('Test 4: Ashwini(1) P1 × Revati(27) P4 — North', () {
    late CompatibilityResult result;
    setUp(() {
      final ak = Ashtakoota(
        person1Nakshatra: 1,
        person1Pada: 1,
        person2Nakshatra: 27,
        person2Pada: 4,
      );
      result = ak.computeCompatibility();
    });

    test('total score = 22.0', () {
      expect(result.totalScore, 22.0);
    });
    test('varna = 0', () {
      expect(result.kootaResults[0].score, 0.0);
    });
    test('vasiya = 1.0', () {
      expect(result.kootaResults[1].score, 1.0);
    });
    test('tara = 0.0', () {
      expect(result.kootaResults[2].score, 0.0);
    });
    test('gana = 6', () {
      expect(result.kootaResults[3].score, 6.0);
    });
    test('yoni = 2', () {
      expect(result.kootaResults[4].score, 2.0);
    });
    test('maitri = 5.0', () {
      expect(result.kootaResults[5].score, 5.0);
    });
    test('bhakut = 0', () {
      expect(result.kootaResults[6].score, 0.0);
    });
    test('nadi = 8', () {
      expect(result.kootaResults[7].score, 8.0);
    });
    test('mahendra = false', () {
      expect(result.naaluPoruthamChecks[0].passed, false);
    });
    test('vedha = false', () {
      expect(result.naaluPoruthamChecks[1].passed, false);
    });
    test('rajju = false', () {
      expect(result.naaluPoruthamChecks[2].passed, false);
    });
    test('sthree dheerga = false', () {
      expect(result.naaluPoruthamChecks[3].passed, false);
    });
  });

  // ─── Test Case 5: Hasta(13) P1 × Bharani(2) P1 — South ──────────────

  group('Test 5: Hasta(13) P1 × Bharani(2) P1 — South', () {
    late CompatibilityResult result;
    setUp(() {
      final ak = Ashtakoota(
        person1Nakshatra: 13,
        person1Pada: 1,
        person2Nakshatra: 2,
        person2Pada: 1,
        method: CompatibilityMethod.south,
      );
      result = ak.computeCompatibility();
    });

    test('total score = 7', () {
      expect(result.totalScore, 7.0);
    });
    test('method is south', () {
      expect(result.method, CompatibilityMethod.south);
    });
    test('varna = false', () {
      expect(result.kootaResults[0].score, 0.0); // false
    });
    test('vasiya = false', () {
      expect(result.kootaResults[1].score, 0.0); // false
    });
    test('gana = true', () {
      expect(result.kootaResults[2].score, 1.0); // true
    });
    test('dina = true', () {
      expect(result.kootaResults[3].score, 1.0); // true
    });
    test('yoni = true', () {
      expect(result.kootaResults[4].score, 1.0); // true
    });
    test('maitri = true', () {
      expect(result.kootaResults[5].score, 1.0); // true
    });
    test('rasi = false', () {
      expect(result.kootaResults[6].score, 0.0); // false
    });
    test('nadi = true', () {
      expect(result.kootaResults[7].score, 1.0); // true
    });
    test('southPoruthamChecks has 10 items', () {
      expect(result.southPoruthamChecks!.length, 10);
    });
    test('mahendra = false', () {
      expect(result.naaluPoruthamChecks[0].passed, false);
    });
    test('vedha = true', () {
      expect(result.naaluPoruthamChecks[1].passed, true);
    });
    test('rajju = true', () {
      expect(result.naaluPoruthamChecks[2].passed, true);
    });
    test('sthree dheerga = true', () {
      expect(result.naaluPoruthamChecks[3].passed, true);
    });
    test('minimum porutham = false', () {
      expect(result.minimumPorutham, false);
    });
  });
}
