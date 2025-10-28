import 'package:vedic_panchanga_dart/vedic_panchanga_dart.dart';

void main() {
  print('=== Vedic Panchanga Dart Example ===\n');

  // Initialize the service with LAHIRI ayanamsa (default)
  PanchangaService.initialize(ayanamsaMode: 'LAHIRI');
  print('✓ Initialized with LAHIRI ayanamsa\n');

  // Create places
  final chennai = Place('Chennai', 13.0827, 80.2707, 5.5);
  final mumbai = Place('Mumbai', 19.0760, 72.8777, 5.5);
  final delhi = Place('Delhi', 28.6139, 77.2090, 5.5);

  // Calculate panchanga for today
  final today = DateTime.now();
  print('📅 Calculating panchanga for ${today.toString().split(' ')[0]}\n');

  // Example 1: Complete Panchanga for Chennai
  print('━━━ Example 1: Complete Panchanga ━━━');
  final panchangaChennai = PanchangaService.calculatePanchanga(today, chennai);
  print(panchangaChennai);

  // Example 2: Individual calculations for Mumbai
  print('\n━━━ Example 2: Individual Elements (Mumbai) ━━━');
  final jdMumbai = PanchangaUtils.gregorianToJd(
    today.year,
    today.month,
    today.day,
  );

  final sunriseMumbai = PanchangaService.sunrise(jdMumbai, mumbai);
  print('🌅 Sunrise: ${sunriseMumbai['timeString']}');

  final sunsetMumbai = PanchangaService.sunset(jdMumbai, mumbai);
  print('🌇 Sunset: ${sunsetMumbai['timeString']}');

  final tithiMumbai = PanchangaService.tithi(jdMumbai, mumbai);
  print(
      '🌙 Tithi: ${tithiMumbai.name} (ends at ${tithiMumbai.endTime.toStringAsFixed(2)}h)');

  final nakshatraMumbai = PanchangaService.nakshatra(jdMumbai, mumbai);
  print('⭐ Nakshatra: ${nakshatraMumbai.name} Pada ${nakshatraMumbai.pada}');

  // Example 3: Planet Positions for Delhi
  print('\n━━━ Example 3: Planet Positions (Delhi) ━━━');
  final jdDelhi = PanchangaUtils.gregorianToJd(
    today.year,
    today.month,
    today.day,
  );

  final planets = PanchangaService.planetPositions(jdDelhi, delhi);
  print('Planetary positions at noon:\n');
  for (final planet in planets) {
    print(planet);
  }

  // Example 4: Comparing different ayanamsas
  print('\n━━━ Example 4: Different Ayanamsa Modes ━━━');
  final testDate = DateTime(2024, 10, 28);
  final testJd = PanchangaUtils.gregorianToJd(2024, 10, 28);

  final ayanamsas = ['LAHIRI', 'KP', 'RAMAN'];
  for (final ayanamsa in ayanamsas) {
    PanchangaService.initialize(ayanamsaMode: ayanamsa);
    final moonLong = PanchangaService.lunarLongitude(
      testJd - chennai.timezone / 24,
    );
    final rasiNum = (moonLong / 30).floor() + 1;
    final rasiName = PanchangaConstants.rasiNames[rasiNum - 1];
    print(
        '$ayanamsa: Moon in $rasiName at ${(moonLong % 30).toStringAsFixed(2)}°');
  }

  // Example 5: JSON Export
  print('\n━━━ Example 5: JSON Export ━━━');
  PanchangaService.initialize(ayanamsaMode: 'LAHIRI');
  final panchangaJson = PanchangaService.calculatePanchanga(testDate, chennai);
  final json = panchangaJson.toJson();
  print('JSON keys: ${json.keys.join(', ')}');
  print('Tithi data: ${json['tithi']}');

  // Example 6: Multiple days
  print('\n━━━ Example 6: Week Panchanga ━━━');
  print('Tithi for the next 7 days in Chennai:\n');
  for (int i = 0; i < 7; i++) {
    final date = today.add(Duration(days: i));
    final jd = PanchangaUtils.gregorianToJd(date.year, date.month, date.day);
    final tithi = PanchangaService.tithi(jd, chennai);
    final weekday = PanchangaService.weekday(jd);
    print('${date.toString().split(' ')[0]} ($weekday): ${tithi.name}');
  }

  print('\n✓ All examples completed successfully!');
}
