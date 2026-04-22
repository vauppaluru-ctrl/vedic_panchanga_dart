// Core Ashtakoota compatibility engine.
// Clean-room reimplementation of public-domain Vedic astrological formulas.

import 'compatibility_constants.dart';
import 'compatibility_models.dart';

/// Computes marriage compatibility using the Ashtakoota (8-factor) system.
///
/// Supports both North Indian (36-point scored) and South Indian
/// (10-point pass/fail Dasha Porutham) methods.
class Ashtakoota {
  final int person1Nakshatra; // 1-27
  final int person1Pada; // 1-4
  final int person2Nakshatra; // 1-27
  final int person2Pada; // 1-4
  final CompatibilityMethod method;

  late final int person1Rasi;
  late final int person2Rasi;
  late final int _countFromPerson2; // count from person2 to person1
  late final int _countFromPerson1; // count from person1 to person2

  Ashtakoota({
    required this.person1Nakshatra,
    required this.person1Pada,
    required this.person2Nakshatra,
    required this.person2Pada,
    this.method = CompatibilityMethod.north,
  }) {
    person1Rasi = raasiFromNakshatraPada(person1Nakshatra, person1Pada);
    person2Rasi = raasiFromNakshatraPada(person2Nakshatra, person2Pada);
    _countFromPerson2 = countStars(person2Nakshatra, person1Nakshatra);
    _countFromPerson1 = countStars(person1Nakshatra, person2Nakshatra);
  }

  // ─── Utility functions ──────────────────────────────────────────────────

  /// Count stars from [fromStar] to [toStar] (both 1-based, inclusive).
  /// Returns 1 when from == to.
  static int countStars(int fromStar, int toStar) {
    return ((toStar + 27 - fromStar) % 27) + 1;
  }

  /// Count rasis from [fromRasi] to [toRasi] (both 1-based, inclusive).
  static int countRasis(int fromRasi, int toRasi) {
    return ((toRasi + 12 - fromRasi) % 12) + 1;
  }

  /// Derive rasi number (1-12) from nakshatra (1-27) and pada (1-4).
  static int raasiFromNakshatraPada(int nakshatra, int pada) {
    const nakshatraDuration = 360.0 / 27.0; // ~13.333°
    const raasiDuration = 360.0 / 12.0; // 30°
    final padhaDuration = nakshatraDuration / 4.0; // ~3.333°
    final totalDuration = (nakshatra - 1) * nakshatraDuration +
        (pada - 1) * padhaDuration +
        0.5 * padhaDuration;
    return (totalDuration / raasiDuration).toInt() + 1;
  }

  // ─── 8 Koota scoring methods ────────────────────────────────────────────

  /// Varna Koota (max 1 pt North, bool South).
  (double, double) _varnaScoreNorth() {
    final bv = vasiyaRaasiList[person1Rasi - 1];
    final gv = vasiyaRaasiList[person2Rasi - 1];
    return (varnaArray[gv][bv].toDouble(), varnaMaxScore.toDouble());
  }

  bool _varnaPoruthamSouth() {
    final bv = vasiyaRaasiList[person1Rasi - 1];
    final gv = vasiyaRaasiList[person2Rasi - 1];
    return varnaArray[gv][bv] == 1;
  }

  /// Vasiya Koota (max 2 pts North, bool South).
  (double, double) _vasiyaScoreNorth() {
    final bCat = _vasiyaCategoryNorth(person1Rasi, person1Pada);
    final gCat = _vasiyaCategoryNorth(person2Rasi, person2Pada);
    return (vasiyaArray[gCat][bCat], vasiyaMaxScore);
  }

  bool _vasiyaPoruthamSouth() {
    return vasiyaListSouth[person2Rasi - 1].contains(person1Rasi - 1);
  }

  int _vasiyaCategoryNorth(int rasi, int pada) {
    // Chatushpada: rasi 1,2 or (rasi 9 + pada 3,4) or (rasi 10 + pada 1,2)
    if (rasi == 1 || rasi == 2) return 0;
    if (rasi == 9 && (pada == 3 || pada == 4)) return 0;
    if (rasi == 10 && (pada == 1 || pada == 2)) return 0;
    // Manava: rasi 3,6,7,11 or (rasi 9 + pada 1,2)
    if (rasi == 3 || rasi == 6 || rasi == 7 || rasi == 11) return 1;
    if (rasi == 9 && (pada == 1 || pada == 2)) return 1;
    // Jalachara: rasi 4,12 or (rasi 10 + pada 3,4)
    if (rasi == 4 || rasi == 12) return 2;
    if (rasi == 10 && (pada == 3 || pada == 4)) return 2;
    // Vanachara: rasi 5
    if (rasi == 5) return 3;
    // Keeta: rasi 8 (and default)
    return 4;
  }

