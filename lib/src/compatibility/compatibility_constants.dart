// Copyright (C) 2024. Clean-room reimplementation of public-domain
// Vedic astrological formulas. Reference: PyJHora (AGPL-3.0).

/// All lookup tables, thresholds, and explanatory text for the
/// Ashtakoota / Dasha Porutham compatibility system.
library;

// ─── Nakshatra & Rasi lists ─────────────────────────────────────────────────

const List<String> nakshatraList = [
  'Ashwini', 'Bharani', 'Krittika', 'Rohini', 'Mrigashira', 'Ardra',
  'Punarvasu', 'Pushya', 'Ashlesha', 'Magha', 'Purva Phalguni',
  'Uttara Phalguni', 'Hasta', 'Chitra', 'Swati', 'Vishakha', 'Anuradha',
  'Jyeshtha', 'Mula', 'Purva Ashadha', 'Uttara Ashadha', 'Shravana',
  'Dhanishta', 'Satabhisha', 'Purva Bhadrapada', 'Uttara Bhadrapada',
  'Revati',
];

const List<String> raasiList = [
  'Mesha', 'Vrishabha', 'Mithuna', 'Karka', 'Simha', 'Kanya',
  'Tula', 'Vrishchika', 'Dhanu', 'Makara', 'Kumbha', 'Meena',
];

// ─── Varna (1 pt max) ───────────────────────────────────────────────────────

/// 4×4 scoring grid. Row = person2 varna category, Col = person1 varna.
const List<List<int>> varnaArray = [
  [1, 0, 0, 0],
  [1, 1, 0, 0],
  [1, 1, 1, 0],
  [1, 1, 1, 1],
];

const List<String> varnaCategories = [
  'Brahmin', 'Kshatriya', 'Vaishya', 'Shudra',
];

const int varnaMaxScore = 1;

// ─── Vasiya (2 pts max) ─────────────────────────────────────────────────────

/// Maps rasi number (1-12) to vasiya category index (0-3).
/// 0=Chatushpada, 1=Manava, 2=Jalachara, 3=Vanachara.
/// Also used for varna category mapping.
const List<int> vasiyaRaasiList = [1, 3, 2, 0, 1, 3, 2, 0, 1, 3, 2, 0];

/// 5×5 scoring grid. Row = person2 category, Col = person1 category.
const List<List<double>> vasiyaArray = [
  [2.0, 0.5, 1.0, 0.0, 2.0],
  [0.5, 2.0, 0.0, 0.0, 0.0],
  [1.0, 0.0, 2.0, 2.0, 2.0],
  [0.0, 0.0, 2.0, 2.0, 0.0],
  [1.0, 0.0, 1.0, 0.0, 2.0],
];

const List<String> vasiyaCategories = [
  'Chatushpada', 'Manava', 'Jalachara', 'Vanachara', 'Keeta',
];

const double vasiyaMaxScore = 2.0;

/// South Indian vasiya list: vasiyaListSouth[girlRasi-1] contains
/// the boy rasi indices (0-based) that are compatible.
const List<List<int>> vasiyaListSouth = [
  [4, 7], [3, 6], [5], [7, 8], [6], [2, 11],
  [5, 9], [3], [11], [0, 10], [0], [9],
];

// ─── Tara / Dina / Nakshatra (3 pts max) ────────────────────────────────────

/// 9×9 grid used for tara/dina scoring lookup.
const List<List<double>> nakshatraConst = [
  [3.0, 3.0, 1.5, 3.0, 1.5, 3.0, 1.5, 3.0, 3.0],
  [3.0, 3.0, 1.5, 3.0, 1.5, 3.0, 1.5, 3.0, 3.0],
  [1.5, 1.5, 0.0, 1.5, 0.0, 1.5, 0.0, 1.5, 1.5],
  [3.0, 3.0, 1.5, 3.0, 1.5, 3.0, 1.5, 3.0, 3.0],
  [1.5, 1.5, 0.0, 1.5, 0.0, 1.5, 0.0, 1.5, 1.5],
  [3.0, 3.0, 1.5, 3.0, 1.5, 3.0, 1.5, 3.0, 3.0],
  [1.5, 1.5, 0.0, 1.5, 0.0, 1.5, 0.0, 1.0, 1.0],
  [3.0, 3.0, 1.5, 3.0, 1.5, 3.0, 1.5, 3.0, 3.0],
  [3.0, 3.0, 1.5, 3.0, 1.5, 3.0, 1.5, 3.0, 3.0],
];

