/// Constants for Panchanga calculations
/// Ported from PyJHora's const.py
///
/// This class provides all necessary constants for Vedic astrology calculations
/// including planet indices, ayanamsa modes, and astronomical constants
library;

class PanchangaConstants {
  // Planet constants mapped to Swiss Ephemeris
  static const int ketu = -10; // Negative of mean node
  static const int rahu = 10; // Mean node
  static const int sun = 0;
  static const int moon = 1;
  static const int mars = 4;
  static const int mercury = 2;
  static const int jupiter = 5;
  static const int venus = 3;
  static const int saturn = 6;
  static const int uranus = 7;
  static const int neptune = 8;
  static const int pluto = 9;

  // Planet list for calculations (Sun to Ketu)
  static const List<int> planetList = [
    sun,
    moon,
    mars,
    mercury,
    jupiter,
    venus,
    saturn,
    rahu,
    ketu
  ];

  // Planet names in English
  static const List<String> planetNames = [
    'Sun',
    'Moon',
    'Mars',
    'Mercury',
    'Jupiter',
    'Venus',
    'Saturn',
    'Rahu',
    'Ketu'
  ];

  // Planet names in Sanskrit/Tamil
  static const List<String> planetNamesSanskrit = [
    'Surya',
    'Chandra',
    'Kuja',
    'Budha',
    'Guru',
    'Sukra',
    'Sani',
    'Rahu',
    'Ketu'
  ];

  // Zodiac sign names
  static const List<String> rasiNames = [
    'Aries',
    'Taurus',
    'Gemini',
    'Cancer',
    'Leo',
    'Virgo',
    'Libra',
    'Scorpio',
    'Sagittarius',
    'Capricorn',
    'Aquarius',
    'Pisces'
  ];

  // Nakshatra names (27 lunar mansions)
  static const List<String> nakshatraNames = [
    'Ashwini',
    'Bharani',
    'Krittika',
    'Rohini',
    'Mrigashira',
    'Ardra',
    'Punarvasu',
    'Pushya',
    'Ashlesha',
    'Magha',
    'Purva Phalguni',
    'Uttara Phalguni',
    'Hasta',
    'Chitra',
    'Swati',
    'Vishakha',
    'Anuradha',
    'Jyeshtha',
    'Mula',
    'Purva Ashadha',
    'Uttara Ashadha',
    'Shravana',
    'Dhanishta',
    'Shatabhisha',
    'Purva Bhadrapada',
    'Uttara Bhadrapada',
    'Revati'
  ];

  // Tithi names (30 lunar days)
  static const List<String> tithiNames = [
    'Pratipada',
    'Dwitiya',
    'Tritiya',
    'Chaturthi',
    'Panchami',
    'Shashthi',
    'Saptami',
    'Ashtami',
    'Navami',
    'Dashami',
    'Ekadashi',
    'Dwadashi',
    'Trayodashi',
    'Chaturdashi',
    'Purnima',
    'Pratipada',
    'Dwitiya',
    'Tritiya',
    'Chaturthi',
    'Panchami',
    'Shashthi',
    'Saptami',
    'Ashtami',
    'Navami',
    'Dashami',
    'Ekadashi',
    'Dwadashi',
    'Trayodashi',
    'Chaturdashi',
    'Amavasya'
  ];

  // Yoga names (27 yogas)
  static const List<String> yogaNames = [
    'Vishkambha',
    'Priti',
    'Ayushman',
    'Saubhagya',
    'Shobhana',
    'Atiganda',
    'Sukarma',
    'Dhriti',
    'Shoola',
    'Ganda',
    'Vriddhi',
    'Dhruva',
    'Vyaghata',
    'Harshana',
    'Vajra',
    'Siddhi',
    'Vyatipata',
    'Variyan',
    'Parigha',
    'Shiva',
    'Siddha',
    'Sadhya',
    'Shubha',
    'Shukla',
    'Brahma',
    'Indra',
    'Vaidhriti'
  ];