  /// Tara / Dina / Nakshatra Koota (max 3 pts North, bool South).
  (double, double) _taraScoreNorth() {
    var res = 0.0;
    // Direction 1: count from person2 to person1
    var count = _countFromPerson2;
    if (count <= 0) count += 27;
    count = count % 9;
    if (count == 3 || count == 5 || count == 7) res += 1.5;

    // Direction 2: count from person1 to person2
    count = _countFromPerson1;
    if (count <= 0) count += 27;
    count = count % 9;
    if (count == 3 || count == 5 || count == 7) res += 1.5;

    return (res, nakshatraMaxScore);
  }

  bool _dinaPoruthamSouth() {
    final count = _countFromPerson1;
    if ([2, 4, 6, 8, 9, 11, 13, 15, 17, 18, 20, 21, 24, 25, 26]
        .contains(count)) {
      return true;
    }
    // Exception dict for specific girl nakshatras + padas
    final exceptionDict = <int, List<int>>{
      12: [2, 3, 4],
      14: [1, 2, 3],
      16: [1, 2, 4],
    };
    for (final entry in exceptionDict.entries) {
      if (person2Nakshatra == entry.key &&
          entry.value.contains(person2Pada)) {
        return true;
      }
    }
    // Same star checks
    if (person2Nakshatra == person1Nakshatra) {
      if ([1, 3, 5, 10, 13, 15, 20, 23].contains(person2Nakshatra) &&
          (person2Rasi < person1Rasi || person2Pada < person1Pada)) {
        return true;
      } else if (person2Rasi != person1Rasi &&
          person1Rasi < person2Rasi) {
        return true;
      }
    }
    // Same rasi, boy star precedes girl star
    if (person2Rasi == person1Rasi &&
        person1Nakshatra < person2Nakshatra) {
      return true;
    }
    // Exception 22 list
    const exception22List = [
      (4, 25), (7, 1), (8, 2), (10, 4), (12, 6), (13, 7), (14, 8),
      (17, 11), (21, 15), (25, 19), (26, 20), (27, 21),
    ];
    for (final pair in exception22List) {
      if (person1Nakshatra == pair.$1 && person2Nakshatra == pair.$2) {
        return true;
      }
    }
    return false;
  }

  /// Gana Koota (max 6 pts North, bool South).
  (double, double) _ganaScoreNorth() {
    final boyGana = _findGana(person1Nakshatra - 1);
    final girlGana = _findGana(person2Nakshatra - 1);
    return (ganaArray[girlGana][boyGana].toDouble(), ganaMaxScore.toDouble());
  }

  bool _ganaPoruthamSouth() {
    final bn = person1Nakshatra;
    final gn = person2Nakshatra;
    if (ganaSouthDeva.contains(bn) && ganaSouthDeva.contains(gn)) return true;
    if ((ganaSouthManushya.contains(bn) && ganaSouthManushya.contains(gn)) ||
        (ganaSouthDeva.contains(bn) && ganaSouthManushya.contains(gn))) {
      return true;
    }
    if (ganaSouthManushya.contains(bn) && ganaSouthDeva.contains(gn)) {
      return true;
    }
    if (ganaSouthRakshasa.contains(bn) &&
        ganaSouthRakshasa.contains(gn) &&
        gn > ganaThresholdSouth) {
      return true;
    }
    return false;
  }

  int _findGana(int nakIndex) {
    // nakIndex is 0-based (0-26)
    if ([0, 4, 6, 7, 12, 14, 16, 21, 26].contains(nakIndex)) return 0; // Deva
    if ([1, 3, 5, 10, 11, 19, 20, 24, 25].contains(nakIndex)) {
      return 1; // Manushya
    }
    return 2; // Rakshasa
  }

  /// Yoni Koota (max 4 pts North, bool South).
  (double, double) _yoniScoreNorth() {
    final gy = yoniMappings[person2Nakshatra - 1];
    final by = yoniMappings[person1Nakshatra - 1];
    return (yoniArray[gy][by].toDouble(), yoniMaxScore.toDouble());
  }