const List<String> nakshatraCategories = [
  'Janma', 'Sampat', 'Vipat', 'Kshem', 'Pratyari',
  'Sadhak', 'Vaadh', 'Mitra', 'Athi-Mithra',
];

const double nakshatraMaxScore = 3.0;

// ─── Yoni (4 pts max) ───────────────────────────────────────────────────────

/// Maps nakshatra index (0-based, 0-26) to yoni animal category (0-13).
const List<int> yoniMappings = [
  0, 1, 2, 3, 3, 4, 5, 2, 5, 6, 6, 7, 8, 9, 8, 9, 10, 10, 4, 11, 12, 11,
  13, 0, 13, 7, 1,
];

const List<String> yoniCategories = [
  'Horse', 'Elephant', 'Sheep', 'Serpent', 'Dog', 'Cat', 'Rat', 'Cow',
  'Buffalo', 'Tiger', 'Deer', 'Monkey', 'Mongoose', 'Lion',
];

/// 14×14 scoring grid. Row = person2 yoni, Col = person1 yoni.
const List<List<int>> yoniArray = [
  [4, 2, 2, 3, 2, 2, 2, 1, 0, 1, 1, 3, 2, 1],
  [2, 4, 3, 3, 2, 2, 2, 2, 3, 1, 2, 3, 2, 0],
  [2, 3, 4, 2, 1, 2, 1, 3, 3, 1, 2, 0, 3, 1],
  [3, 3, 2, 4, 2, 1, 1, 1, 1, 2, 2, 2, 0, 2],
  [2, 2, 1, 2, 4, 2, 1, 2, 2, 1, 0, 2, 1, 1],
  [2, 2, 2, 1, 2, 4, 0, 2, 2, 1, 3, 3, 2, 1],
  [2, 2, 1, 1, 1, 0, 4, 2, 2, 2, 2, 2, 1, 2],
  [1, 2, 3, 1, 2, 2, 2, 4, 3, 0, 3, 2, 2, 1],
  [0, 3, 3, 1, 2, 2, 2, 3, 4, 1, 2, 2, 2, 1],
  [1, 1, 1, 2, 1, 1, 2, 0, 1, 4, 1, 1, 2, 1],
  [1, 2, 2, 2, 0, 3, 2, 3, 2, 1, 4, 2, 2, 1],
  [3, 3, 0, 2, 2, 3, 2, 2, 2, 1, 2, 4, 3, 2],
  [2, 2, 3, 0, 1, 2, 1, 2, 2, 2, 2, 3, 4, 2],
  [1, 0, 1, 2, 1, 1, 2, 1, 1, 1, 1, 2, 2, 4],
];

const int yoniMaxScore = 4;

/// South Indian yoni enemy pairs (animal1, animal2) — both directions.
const List<(int, int)> yoniEnemiesSouth = [
  (0, 8), (1, 13), (2, 11), (3, 12), (3, 6), (4, 10), (5, 6), (6, 3),
  (6, 5), (7, 9), (8, 0), (9, 7), (10, 4), (11, 2), (12, 3), (13, 1),
];

// ─── Gana (6 pts max) ───────────────────────────────────────────────────────

/// 3×3 scoring grid. Row = person2 gana, Col = person1 gana.
/// 0=Deva, 1=Manushya, 2=Rakshasa.
const List<List<int>> ganaArray = [
  [6, 6, 0],
  [5, 6, 0],
  [1, 0, 6],
];

const int ganaMaxScore = 6;

