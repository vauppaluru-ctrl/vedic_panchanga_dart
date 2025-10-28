/// A Dart port of PyJHora for Vedic astrology panchanga calculations.
///
/// This library provides accurate calculations for:
/// - Sunrise, sunset, moonrise, moonset
/// - Tithi (lunar day)
/// - Nakshatra (lunar mansion) with pada
/// - Yoga
/// - Karana
/// - Moon's Rasi (zodiac sign)
/// - Planet positions (Sun to Ketu)
/// - Multiple ayanamsa modes (LAHIRI, KP, RAMAN, etc.)
///
/// Based on Swiss Ephemeris for high-precision astronomical calculations.
///
/// ## Usage
///
/// ```dart
/// import 'package:vedic_panchanga_dart/vedic_panchanga_dart.dart';
///
/// // Initialize the service
/// PanchangaService.initialize(ayanamsaMode: 'LAHIRI');
///
/// // Create a place
/// final chennai = Place('Chennai', 13.0827, 80.2707, 5.5);
///
/// // Calculate panchanga for a date
/// final date = DateTime(2024, 10, 28);
/// final panchanga = PanchangaService.calculatePanchanga(date, chennai);
///
/// // Print results
/// print(panchanga);
/// ```
library vedic_panchanga_dart;

export 'src/panchanga_constants.dart';
export 'src/panchanga_models.dart';
export 'src/panchanga_service.dart';
export 'src/panchanga_utils.dart';