  bool _yoniPoruthamSouth() {
    final ga = yoniMappings[person2Nakshatra - 1];
    final ba = yoniMappings[person1Nakshatra - 1];
    for (final pair in yoniEnemiesSouth) {
      if (ga == pair.$1 && ba == pair.$2) return false;
    }
    return true;
  }

  /// Graha Maitri / Raasi Adhipathi (max 5 pts North, bool South).
  (double, double) _maitriScoreNorth() {
    final gl = raasiAdhipathiMappings[person2Rasi - 1];
    final bl = raasiAdhipathiMappings[person1Rasi - 1];
    return (raasiAdhipathiArray[gl][bl], raasiAdhipathiMaxScore);
  }

  bool _maitriPoruthamSouth() {
    final gl = raasiAdhipathiMappings[person2Rasi - 1];
    final bl = raasiAdhipathiMappings[person1Rasi - 1];
    return raasiAdhipathiArraySouth[gl][bl] == 1;
  }

  /// Bhakut / Raasi (max 7 pts North, bool South).
  (double, double) _bhakutScoreNorth() {
    return (
      raasiArray[person2Rasi - 1][person1Rasi - 1].toDouble(),
      raasiMaxScore.toDouble(),
    );
  }

  bool _bhakutPoruthamSouth() {
    return countRasis(person2Rasi, person1Rasi) > raasiThresholdSouth;
  }

  /// Nadi (max 8 pts North, bool South).
  (double, double) _nadiScoreNorth() {
    final bv = nadiMappings[person1Nakshatra - 1];
    final gv = nadiMappings[person2Nakshatra - 1];
    return (nadiArray[bv][gv].toDouble(), nadiMaxScore.toDouble());
  }

  bool _nadiPoruthamSouth() {
    final bv = nadiMappings[person1Nakshatra - 1];
    final gv = nadiMappings[person2Nakshatra - 1];
    return nadiArray[bv][gv] == 8;
  }

  // ─── 4 Naalu Porutham (always boolean) ──────────────────────────────────

  bool mahendraPorutham() {
    return mahendraPoruthamArray.contains(_countFromPerson2);
  }

  bool vedhaPorutham() {
    final sum = person1Nakshatra + person2Nakshatra;
    return !vedhaPairSum.contains(sum);
  }

  bool rajjuPorutham() {
    if (method == CompatibilityMethod.south) return _rajjuPoruthamSouth();
    return _rajjuPoruthamNorth();
  }

  bool _rajjuPoruthamNorth() {
    final bn = person1Nakshatra;
    final gn = person2Nakshatra;
    final samePart = (headRajju.contains(bn) && headRajju.contains(gn)) ||
        (neckRajju.contains(bn) && neckRajju.contains(gn)) ||
        (stomachRajju.contains(bn) && stomachRajju.contains(gn)) ||
        (waistRajju.contains(bn) && waistRajju.contains(gn)) ||
        (footRajju.contains(bn) && footRajju.contains(gn));
    return !samePart;
  }

  bool _rajjuPoruthamSouth() {
    final bn = person1Nakshatra;
    final gn = person2Nakshatra;
    final allAaroga = [
      ...neckAarogaRajju,
      ...footAarogaRajju,
      ...waistAarogaRajju,
      ...stomachAarogaRajju,
    ];
    final bnAaroga = allAaroga.contains(bn);
    final gnAaroga = allAaroga.contains(gn);
    // If one is aaroga and the other is not, it's a match
    if ((bnAaroga && !gnAaroga) || (gnAaroga && !bnAaroga)) return true;
    // Otherwise, fall back to same-part check
    final samePart = (headRajju.contains(bn) && headRajju.contains(gn)) ||
        (neckRajju.contains(bn) && neckRajju.contains(gn)) ||
        (stomachRajju.contains(bn) && stomachRajju.contains(gn)) ||
        (waistRajju.contains(bn) && waistRajju.contains(gn)) ||
        (footRajju.contains(bn) && footRajju.contains(gn));
    return !samePart;
  }

  bool sthreeDheergaPorutham() {
    if (method == CompatibilityMethod.south) {
      return _countFromPerson2 > sthreeDheergaThresholdSouth;
    }
    return _countFromPerson2 > sthreeDheergaThreshold;
  }