/// South Indian gana classification — nakshatras in each gana (1-based).
const List<int> ganaSouthDeva = [1, 5, 7, 8, 13, 15, 17, 22, 27];
const List<int> ganaSouthManushya = [2, 4, 6, 8, 11, 12, 20, 21, 25, 26];
const List<int> ganaSouthRakshasa = [3, 9, 10, 14, 16, 18, 19, 23, 24];

/// Gana threshold for South method. Rakshasa+Rakshasa match only if
/// girl's nakshatra > this threshold.
const int ganaThresholdSouth = 14;

// ─── Graha Maitri / Raasi Adhipathi (5 pts max) ─────────────────────────────

/// Maps rasi (1-12) to planet lord index (0-6).
/// 0=Sun, 1=Moon, 2=Mars, 3=Mercury, 4=Jupiter, 5=Venus, 6=Saturn.
const List<int> raasiAdhipathiMappings = [2, 5, 3, 1, 0, 3, 5, 2, 4, 6, 6, 4];

/// 7×7 North Indian scoring grid. Row = person2 lord, Col = person1 lord.
const List<List<double>> raasiAdhipathiArray = [
  [5.0, 5.0, 5.0, 4.0, 5.0, 0.0, 0.0],
  [5.0, 5.0, 4.0, 1.0, 4.0, 0.5, 0.5],
  [5.0, 4.0, 5.0, 0.5, 5.0, 3.0, 0.5],
  [4.0, 1.0, 0.5, 5.0, 0.5, 5.0, 4.0],
  [5.0, 4.0, 5.0, 0.5, 5.0, 0.5, 3.0],
  [0.0, 0.5, 3.0, 5.0, 0.5, 5.0, 5.0],
  [0.0, 0.5, 0.5, 4.0, 3.0, 5.0, 5.0],
];

/// 7×7 South Indian friendship grid (1 = friends, 0 = not).
const List<List<int>> raasiAdhipathiArraySouth = [
  [0, 0, 0, 0, 1, 0, 0],
  [0, 0, 0, 1, 1, 0, 0],
  [0, 0, 0, 1, 0, 1, 0],
  [0, 1, 1, 0, 1, 1, 1],
  [1, 1, 0, 1, 0, 1, 1],
  [0, 0, 1, 1, 1, 0, 1],
  [0, 0, 0, 1, 1, 1, 0],
];

const double raasiAdhipathiMaxScore = 5.0;

// ─── Bhakut / Raasi (7 pts max) ─────────────────────────────────────────────

/// 12×12 scoring grid. Row = person2 rasi (0-based), Col = person1 rasi.
const List<List<int>> raasiArray = [
  [7, 0, 7, 7, 0, 0, 7, 0, 0, 7, 7, 0],
  [0, 7, 0, 7, 7, 0, 0, 7, 0, 0, 7, 7],
  [7, 0, 7, 0, 7, 7, 0, 0, 7, 0, 0, 7],
  [7, 7, 0, 7, 0, 7, 7, 0, 0, 7, 0, 0],
  [0, 7, 7, 0, 7, 0, 7, 7, 0, 0, 7, 0],
  [0, 0, 7, 7, 0, 7, 0, 7, 7, 0, 0, 7],
  [7, 0, 0, 7, 7, 0, 7, 0, 7, 7, 0, 0],
  [0, 7, 0, 0, 7, 7, 0, 7, 0, 7, 7, 0],
  [0, 0, 7, 0, 0, 7, 7, 0, 7, 0, 7, 7],
  [7, 0, 0, 7, 0, 0, 7, 7, 0, 7, 0, 7],
  [7, 7, 0, 7, 7, 0, 0, 7, 7, 0, 7, 0],
  [0, 7, 7, 0, 0, 7, 0, 0, 7, 7, 0, 7],
];

const int raasiMaxScore = 7;

/// Rasi count threshold for South method.
const int raasiThresholdSouth = 6;

// ─── Nadi (8 pts max) ───────────────────────────────────────────────────────

/// 3×3 scoring grid. 0=Vata, 1=Pitta, 2=Kapha.
const List<List<int>> nadiArray = [
  [0, 8, 8],
  [8, 0, 8],
  [8, 8, 0],
];