  // Karana names (11 karanas)
  static const List<String> karanaNames = [
    'Bava',
    'Balava',
    'Kaulava',
    'Taitila',
    'Garaja',
    'Vanija',
    'Vishti',
    'Shakuni',
    'Chatushpada',
    'Naga',
    'Kimstughna'
  ];

  // Weekday names
  static const List<String> weekdayNames = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  // Ayanamsa modes (Swiss Ephemeris sidereal mode constants)
  static const Map<String, int> ayanamsaModes = {
    'FAGAN': 0, // SE_SIDM_FAGAN_BRADLEY
    'LAHIRI': 1, // SE_SIDM_LAHIRI
    'KP': 5, // SE_SIDM_KRISHNAMURTI
    'RAMAN': 3, // SE_SIDM_RAMAN
    'USHASHASHI': 4, // SE_SIDM_USHASHASHI
    'YUKTESHWAR': 7, // SE_SIDM_YUKTESHWAR
    'SURYASIDDHANTA': 21, // SE_SIDM_SURYASIDDHANTA
    'SURYASIDDHANTA_MSUN': 22, // SE_SIDM_SURYASIDDHANTA_MSUN
    'ARYABHATA': 23, // SE_SIDM_ARYABHATA
    'ARYABHATA_MSUN': 24, // SE_SIDM_ARYABHATA_MSUN
    'SS_CITRA': 27, // SE_SIDM_SS_CITRA
    'TRUE_CITRA': 28, // SE_SIDM_TRUE_CITRA
    'TRUE_REVATI': 29, // SE_SIDM_TRUE_REVATI
    'SS_REVATI': 25, // SE_SIDM_SS_REVATI
    'TRUE_PUSHYA': 31, // SE_SIDM_TRUE_PUSHYA
  };

  static const String defaultAyanamsaMode = 'LAHIRI';

  // Astronomical constants
  static const double siderealYear = 365.256364; // From JHora
  static const double lunarYear = 354.36707;
  static const double savanaYear = 360.0;
  static const double tropicalYear = 365.242190;
  static const double averageGregorianYear = 365.2425;

  // Dasha periods for Vimsottari Dasha
  static const Map<int, int> vimsottariDhasa = {
    8: 7, // Ketu
    5: 20, // Venus
    0: 6, // Sun
    1: 10, // Moon
    2: 7, // Mars
    7: 18, // Rahu
    4: 16, // Jupiter
    6: 19, // Saturn
    3: 17, // Mercury
  };

  // Nakshatra lords (adhipati)
  static const List<int> adhipatiList = [8, 5, 0, 1, 2, 7, 4, 6, 3];

  // Human lifespan for dhasa calculations
  static const double humanLifeSpanForDhasa = 120.0;

  // Rise flags for Swiss Ephemeris calculations
  static const int riseFlags = 2 | 64; // SEFLG_SWIEPH | SEFLG_SIDEREAL

  // Division chart factors
  static const List<int> divisionChartFactors = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    16,
    20,
    24,
    27,
    30,
    40,
    45,
    60,
    81,
    108,
    144
  ];

  // Constants for tithi calculation
  static const double degreesPerTithi = 12.0; // 360/30
  static const int tithisPerMonth = 30;

  // Constants for nakshatra calculation
  static const double degreesPerNakshatra = 13.333333333333334; // 360/27
  static const double degreesPerPada = 3.333333333333333; // 360/108
  static const int nakshatrasCount = 27;
  static const int padasPerNakshatra = 4;

  // Constants for yoga calculation
  static const double degreesPerYoga = 13.333333333333334; // 360/27
  static const int yogasCount = 27;

  // Constants for karana calculation
  static const double degreesPerKarana = 6.0; // 360/60
  static const int karanasCount = 11;

  // Constants for rasi calculation
  static const double degreesPerRasi = 30.0; // 360/12
  static const int rasisCount = 12;

  // Tropical mode flag
  static bool tropicalMode = false;

  // Use planet speed for panchangam end timings
  static bool usePlanetSpeedForPanchangamEndTimings = true;
}