  // ─── Aggregate computation ──────────────────────────────────────────────

  CompatibilityResult computeCompatibility() {
    if (method == CompatibilityMethod.south) {
      return _computeSouth();
    }
    return _computeNorth();
  }

  CompatibilityResult _computeNorth() {
    final varna = _varnaScoreNorth();
    final vasiya = _vasiyaScoreNorth();
    final tara = _taraScoreNorth();
    final gana = _ganaScoreNorth();
    final yoni = _yoniScoreNorth();
    final maitri = _maitriScoreNorth();
    final bhakut = _bhakutScoreNorth();
    final nadi = _nadiScoreNorth();

    final kootas = [
      KootaResult(key: 'varna', name: 'Varna', score: varna.$1, maxScore: varna.$2),
      KootaResult(key: 'vasiya', name: 'Vasiya', score: vasiya.$1, maxScore: vasiya.$2),
      KootaResult(key: 'tara', name: 'Tara', score: tara.$1, maxScore: tara.$2),
      KootaResult(key: 'gana', name: 'Gana', score: gana.$1, maxScore: gana.$2),
      KootaResult(key: 'yoni', name: 'Yoni', score: yoni.$1, maxScore: yoni.$2),
      KootaResult(key: 'maitri', name: 'Graha Maitri', score: maitri.$1, maxScore: maitri.$2),
      KootaResult(key: 'bhakut', name: 'Bhakut', score: bhakut.$1, maxScore: bhakut.$2),
      KootaResult(key: 'nadi', name: 'Nadi', score: nadi.$1, maxScore: nadi.$2),
    ];

    final total = kootas.fold(0.0, (sum, k) => sum + k.score);

    final mahendra = mahendraPorutham();
    final vedha = vedhaPorutham();
    final rajju = rajjuPorutham();
    final sthreeDheerga = sthreeDheergaPorutham();

    final naalu = [
      PoruthamCheck(key: 'mahendra', name: 'Mahendra', passed: mahendra),
      PoruthamCheck(key: 'vedha', name: 'Vedha', passed: vedha),
      PoruthamCheck(key: 'rajju', name: 'Rajju', passed: rajju),
      PoruthamCheck(key: 'stree_dheerga', name: 'Stree Dheerga', passed: sthreeDheerga),
    ];

    return CompatibilityResult(
      method: CompatibilityMethod.north,
      person1Nakshatra: person1Nakshatra,
      person1Pada: person1Pada,
      person2Nakshatra: person2Nakshatra,
      person2Pada: person2Pada,
      person1Rasi: person1Rasi,
      person2Rasi: person2Rasi,
      kootaResults: kootas,
      totalScore: total,
      maxScore: maxCompatibilityScore.toDouble(),
      naaluPoruthamChecks: naalu,
      verdict: _verdictForScore(total),
    );
  }

