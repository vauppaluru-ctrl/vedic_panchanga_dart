import 'package:vedic_panchanga_dart/vedic_panchanga_dart.dart';

void main() {
  // Initialize the service
  PanchangaService.initialize();
  
  // Test with a known location (e.g., New York)
  final place = Place('New York', 40.7128, -74.0060, -5.0);
  final date = DateTime(2025, 1, 28);
  
  // Calculate panchanga
  final panchanga = PanchangaService.calculatePanchanga(date, place);
  
  print('Date: ${date}');
  print('Location: ${place.name}');
  print('Timezone: ${place.timezone}');
  print('');
  print('Sunrise Time (decimal): ${panchanga.sunriseTime}');
  print('Sunrise String: ${panchanga.sunriseString}');
  print('');
  print('Sunset Time (decimal): ${panchanga.sunsetTime}');
  print('Sunset String: ${panchanga.sunsetString}');
}