const int nadiMaxScore = 8;

/// Maps nakshatra index (0-based, 0-26) to nadi category (0-2).
const List<int> nadiMappings = [
  0, 1, 2, 2, 1, 0, 0, 1, 2, 2, 1, 0, 0, 1, 2, 2, 1, 0, 0, 1, 2, 2, 1, 0,
  0, 1, 2,
];

// ─── Mahendra Porutham ──────────────────────────────────────────────────────

const List<int> mahendraPoruthamArray = [4, 7, 10, 13, 16, 19, 22, 25];

// ─── Vedha Porutham ─────────────────────────────────────────────────────────

const List<int> vedhaPairSum = [19, 28, 37];

// ─── Rajju Porutham ─────────────────────────────────────────────────────────

const List<int> headRajju = [5, 14, 23];
const List<int> neckRajju = [4, 6, 13, 15, 22, 24];
const List<int> stomachRajju = [3, 7, 12, 16, 21, 25];
const List<int> waistRajju = [2, 8, 11, 17, 20, 26];
const List<int> footRajju = [1, 9, 10, 18, 19, 27];

// Tamil / South Indian aaroga/avaroga rajju
// NOTE: PyJhora has a bug: neck_aaroga_rajju = [413,22]. Should be [4,13,22].
const List<int> neckAarogaRajju = [4, 13, 22];
const List<int> neckAvarogaRajju = [6, 15, 24];
const List<int> stomachAarogaRajju = [3, 12, 21];
const List<int> stomachAvarogaRajju = [7, 16, 25];
const List<int> waistAarogaRajju = [2, 11, 20];
const List<int> waistAvarogaRajju = [8, 17, 26];
const List<int> footAarogaRajju = [1, 10, 19];
const List<int> footAvarogaRajju = [9, 18, 27];

// ─── Stree Dheerga Porutham ─────────────────────────────────────────────────

const int sthreeDheergaThreshold = 13;
const int sthreeDheergaThresholdSouth = 7;

// ─── Overall thresholds ─────────────────────────────────────────────────────

const int maxCompatibilityScore = 36;
const int maxCompatibilityScoreSouth = 10;

// ─── Minimum Tamil Porutham ─────────────────────────────────────────────────

/// When true, minimum porutham = rajju && dina && gana && rasi && yoni.
const bool skipUsingGirlsVarnaForMinimumTamilPorutham = true;

// ─── Score verdicts ─────────────────────────────────────────────────────────

const Map<String, (double, double)> verdictRanges = {
  'Excellent Match': (28.0, 36.0),
  'Very Good Match': (24.0, 27.5),
  'Good Match': (18.0, 23.5),
  'Challenging Match': (10.0, 17.5),
  'Difficult Match': (0.0, 9.5),
};

const Map<String, String> verdictExplanations = {
  'Excellent Match':
      'Very strong natural compatibility across all dimensions',
  'Very Good Match':
      'Strong compatibility with minor areas to be mindful of',
  'Good Match':
      'Solid foundation with some areas that may need understanding',
  'Challenging Match':
      'Significant differences that would require considerable effort',
  'Difficult Match':
      'Fundamental differences in most compatibility dimensions',
};

// ─── Koota explanations ─────────────────────────────────────────────────────

