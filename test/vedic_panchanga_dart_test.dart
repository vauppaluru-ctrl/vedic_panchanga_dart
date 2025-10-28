import 'package:test/test.dart';
import 'package:vedic_panchanga_dart/vedic_panchanga_dart.dart';

void main() {
  // Test place - Chennai
  final chennai = Place('Chennai', 13.0827, 80.2707, 5.5);

  setUpAll(() {
    // Initialize service before tests
    PanchangaService.initialize(ayanamsaMode: 'LAHIRI');
  });

  group('PanchangaUtils', () {
    test('gregorianToJd converts date correctly', () {
      // Known value: JD for 2000-01-01 12:00 UTC is 2451545.0
      final jd = PanchangaUtils.gregorianToJd(2000, 1, 1);
      expect(jd, closeTo(2451545.0, 0.0001));
    });

    test('jdToGregorian converts back correctly', () {
      final jd = PanchangaUtils.gregorianToJd(2024, 10, 28);
      final result = PanchangaUtils.jdToGregorian(jd);
      expect(result[0], equals(2024));
      expect(result[1], equals(10));
      expect(result[2], equals(28));
    });

    test('norm360 normalizes angles correctly', () {
      expect(PanchangaUtils.norm360(370), equals(10));
      expect(PanchangaUtils.norm360(-10), equals(350));
      expect(PanchangaUtils.norm360(0), equals(0));
      expect(PanchangaUtils.norm360(360), equals(0));
    });

    test('toDms converts decimal hours correctly', () {
      final result = PanchangaUtils.toDms(12.5);
      expect(result[0], equals(12)); // 12 hours
      expect(result[1], equals(30)); // 30 minutes
      expect(result[2], closeTo(0, 1)); // ~0 seconds
    });
  });

  group('PanchangaConstants', () {
    test('has correct number of planets', () {
      expect(PanchangaConstants.planetList.length, equals(9));
    });

    test('has correct number of nakshatras', () {
      expect(PanchangaConstants.nakshatraNames.length, equals(27));
    });

    test('has correct number of tithis', () {
      expect(PanchangaConstants.tithiNames.length, equals(30));
    });

    test('has correct number of yogas', () {
      expect(PanchangaConstants.yogaNames.length, equals(27));
    });

    test('has correct number of karanas', () {
      expect(PanchangaConstants.karanaNames.length, equals(11));
    });

    test('has correct number of rasis', () {
      expect(PanchangaConstants.rasiNames.length, equals(12));
    });

    test('ayanamsa modes are defined', () {
      expect(PanchangaConstants.ayanamsaModes.containsKey('LAHIRI'), isTrue);
      expect(PanchangaConstants.ayanamsaModes.containsKey('KP'), isTrue);
      expect(PanchangaConstants.ayanamsaModes.containsKey('RAMAN'), isTrue);
    });
  });

  group('PanchangaService - Basic Calculations', () {
    test('calculates sunrise for a known date', () {
      final jd = PanchangaUtils.gregorianToJd(2024, 10, 28);
      final sunrise = PanchangaService.sunrise(jd, chennai);

      // Sunrise in Chennai on Oct 28 should be around 6:00-6:30 AM
      expect(sunrise['time'], greaterThan(5.5));
      expect(sunrise['time'], lessThan(7.0));
      expect(sunrise['timeString'], isNotEmpty);
    });

    test('calculates sunset for a known date', () {
      final jd = PanchangaUtils.gregorianToJd(2024, 10, 28);
      final sunset = PanchangaService.sunset(jd, chennai);

      // Sunset in Chennai on Oct 28 should be around 5:30-6:00 PM
      expect(sunset['time'], greaterThan(17.0));
      expect(sunset['time'], lessThan(18.5));
      expect(sunset['timeString'], isNotEmpty);
    });

    test('calculates lunar longitude', () {
      final jd = PanchangaUtils.gregorianToJd(2024, 10, 28);
      final jdUtc = jd - chennai.timezone / 24;
      final moonLong = PanchangaService.lunarLongitude(jdUtc);

      // Moon longitude should be between 0 and 360
      expect(moonLong, greaterThanOrEqualTo(0));
      expect(moonLong, lessThan(360));
    });

    test('calculates solar longitude', () {
      final jd = PanchangaUtils.gregorianToJd(2024, 10, 28);
      final jdUtc = jd - chennai.timezone / 24;
      final sunLong = PanchangaService.solarLongitude(jdUtc);

      // Sun longitude should be between 0 and 360
      expect(sunLong, greaterThanOrEqualTo(0));
      expect(sunLong, lessThan(360));
    });
  });

  group('PanchangaService - Panchanga Elements', () {
    test('calculates tithi correctly', () {
      final jd = PanchangaUtils.gregorianToJd(2024, 10, 28);
      final tithi = PanchangaService.tithi(jd, chennai);

      expect(tithi.number, greaterThan(0));
      expect(tithi.number, lessThanOrEqualTo(30));
      expect(tithi.name, isNotEmpty);
      expect(tithi.startTime, greaterThanOrEqualTo(0));
      expect(tithi.endTime, greaterThan(tithi.startTime));
    });

    test('calculates nakshatra correctly', () {
      final jd = PanchangaUtils.gregorianToJd(2024, 10, 28);
      final nakshatra = PanchangaService.nakshatra(jd, chennai);

      expect(nakshatra.number, greaterThan(0));
      expect(nakshatra.number, lessThanOrEqualTo(27));
      expect(nakshatra.pada, greaterThan(0));
      expect(nakshatra.pada, lessThanOrEqualTo(4));
      expect(nakshatra.name, isNotEmpty);
    });

    test('calculates yoga correctly', () {
      final jd = PanchangaUtils.gregorianToJd(2024, 10, 28);
      final yoga = PanchangaService.yoga(jd, chennai);

      expect(yoga.number, greaterThan(0));
      expect(yoga.number, lessThanOrEqualTo(27));
      expect(yoga.name, isNotEmpty);
      expect(yoga.endTime, greaterThanOrEqualTo(0));
    });

    test('calculates karana correctly', () {
      final jd = PanchangaUtils.gregorianToJd(2024, 10, 28);
      final karana = PanchangaService.karana(jd, chennai);

      expect(karana.number, greaterThan(0));
      expect(karana.number, lessThanOrEqualTo(11));
      expect(karana.name, isNotEmpty);
    });

    test('calculates moon rasi correctly', () {
      final jd = PanchangaUtils.gregorianToJd(2024, 10, 28);
      final rasi = PanchangaService.moonRasi(jd, chennai);

      expect(rasi.number, greaterThan(0));
      expect(rasi.number, lessThanOrEqualTo(12));
      expect(rasi.name, isNotEmpty);
    });
  });

  group('PanchangaService - Complete Panchanga', () {
    test('calculates complete panchanga', () {
      final date = DateTime(2024, 10, 28);
      final panchanga = PanchangaService.calculatePanchanga(date, chennai);

      expect(panchanga.date, equals(date));
      expect(panchanga.place.name, equals('Chennai'));
      expect(panchanga.sunriseTime, greaterThan(5));
      expect(panchanga.sunriseTime, lessThan(7));
      expect(panchanga.sunsetTime, greaterThan(17));
      expect(panchanga.weekday, isNotEmpty);
      expect(panchanga.dayLength, greaterThan(10));
      expect(panchanga.dayLength, lessThan(14));
    });

    test('panchanga toJson works', () {
      final date = DateTime(2024, 10, 28);
      final panchanga = PanchangaService.calculatePanchanga(date, chennai);
      final json = panchanga.toJson();

      expect(json['date'], isNotNull);
      expect(json['place'], isNotNull);
      expect(json['sunrise'], isNotNull);
      expect(json['tithi'], isNotNull);
      expect(json['nakshatra'], isNotNull);
      expect(json['yoga'], isNotNull);
    });
  });

  group('PanchangaService - Planet Positions', () {
    test('gets positions for all planets', () {
      final jd = PanchangaUtils.gregorianToJd(2024, 10, 28);
      final positions = PanchangaService.planetPositions(jd, chennai);

      expect(positions.length, equals(9)); // Sun to Ketu

      for (final pos in positions) {
        expect(pos.longitude, greaterThanOrEqualTo(0));
        expect(pos.longitude, lessThan(360));
        expect(pos.rasi, greaterThan(0));
        expect(pos.rasi, lessThanOrEqualTo(12));
        expect(pos.name, isNotEmpty);
        expect(pos.rasiName, isNotEmpty);
      }
    });

    test('planet positions have valid rasi longitudes', () {
      final jd = PanchangaUtils.gregorianToJd(2024, 10, 28);
      final positions = PanchangaService.planetPositions(jd, chennai);

      for (final pos in positions) {
        expect(pos.rasiLongitude, greaterThanOrEqualTo(0));
        expect(pos.rasiLongitude, lessThan(30));
      }
    });
  });

  group('Place Model', () {
    test('Place model stores data correctly', () {
      final place = Place('Test City', 12.34, 56.78, 5.5);
      expect(place.name, equals('Test City'));
      expect(place.latitude, equals(12.34));
      expect(place.longitude, equals(56.78));
      expect(place.timezone, equals(5.5));
    });

    test('Place toString works', () {
      final place = Place('Test', 10.0, 20.0, 5.5);
      final str = place.toString();
      expect(str, contains('Test'));
      expect(str, contains('10.0'));
      expect(str, contains('20.0'));
    });
  });

  group('Different Ayanamsas', () {
    test('different ayanamsas give different results', () {
      final jd = PanchangaUtils.gregorianToJd(2024, 10, 28);
      final jdUtc = jd - chennai.timezone / 24;

      PanchangaService.initialize(ayanamsaMode: 'LAHIRI');
      final moonLongLahiri = PanchangaService.lunarLongitude(jdUtc);

      PanchangaService.initialize(ayanamsaMode: 'KP');
      final moonLongKP = PanchangaService.lunarLongitude(jdUtc);

      // Different ayanamsas should give different longitudes
      expect((moonLongLahiri - moonLongKP).abs(), greaterThan(0.01));
    });
  });
}
