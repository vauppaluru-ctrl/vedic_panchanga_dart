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

  // Nakshatra lords (adhipati) - planet indices
  static const List<int> adhipatiList = [8, 5, 0, 1, 2, 7, 4, 6, 3];

  /// Comprehensive nakshatra details including deity, symbol, animal, physical items, etc.
  /// Data sourced from traditional Vedic astrology texts
  static const List<Map<String, dynamic>> nakshatraDetails = [
    {
      'name': 'Ashwini',
      'lord': 'Ketu',
      'deity': 'Ashwini Kumaras',
      'symbol': 'Horse\'s head',
      'animal': 'Horse (Male)',
      'gender': 'Male',
      'gana': 'Deva (Divine)',
      'element': 'Earth',
      'quality': 'Light, Swift',
      'physicalItems': ['Horses', 'Transportation', 'Healing herbs'],
      'characteristics': 'Fast, pioneering, healing abilities',
    },
    {
      'name': 'Bharani',
      'lord': 'Venus',
      'deity': 'Yama (God of Death)',
      'symbol': 'Yoni (Female organ)',
      'animal': 'Elephant (Male)',
      'gender': 'Female',
      'gana': 'Manushya (Human)',
      'element': 'Earth',
      'quality': 'Fierce, Creative',
      'physicalItems': ['Womb', 'Nourishment', 'Creativity'],
      'characteristics': 'Restraint, bearing burdens, transformation',
    },
    {
      'name': 'Krittika',
      'lord': 'Sun',
      'deity': 'Agni (Fire God)',
      'symbol': 'Razor/Axe',
      'animal': 'Sheep (Female)',
      'gender': 'Female',
      'gana': 'Rakshasa (Demon)',
      'element': 'Fire',
      'quality': 'Sharp, Cutting',
      'physicalItems': ['Fire', 'Sharp objects', 'Light'],
      'characteristics': 'Cutting through illusion, purification',
    },
    {
      'name': 'Rohini',
      'lord': 'Moon',
      'deity': 'Brahma/Prajapati',
      'symbol': 'Chariot/Cart',
      'animal': 'Serpent (Male)',
      'gender': 'Female',
      'gana': 'Manushya (Human)',
      'element': 'Earth',
      'quality': 'Fixed, Stable',
      'physicalItems': ['Oxen', 'Vehicles', 'Agriculture'],
      'characteristics': 'Growth, fertility, beauty, materiality',
    },
    {
      'name': 'Mrigashira',
      'lord': 'Mars',
      'deity': 'Soma (Moon God)',
      'symbol': 'Deer\'s head',
      'animal': 'Serpent (Female)',
      'gender': 'Neutral',
      'gana': 'Deva (Divine)',
      'element': 'Earth',
      'quality': 'Soft, Searching',
      'physicalItems': ['Forest', 'Fragrance', 'Flowers'],
      'characteristics': 'Seeking, curiosity, gentle pursuit',
    },
    {
      'name': 'Ardra',
      'lord': 'Rahu',
      'deity': 'Rudra (Storm God)',
      'symbol': 'Teardrop/Diamond',
      'animal': 'Dog (Female)',
      'gender': 'Female',
      'gana': 'Manushya (Human)',
      'element': 'Water',
      'quality': 'Sharp, Moist',
      'physicalItems': ['Storms', 'Tears', 'Precious stones'],
      'characteristics': 'Transformation through destruction, emotions',
    },
    {
      'name': 'Punarvasu',
      'lord': 'Jupiter',
      'deity': 'Aditi (Mother of Gods)',
      'symbol': 'Bow and Quiver',
      'animal': 'Cat (Female)',
      'gender': 'Male',
      'gana': 'Deva (Divine)',
      'element': 'Water',
      'quality': 'Movable, Renewal',
      'physicalItems': ['Home', 'Shelter', 'Bow and arrows'],
      'characteristics': 'Return to goodness, renewal, safety',
    },
    {
      'name': 'Pushya',
      'lord': 'Saturn',
      'deity': 'Brihaspati (Priest of Gods)',
      'symbol': 'Cow\'s udder/Lotus',
      'animal': 'Sheep (Male)',
      'gender': 'Male',
      'gana': 'Deva (Divine)',
      'element': 'Water',
      'quality': 'Light, Nourishing',
      'physicalItems': ['Milk', 'Flowers', 'Sacred ceremonies'],
      'characteristics': 'Nourishment, spiritual growth, auspicious',
    },
    {
      'name': 'Ashlesha',
      'lord': 'Mercury',
      'deity': 'Nagas (Serpent Gods)',
      'symbol': 'Coiled serpent',
      'animal': 'Cat (Male)',
      'gender': 'Female',
      'gana': 'Rakshasa (Demon)',
      'element': 'Water',
      'quality': 'Sharp, Clinging',
      'physicalItems': ['Snakes', 'Poison', 'Hidden things'],
      'characteristics': 'Embracing, mystical wisdom, kundalini',
    },
    {
      'name': 'Magha',
      'lord': 'Ketu',
      'deity': 'Pitris (Ancestors)',
      'symbol': 'Royal throne/Palanquin',
      'animal': 'Rat (Male)',
      'gender': 'Female',
      'gana': 'Rakshasa (Demon)',
      'element': 'Water',
      'quality': 'Fierce, Royal',
      'physicalItems': ['Throne', 'Legacy', 'Ancestral property'],
      'characteristics': 'Authority, legacy, ancestral connections',
    },
    {
      'name': 'Purva Phalguni',
      'lord': 'Venus',
      'deity': 'Bhaga (God of Fortune)',
      'symbol': 'Front legs of bed/Hammock',
      'animal': 'Rat (Female)',
      'gender': 'Female',
      'gana': 'Manushya (Human)',
      'element': 'Water',
      'quality': 'Fierce, Pleasure',
      'physicalItems': ['Bed', 'Music', 'Marital bliss'],
      'characteristics': 'Enjoyment, creativity, procreation',
    },
    {
      'name': 'Uttara Phalguni',
      'lord': 'Sun',
      'deity': 'Aryaman (God of Contracts)',
      'symbol': 'Back legs of bed/Fig tree',
      'animal': 'Bull (Male)',
      'gender': 'Female',
      'gana': 'Manushya (Human)',
      'element': 'Fire',
      'quality': 'Fixed, Patronage',
      'physicalItems': ['Contracts', 'Friendships', 'Alliances'],
      'characteristics': 'Patronage, friendship, kindness',
    },
    {
      'name': 'Hasta',
      'lord': 'Moon',
      'deity': 'Savitar (Sun God of Skills)',
      'symbol': 'Hand/Fist',
      'animal': 'Buffalo (Female)',
      'gender': 'Male',
      'gana': 'Deva (Divine)',
      'element': 'Air',
      'quality': 'Light, Skillful',
      'physicalItems': ['Hands', 'Crafts', 'Tools'],
      'characteristics': 'Dexterity, skill, manifestation',
    },
    {
      'name': 'Chitra',
      'lord': 'Mars',
      'deity': 'Tvashtar (Divine Architect)',
      'symbol': 'Bright jewel/Pearl',
      'animal': 'Tiger (Female)',
      'gender': 'Female',
      'gana': 'Rakshasa (Demon)',
      'element': 'Fire',
      'quality': 'Soft, Colorful',
      'physicalItems': ['Jewels', 'Buildings', 'Art'],
      'characteristics': 'Beauty, charisma, artistic creation',
    },
    {
      'name': 'Swati',
      'lord': 'Rahu',
      'deity': 'Vayu (Wind God)',
      'symbol': 'Young sprout/Coral',
      'animal': 'Buffalo (Male)',
      'gender': 'Female',
      'gana': 'Deva (Divine)',
      'element': 'Fire',
      'quality': 'Movable, Independent',
      'physicalItems': ['Wind', 'Trade goods', 'Sapphire'],
      'characteristics': 'Independence, flexibility, trade',
    },
    {
      'name': 'Vishakha',
      'lord': 'Jupiter',
      'deity': 'Indra-Agni (Gods of Lightning)',
      'symbol': 'Triumphal arch/Potter\'s wheel',
      'animal': 'Tiger (Male)',
      'gender': 'Female',
      'gana': 'Rakshasa (Demon)',
      'element': 'Fire',
      'quality': 'Sharp, Goal-oriented',
      'physicalItems': ['Archway', 'Goals', 'Victory'],
      'characteristics': 'Single-pointed determination, achievement',
    },
    {
      'name': 'Anuradha',
      'lord': 'Saturn',
      'deity': 'Mitra (God of Friendship)',
      'symbol': 'Lotus/Archway',
      'animal': 'Deer (Female)',
      'gender': 'Male',
      'gana': 'Deva (Divine)',
      'element': 'Fire',
      'quality': 'Soft, Friendship',
      'physicalItems': ['Lotus', 'Alliances', 'Groups'],
      'characteristics': 'Devotion, friendship, balance',
    },
    {
      'name': 'Jyeshtha',
      'lord': 'Mercury',
      'deity': 'Indra (King of Gods)',
      'symbol': 'Circular amulet/Umbrella',
      'animal': 'Deer (Male)',
      'gender': 'Female',
      'gana': 'Rakshasa (Demon)',
      'element': 'Air',
      'quality': 'Sharp, Senior',
      'physicalItems': ['Talisman', 'Protection', 'Authority'],
      'characteristics': 'Seniority, protection, responsibility',
    },
    {
      'name': 'Mula',
      'lord': 'Ketu',
      'deity': 'Nirriti (Goddess of Destruction)',
      'symbol': 'Bundle of roots/Lion\'s tail',
      'animal': 'Dog (Male)',
      'gender': 'Neutral',
      'gana': 'Rakshasa (Demon)',
      'element': 'Air',
      'quality': 'Sharp, Roots',
      'physicalItems': ['Roots', 'Medicine', 'Foundation'],
      'characteristics': 'Investigation, getting to the root',
    },
    {
      'name': 'Purva Ashadha',
      'lord': 'Venus',
      'deity': 'Apas (Water Goddess)',
      'symbol': 'Elephant tusk/Fan',
      'animal': 'Monkey (Male)',
      'gender': 'Female',
      'gana': 'Manushya (Human)',
      'element': 'Air',
      'quality': 'Fierce, Invincible',
      'physicalItems': ['Water', 'Purification', 'Victory'],
      'characteristics': 'Invincibility, purification, pride',
    },
    {
      'name': 'Uttara Ashadha',
      'lord': 'Sun',
      'deity': 'Vishvadevas (Universal Gods)',
      'symbol': 'Elephant tusk/Planks of bed',
      'animal': 'Mongoose (Male)',
      'gender': 'Female',
      'gana': 'Manushya (Human)',
      'element': 'Air',
      'quality': 'Fixed, Permanent',
      'physicalItems': ['Constitution', 'Laws', 'Support'],
      'characteristics': 'Final victory, permanent achievement',
    },
    {
      'name': 'Shravana',
      'lord': 'Moon',
      'deity': 'Vishnu (Preserver God)',
      'symbol': 'Three footprints/Ear',
      'animal': 'Monkey (Female)',
      'gender': 'Male',
      'gana': 'Deva (Divine)',
      'element': 'Air',
      'quality': 'Movable, Listening',
      'physicalItems': ['Ear', 'Learning', 'Connection'],
      'characteristics': 'Listening, learning, knowledge',
    },
    {
      'name': 'Dhanishta',
      'lord': 'Mars',
      'deity': 'Eight Vasus (Gods of Elements)',
      'symbol': 'Drum/Flute',
      'animal': 'Lion (Female)',
      'gender': 'Female',
      'gana': 'Rakshasa (Demon)',
      'element': 'Ether',
      'quality': 'Movable, Prosperous',
      'physicalItems': ['Drum', 'Music', 'Wealth'],
      'characteristics': 'Wealth, music, adaptability',
    },
    {
      'name': 'Shatabhisha',
      'lord': 'Rahu',
      'deity': 'Varuna (God of Cosmic Waters)',
      'symbol': 'Empty circle/1000 flowers',
      'animal': 'Horse (Female)',
      'gender': 'Neutral',
      'gana': 'Rakshasa (Demon)',
      'element': 'Ether',
      'quality': 'Movable, Healing',
      'physicalItems': ['Medicine', 'Secrets', 'Stars'],
      'characteristics': 'Healing, secrecy, mysticism',
    },
    {
      'name': 'Purva Bhadrapada',
      'lord': 'Jupiter',
      'deity': 'Aja Ekapada (One-footed Goat)',
      'symbol': 'Sword/Two-faced man',
      'animal': 'Lion (Male)',
      'gender': 'Male',
      'gana': 'Manushya (Human)',
      'element': 'Ether',
      'quality': 'Fierce, Purification',
      'physicalItems': ['Fire', 'Funeral cot', 'Transformation'],
      'characteristics': 'Intensity, transformation, idealism',
    },
    {
      'name': 'Uttara Bhadrapada',
      'lord': 'Saturn',
      'deity': 'Ahir Budhnya (Serpent of the Depths)',
      'symbol': 'Back legs of funeral cot/Twins',
      'animal': 'Cow (Female)',
      'gender': 'Male',
      'gana': 'Manushya (Human)',
      'element': 'Ether',
      'quality': 'Fixed, Depth',
      'physicalItems': ['Water', 'Underground', 'Foundation'],
      'characteristics': 'Depth, wisdom, kundalini, occult knowledge',
    },
    {
      'name': 'Revati',
      'lord': 'Mercury',
      'deity': 'Pushan (Nourisher/Protector)',
      'symbol': 'Fish/Drum',
      'animal': 'Elephant (Female)',
      'gender': 'Female',
      'gana': 'Deva (Divine)',
      'element': 'Ether',
      'quality': 'Soft, Nurturing',
      'physicalItems': ['Journey', 'Prosperity', 'Safe passage'],
      'characteristics': 'Nourishment, completion, prosperity',
    },
  ];

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