const Map<String, KootaInfo> kootaExplanations = {
  'varna': KootaInfo(
    shortLabel: 'Temperament',
    explanation:
        'Compares personality temperaments — whether your natural '
        'dispositions complement each other',
  ),
  'vasiya': KootaInfo(
    shortLabel: 'Attraction',
    explanation:
        'Measures natural magnetic attraction and willingness to be '
        'influenced by each other',
  ),
  'tara': KootaInfo(
    shortLabel: 'Birth Star',
    explanation:
        'Checks health and well-being compatibility based on the '
        'distance between your birth stars',
  ),
  'yoni': KootaInfo(
    shortLabel: 'Intimacy',
    explanation:
        'Assesses physical and intimate compatibility based on '
        'animal symbols of your stars',
  ),
  'maitri': KootaInfo(
    shortLabel: 'Mental',
    explanation:
        'Evaluates mental wavelength and intellectual compatibility '
        'through ruling planet friendship',
  ),
  'gana': KootaInfo(
    shortLabel: 'Temperament',
    explanation:
        'Compares core temperaments: gentle (Deva), balanced '
        '(Manushya), or intense (Rakshasa)',
  ),
  'bhakut': KootaInfo(
    shortLabel: 'Health & Wealth',
    explanation:
        'Predicts impact on mutual health, wealth, and family '
        'happiness based on moon signs',
  ),
  'nadi': KootaInfo(
    shortLabel: 'Health & Genes',
    explanation:
        'Checks genetic and health compatibility — important for '
        'the well-being of future children',
  ),
};

/// South Indian porutham explanations with pass/fail texts.
const Map<String, PoruthamInfo> poruthamExplanations = {
  'dina': PoruthamInfo(
    shortLabel: 'Birth Star',
    explanation: 'Checks health and daily well-being compatibility',
    passText: 'Health and daily well-being between you are well-aligned',
    failText: 'Daily well-being compatibility may need attention',
  ),
  'gana': PoruthamInfo(
    shortLabel: 'Temperament',
    explanation: 'Compares core temperament types',
    passText: 'Your core temperaments are naturally harmonious',
    failText: 'Your temperament styles differ — mutual understanding helps',
  ),
  'yoni': PoruthamInfo(
    shortLabel: 'Intimacy',
    explanation: 'Assesses physical and intimate compatibility',
    passText: 'Physical and intimate compatibility is naturally strong',
    failText: 'Physical compatibility may need extra attention and care',
  ),
  'rasi': PoruthamInfo(
    shortLabel: 'Moon Sign',
    explanation: 'Compares moon sign alignment for emotional compatibility',
    passText: 'Your emotional wavelengths support mutual well-being',
    failText: 'Emotional rhythms differ — patience strengthens the bond',
  ),
  'rasiyathipathi': PoruthamInfo(
    shortLabel: 'Mental',
    explanation:
        'Checks ruling planet friendship for intellectual compatibility',
    passText: 'Intellectual and decision-making styles are compatible',
    failText:
        "Thinking styles differ — appreciate each other's perspective",
  ),
  'vasiya': PoruthamInfo(
    shortLabel: 'Attraction',
    explanation: 'Measures natural mutual attraction',
    passText: 'Natural mutual attraction and influence are present',
    failText: 'Attraction may develop more gradually over time',
  ),
  'mahendra': PoruthamInfo(
    shortLabel: 'Prosperity',
    explanation: 'Indicates potential for family prosperity',
    passText: 'Supports long-term family well-being and growth',
    failText: 'Family prosperity may require more conscious effort',
  ),
  'vedha': PoruthamInfo(
    shortLabel: 'Affliction',
    explanation: 'Checks for star-based friction patterns',
    passText: 'No star-based friction detected between you',
    failText: 'A friction pattern exists — awareness helps manage it',
  ),
  'rajju': PoruthamInfo(
    shortLabel: 'Durability',
    explanation: 'Assesses marital bond strength',
    passText: 'The bond is well-protected against hardship',
    failText: 'The bond may face extra tests during hardship',
  ),
  'stree_dheerga': PoruthamInfo(
    shortLabel: 'Comfort',
    explanation: 'Measures comfort and prosperity in the relationship',
    passText: 'Supports comfort and ease in the relationship',
    failText: 'Comfort may need more intentional nurturing',
  ),
};

// ─── Helper data classes for explanatory text ────────────────────────────────

class KootaInfo {
  final String shortLabel;
  final String explanation;

  const KootaInfo({required this.shortLabel, required this.explanation});
}

class PoruthamInfo {
  final String shortLabel;
  final String explanation;
  final String passText;
  final String failText;

  const PoruthamInfo({
    required this.shortLabel,
    required this.explanation,
    required this.passText,
    required this.failText,
  });
}
