# vedic_panchanga_dart

[![pub package](https://img.shields.io/pub/v/vedic_panchanga_dart.svg)](https://pub.dev/packages/vedic_panchanga_dart)
[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)

A comprehensive Dart port of [PyJHora](https://github.com/naturalstupid/pyjhora) for Vedic astrology panchanga calculations. Provides accurate calculations for traditional Hindu calendar elements and planetary positions using the Swiss Ephemeris.

## Features

✨ **Complete Panchanga Calculations**
- 🌅 Sunrise, sunset, moonrise, moonset
- 🌙 Tithi (lunar day) - all 30 tithis
- ⭐ Nakshatra (lunar mansion) with pada - all 27 nakshatras
- 🔄 Yoga - all 27 yogas
- 📆 Karana - all 11 karanas
- ♈ Moon's Rasi (zodiac sign)

🔭 **Astronomical Features**
- Planetary positions (Sun, Moon, Mars, Mercury, Jupiter, Venus, Saturn, Rahu, Ketu)
- Sidereal longitude calculations
- Retrograde planet detection
- Multiple ayanamsa modes (LAHIRI, KP, RAMAN, TRUE_CITRA, etc.)

🎯 **High Precision**
- Based on Swiss Ephemeris for accurate planetary positions
- Supports all major ayanamsa systems
- Inverse Lagrange interpolation for precise event timings

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  vedic_panchanga_dart: ^0.1.0
```

Then run:

```bash
dart pub get
```

Or for Flutter projects:

```bash
flutter pub get
```

## Usage

### Basic Example

```dart
import 'package:vedic_panchanga_dart/vedic_panchanga_dart.dart';

void main() {
  // Initialize the service with desired ayanamsa mode
  PanchangaService.initialize(ayanamsaMode: 'LAHIRI');

  // Create a place (name, latitude, longitude, timezone in hours)
  final chennai = Place('Chennai', 13.0827, 80.2707, 5.5);

  // Calculate panchanga for a specific date
  final date = DateTime(2024, 10, 28);
  final panchanga = PanchangaService.calculatePanchanga(date, chennai);

  // Print the complete panchanga
  print(panchanga);
}
```

### Output Example

```
Panchanga for 2024-10-28 at Chennai
============================================
Weekday: Monday
Sunrise: 06:10:23 AM
Sunset: 05:52:14 PM
Day Length: 11.70 hours
Night Length: 12.30 hours

Tithi: Saptami (05:30 - 18:45)
Nakshatra: Rohini Pada 3 (04:20 - 19:30)
Yoga: Vyaghata (ends at 15:22)
Karana: Bava (ends at 18:45)
Rasi: Taurus (ends at 20:15)

Moonrise: 11:30:45 AM
Moonset: 10:45:22 PM
============================================
```

### Calculate Individual Elements

```dart
import 'package:vedic_panchanga_dart/vedic_panchanga_dart.dart';

void main() {
  PanchangaService.initialize();
  
  final place = Place('Mumbai', 19.0760, 72.8777, 5.5);
  final jd = PanchangaUtils.gregorianToJd(2024, 10, 28);

  // Calculate sunrise/sunset
  final sunrise = PanchangaService.sunrise(jd, place);
  print('Sunrise: ${sunrise['timeString']}');

  // Calculate tithi
  final tithi = PanchangaService.tithi(jd, place);
  print('Tithi: ${tithi.name}');

  // Calculate nakshatra
  final nakshatra = PanchangaService.nakshatra(jd, place);
  print('Nakshatra: ${nakshatra.name} Pada ${nakshatra.pada}');

  // Get planet positions
  final planets = PanchangaService.planetPositions(jd, place);
  for (final planet in planets) {
    print(planet);
  }
}
```

### Different Ayanamsa Modes

```dart
// Use Krishnamurti Paddhati (KP) system
PanchangaService.initialize(ayanamsaMode: 'KP');

// Use Raman ayanamsa
PanchangaService.initialize(ayanamsaMode: 'RAMAN');

// Use True Citra ayanamsa
PanchangaService.initialize(ayanamsaMode: 'TRUE_CITRA');
```

Available ayanamsa modes:
- `LAHIRI` (default) - Most commonly used in India
- `KP` - Krishnamurti Paddhati
- `RAMAN` - B.V. Raman's ayanamsa
- `TRUE_CITRA` - True Chitra Paksha ayanamsa
- `TRUE_REVATI` - True Revati ayanamsa
- `ARYABHATA` - Aryabhata's ayanamsa
- `SURYASIDDHANTA` - Surya Siddhanta ayanamsa
- And more...

### JSON Export

```dart
final panchanga = PanchangaService.calculatePanchanga(date, place);
final json = panchanga.toJson();
print(json);
```

## API Reference

### PanchangaService

Main service class for all calculations.

**Methods:**
- `initialize({String ayanamsaMode})` - Initialize with ayanamsa mode
- `calculatePanchanga(DateTime date, Place place)` - Get complete panchanga
- `sunrise(double jd, Place place)` - Calculate sunrise
- `sunset(double jd, Place place)` - Calculate sunset
- `moonrise(double jd, Place place)` - Calculate moonrise
- `moonset(double jd, Place place)` - Calculate moonset
- `tithi(double jd, Place place)` - Calculate tithi
- `nakshatra(double jd, Place place)` - Calculate nakshatra
- `yoga(double jd, Place place)` - Calculate yoga
- `karana(double jd, Place place)` - Calculate karana
- `moonRasi(double jd, Place place)` - Calculate moon's rasi
- `planetPositions(double jd, Place place)` - Get all planet positions
- `siderealLongitude(double jdUtc, int planet)` - Get planet's sidereal longitude

### PanchangaUtils

Utility functions for conversions and calculations.

**Methods:**
- `gregorianToJd(year, month, day, {hour, minute, second})` - Convert to Julian Day
- `jdToGregorian(jd)` - Convert from Julian Day
- `norm360(degrees)` - Normalize angle to 0-360
- `toDms(decimalHours, {asString})` - Convert to hours:minutes:seconds
- `inverseLagrange(x, y, yTarget)` - Inverse Lagrange interpolation

### Models

**Place**
- Represents geographical location with timezone

**PanchangaData**
- Complete panchanga information for a day

**TithiInfo**
- Tithi number, name, start/end times

**NakshatraInfo**
- Nakshatra number, name, pada, start/end times

**YogaInfo**
- Yoga number, name, end time

**KaranaInfo**
- Karana number, name, end time

**RasiInfo**
- Rasi number, name, end time

**PlanetPosition**
- Planet longitude, latitude, speed, retrograde status, rasi

## Background

This package is a Dart port of the excellent [PyJHora](https://github.com/naturalstupid/pyjhora) Python library by @naturalstupid. PyJHora itself is based on algorithms from PVR Narasimha Rao's JHora software, a widely respected tool in Vedic astrology.

### Porting Notes

The port maintains the same calculation accuracy as PyJHora by using:
- Swiss Ephemeris (via the [sweph](https://pub.dev/packages/sweph) package)
- Same interpolation algorithms
- Same ayanamsa modes and constants

## Limitations

- Requires Swiss Ephemeris data files (handled automatically by the sweph package)
- Currently supports core panchanga features
- Advanced features (dashas, divisional charts, yogas) planned for future releases

## Roadmap

- [ ] Vimsottari Dasha calculations
- [ ] Divisional charts (D-1 to D-144)
- [ ] Advanced yoga detection
- [ ] Ashtakavarga calculations
- [ ] Planetary aspects and relationships
- [ ] Support for other calendar systems

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the GNU Affero General Public License v3.0 (AGPL-3.0) - see the [LICENSE](LICENSE) file for details.

This license is chosen to match the original PyJHora license. The AGPL-3.0 ensures that:
- The source code must remain open
- Any modifications must also be open-sourced
- Network use counts as distribution (important for web applications)

## Credits

- **PyJHora** by @naturalstupid - Original Python implementation
- **PVR Narasimha Rao** - JHora software and algorithms
- **Swiss Ephemeris** - Astronomical calculations
- **sweph package** - Dart bindings for Swiss Ephemeris

## References

- PyJHora: https://github.com/naturalstupid/pyjhora
- Swiss Ephemeris: https://www.astro.com/swisseph/
- JHora: https://www.vedicastrologer.org/jh/
- Vedic Astrology: "Vedic Astrology - An Integrated Approach" by PVR Narasimha Rao

## Support

If you find this package useful, please give it a ⭐ on GitHub and a 👍 on pub.dev!

For bugs and feature requests, please file an issue on GitHub.
