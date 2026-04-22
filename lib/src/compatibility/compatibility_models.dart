// Data classes for Ashtakoota / Dasha Porutham compatibility results.

/// North or South Indian compatibility method.
enum CompatibilityMethod { north, south }

/// Result of a single koota (North Indian scored factor).
class KootaResult {
  /// Key identifier, e.g. 'varna', 'vasiya', 'tara', etc.
  final String key;

  /// Human-readable name, e.g. 'Varna', 'Vasiya'.
  final String name;

  /// Score achieved for this koota.
  final double score;

  /// Maximum possible score for this koota.
  final double maxScore;

  const KootaResult({
    required this.key,
    required this.name,
    required this.score,
    required this.maxScore,
  });

  double get percentage => maxScore > 0 ? score / maxScore : 0;

  @override
  String toString() => '$name: $score/$maxScore';
}

/// Result of a single porutham check (South Indian boolean factor).
class PoruthamCheck {
  /// Key identifier, e.g. 'dina', 'gana', 'rajju', etc.
  final String key;

  /// Human-readable name.
  final String name;

  /// Whether this porutham is satisfied.
  final bool passed;

  const PoruthamCheck({
    required this.key,
    required this.name,
    required this.passed,
  });

  @override
  String toString() => '$name: ${passed ? "Pass" : "Fail"}';
}

/// Complete compatibility result for a pair.
class CompatibilityResult {
  /// Which method was used.
  final CompatibilityMethod method;

  /// Person 1's nakshatra number (1-27) and pada (1-4).
  final int person1Nakshatra;
  final int person1Pada;

  /// Person 2's nakshatra number (1-27) and pada (1-4).
  final int person2Nakshatra;
  final int person2Pada;

  /// Derived rasi for each person (1-12).
  final int person1Rasi;
  final int person2Rasi;

  /// The 8 koota scores (always present, North uses numeric, South uses boolean).
  /// For North: scored results. For South: also present but as boolean via
  /// [southPoruthamChecks].
  final List<KootaResult> kootaResults;

  /// Total numeric score (North: sum of 8 kootas, South: count of 10 booleans).
  final double totalScore;

  /// Maximum possible score (36 for North, 10 for South).
  final double maxScore;

  /// The 4 naalu porutham checks (always present).
  final List<PoruthamCheck> naaluPoruthamChecks;

  /// South Indian: 10 boolean porutham checks (6 core + 4 naalu).
  /// Only populated when method == south.
  final List<PoruthamCheck>? southPoruthamChecks;

  /// South Indian: whether minimum Tamil porutham is met.
  /// Only meaningful when method == south.
  final bool? minimumPorutham;

  /// Human-readable verdict, e.g. "Very Good Match".
  final String verdict;

  const CompatibilityResult({
    required this.method,
    required this.person1Nakshatra,
    required this.person1Pada,
    required this.person2Nakshatra,
    required this.person2Pada,
    required this.person1Rasi,
    required this.person2Rasi,
    required this.kootaResults,
    required this.totalScore,
    required this.maxScore,
    required this.naaluPoruthamChecks,
    this.southPoruthamChecks,
    this.minimumPorutham,
    required this.verdict,
  });

  double get percentage => maxScore > 0 ? totalScore / maxScore * 100 : 0;

  @override
  String toString() =>
      'CompatibilityResult($verdict, $totalScore/$maxScore, '
      '${method == CompatibilityMethod.north ? "North" : "South"})';
}
