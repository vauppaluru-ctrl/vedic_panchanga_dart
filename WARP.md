# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

This is a Dart package for Vedic astrology panchanga (Hindu calendar) calculations, ported from PyJHora (Python). It provides accurate astronomical calculations for traditional Hindu calendar elements using the Swiss Ephemeris via the `sweph` package.

**Key characteristics:**
- Pure Dart library (not Flutter-specific)
- Published to pub.dev
- License: AGPL-3.0 (ensures open-source derivative works)
- Based on algorithms from PVR Narasimha Rao's JHora software

## Development Commands

### Testing
```bash
# Run all tests
dart test

# Run specific test file
dart test test/vedic_panchanga_dart_test.dart

# Run tests with coverage
dart test --coverage=coverage
```

### Linting & Analysis
```bash
# Run static analysis
dart analyze

# Fix auto-fixable issues
dart fix --apply
```

### Building & Publishing
```bash
# Get dependencies
dart pub get

# Check package health (before publishing)
dart pub publish --dry-run

# Publish to pub.dev
dart pub publish
```

### Running Examples
```bash
dart run example/example.dart
```

## Architecture & Code Structure

### Core Design Pattern
The library follows a **service-based architecture** with static methods, ported directly from PyJHora's functional Python code:

1. **PanchangaService** (lib/src/panchanga_service.dart) - Main calculation engine
   - Must call `PanchangaService.initialize()` before any calculations
   - All calculation methods are static
   - Wraps Swiss Ephemeris (sweph package) for astronomical calculations
   - Handles sidereal vs tropical zodiac conversions via ayanamsa modes

2. **PanchangaUtils** (lib/src/panchanga_utils.dart) - Mathematical utilities
   - Julian Day Number conversions (Gregorian ↔ JD)
   - Angle normalization and unwrapping
   - Inverse Lagrange interpolation for precise event timings
   - Time zone conversions

3. **PanchangaModels** (lib/src/panchanga_models.dart) - Data structures
   - Immutable data classes for all panchanga elements
   - Built-in JSON serialization
   - toString() methods for human-readable output

4. **PanchangaConstants** (lib/src/panchanga_constants.dart) - Reference data
   - Planet indices mapped to Swiss Ephemeris constants
   - Ayanamsa mode mappings
   - Names for all calendar elements (Tithis, Nakshatras, Yogas, etc.)

### Key Concepts

**Ayanamsa Modes:**
The library supports multiple ayanamsa (precession correction) systems. The mode MUST be set during initialization:
```dart
PanchangaService.initialize(ayanamsaMode: 'LAHIRI'); // Default, most common in India
// Other modes: 'KP', 'RAMAN', 'TRUE_CITRA', 'ARYABHATA', etc.
```

**Julian Day Numbers (JD):**
All internal calculations use Julian Day Numbers for date/time representation. The library handles conversions between Gregorian dates and JD internally, accounting for timezones.

**Place Object:**
Geographic location with timezone is essential for calculations:
```dart
Place(name, latitude, longitude, timezone_in_hours)
// e.g., Place('Chennai', 13.0827, 80.2707, 5.5)
```

**Swiss Ephemeris Dependency:**
The sweph package provides planetary position calculations. It requires ephemeris data files (handled automatically by the package).

### Calculation Flow

```
DateTime + Place
    ↓
Convert to Julian Day (JD)
    ↓
Adjust for timezone → JD_UTC
    ↓
Swiss Ephemeris calculations (siderealLongitude)
    ↓
Apply ayanamsa correction
    ↓
Calculate panchanga elements (tithi, nakshatra, etc.)
    ↓
Return structured data models
```

## Important Implementation Notes

### Swiss Ephemeris Integration
- Ketu is calculated as Rahu + 180° (sweph only provides Rahu)
- Flags used: `SEFLG_SWIEPH | SEFLG_SIDEREAL` for all calculations
- Rise/set calculations use `swe_rise_trans` with specific atmospheric parameters

### Precision & Edge Cases
- **Inverse Lagrange interpolation** is used for precise event timings (tithi/nakshatra end times)
- **Angle unwrapping** handles 360° boundary crossings in lunar/solar calculations
- **Circumpolar cases**: sunrise/sunset can fail at extreme latitudes (throws exception)
- **Two-element days**: Some days can have 2 tithis or 2 nakshatras (stored in models)

### Code Style Enforced by analysis_options.yaml
- Prefer single quotes for strings
- No implicit casts or implicit dynamic
- Explicit return types required
- Prefer final fields
- Missing required params and missing returns are errors

## Testing Guidelines

All tests are in `test/vedic_panchanga_dart_test.dart` organized by groups:
- PanchangaUtils tests: utility functions
- PanchangaConstants tests: data integrity
- PanchangaService tests: calculation accuracy
- Integration tests: complete panchanga calculations

When adding features:
1. Add corresponding test group
2. Use `closeTo()` matcher for floating-point comparisons (astronomical precision)
3. Validate against known astronomical data or PyJHora output
4. Test edge cases: boundary crossings, different ayanamsas, extreme dates

## Common Development Patterns

### Adding New Panchanga Elements
1. Add constants to `PanchangaConstants` (names, counts, etc.)
2. Create model class in `PanchangaModels` with required fields
3. Add calculation method to `PanchangaService` following existing patterns
4. Add unit tests
5. Update `PanchangaData` if it should be part of complete panchanga output

### Porting from PyJHora
This codebase is a direct port, so maintain compatibility:
- Keep method signatures similar to PyJHora equivalents
- Preserve calculation accuracy (match PyJHora's decimal precision)
- Document any deviations from PyJHora in code comments

### Error Handling
All public methods throw exceptions with descriptive messages:
```dart
throw Exception('Failed to calculate sunrise: $e');
```
Let exceptions bubble up - library users should catch them.

## Roadmap Features (Not Yet Implemented)
- Vimsottari Dasha calculations (constants exist, logic not implemented)
- Divisional charts (D-1 to D-144)
- Advanced yoga detection
- Ashtakavarga calculations
- Planetary aspects and relationships

When implementing these, refer to PyJHora's implementation and JHora software documentation.