  CompatibilityResult _computeSouth() {
    // South method: all 8 base factors are boolean
    final varnaBool = _varnaPoruthamSouth();
    final vasiyaBool = _vasiyaPoruthamSouth();
    final ganaBool = _ganaPoruthamSouth();
    final dinaBool = _dinaPoruthamSouth();
    final yoniBool = _yoniPoruthamSouth();
    final maitriBool = _maitriPoruthamSouth();
    final rasiBool = _bhakutPoruthamSouth();
    final nadiBool = _nadiPoruthamSouth();

    final mahendra = mahendraPorutham();
    final vedha = vedhaPorutham();
    final rajju = rajjuPorutham();
    final sthreeDheerga = sthreeDheergaPorutham();

    // South total: sum of 10 booleans (6 core + 4 naalu, excluding varna and nadi)
    final southBools = [
      dinaBool, ganaBool, mahendra, sthreeDheerga, yoniBool,
      rasiBool, maitriBool, vasiyaBool, rajju, vedha,
    ];
    final total = southBools.where((b) => b).length.toDouble();

    // Build south porutham checks (the 10 factors that count)
    final southChecks = [
      PoruthamCheck(key: 'dina', name: 'Dina', passed: dinaBool),
      PoruthamCheck(key: 'gana', name: 'Gana', passed: ganaBool),
      PoruthamCheck(key: 'yoni', name: 'Yoni', passed: yoniBool),
      PoruthamCheck(key: 'rasi', name: 'Rasi', passed: rasiBool),
      PoruthamCheck(key: 'rasiyathipathi', name: 'Rasiyathipathi', passed: maitriBool),
      PoruthamCheck(key: 'vasiya', name: 'Vasiya', passed: vasiyaBool),
      PoruthamCheck(key: 'mahendra', name: 'Mahendra', passed: mahendra),
      PoruthamCheck(key: 'vedha', name: 'Vedha', passed: vedha),
      PoruthamCheck(key: 'rajju', name: 'Rajju', passed: rajju),
      PoruthamCheck(key: 'stree_dheerga', name: 'Stree Dheerga', passed: sthreeDheerga),
    ];

    // Minimum Tamil porutham
    final minPorutham = _minimumTamilPorutham(
      rajju: rajju,
      dina: dinaBool,
      gana: ganaBool,
      rasi: rasiBool,
      yoni: yoniBool,
    );

    // Also build koota results for display purposes
    // (South shows the 8 base factors + their pass/fail status)
    final kootas = [
      KootaResult(key: 'varna', name: 'Varna', score: varnaBool ? 1 : 0, maxScore: 1),
      KootaResult(key: 'vasiya', name: 'Vasiya', score: vasiyaBool ? 1 : 0, maxScore: 1),
      KootaResult(key: 'gana', name: 'Gana', score: ganaBool ? 1 : 0, maxScore: 1),
      KootaResult(key: 'tara', name: 'Dina', score: dinaBool ? 1 : 0, maxScore: 1),
      KootaResult(key: 'yoni', name: 'Yoni', score: yoniBool ? 1 : 0, maxScore: 1),
      KootaResult(key: 'maitri', name: 'Rasiyathipathi', score: maitriBool ? 1 : 0, maxScore: 1),
      KootaResult(key: 'bhakut', name: 'Rasi', score: rasiBool ? 1 : 0, maxScore: 1),
      KootaResult(key: 'nadi', name: 'Nadi', score: nadiBool ? 1 : 0, maxScore: 1),
    ];

    final naalu = [
      PoruthamCheck(key: 'mahendra', name: 'Mahendra', passed: mahendra),
      PoruthamCheck(key: 'vedha', name: 'Vedha', passed: vedha),
      PoruthamCheck(key: 'rajju', name: 'Rajju', passed: rajju),
      PoruthamCheck(key: 'stree_dheerga', name: 'Stree Dheerga', passed: sthreeDheerga),
    ];

    return CompatibilityResult(
      method: CompatibilityMethod.south,
      person1Nakshatra: person1Nakshatra,
      person1Pada: person1Pada,
      person2Nakshatra: person2Nakshatra,
      person2Pada: person2Pada,
      person1Rasi: person1Rasi,
      person2Rasi: person2Rasi,
      kootaResults: kootas,
      totalScore: total,
      maxScore: maxCompatibilityScoreSouth.toDouble(),
      naaluPoruthamChecks: naalu,
      southPoruthamChecks: southChecks,
      minimumPorutham: minPorutham,
      verdict: _verdictForScoreSouth(total, minPorutham),
    );
  }

  bool _minimumTamilPorutham({
    required bool rajju,
    required bool dina,
    required bool gana,
    required bool rasi,
    required bool yoni,
  }) {
    if (skipUsingGirlsVarnaForMinimumTamilPorutham) {
      return rajju && dina && gana && rasi && yoni;
    }
    // Extended version using girl's varna (not currently used)
    final girlVarna = vasiyaRaasiList[person2Rasi - 1];
    var minimum = rajju;
    switch (girlVarna) {
      case 0:
        minimum = minimum && dina;
      case 1:
        minimum = minimum && gana;
      case 2:
        minimum = minimum && rasi;
      default:
        minimum = minimum && yoni;
    }
    return minimum;
  }

  String _verdictForScore(double score) {
    for (final entry in verdictRanges.entries) {
      if (score >= entry.value.$1 && score <= entry.value.$2) {
        return entry.key;
      }
    }
    return 'Difficult Match';
  }

  String _verdictForScoreSouth(double score, bool minPorutham) {
    if (minPorutham && score >= 7) return 'Excellent Match';
    if (minPorutham && score >= 5) return 'Good Match';
    if (score >= 5) return 'Challenging Match';
    return 'Difficult Match';
  }
}
