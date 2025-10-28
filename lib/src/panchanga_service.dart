/// Core Panchanga calculation service
/// Ported from PyJHora's drik.py
///
/// This service provides all the core panchanga calculations including
/// sunrise, sunset, tithi, nakshatra, yoga, karana, and planet positions
library;

import 'package:sweph/sweph.dart';
import 'panchanga_models.dart';
import 'panchanga_constants.dart';
import 'panchanga_utils.dart';

/// Main service class for panchanga calculations
/// Design: This class handles all Vedic astronomical calculations using Swiss Ephemeris
class PanchangaService {
  static bool _initialized = false;

  /// Initialize the service with ayanamsa mode
  /// Must be called before any calculations
  static Future<void> initialize({String ayanamsaMode = 'LAHIRI'}) async {
    try {
      // Initialize sweph with bundled ephemeris files
      // For mobile, files are copied to app directory
      // For web, files are loaded into memory
      if (!_initialized) {
        await Sweph.init(epheAssets: [
          "packages/sweph/assets/ephe/semo_18.se1",  // moon ephemeris
          "packages/sweph/assets/ephe/sepl_18.se1",  // planets ephemeris
        ]);
      }
      
      setAyanamsaMode(ayanamsaMode);
      _initialized = true;
    } catch (e) {
      throw Exception('Failed to initialize PanchangaService: $e');
    }
  }

  /// Set the ayanamsa (precession) mode for sidereal calculations
  /// @param mode: Ayanamsa mode (LAHIRI, KP, RAMAN, etc.)
  static void setAyanamsaMode(String mode) {
    try {
      final sidMode = PanchangaConstants.ayanamsaModes[mode.toUpperCase()] ?? 1;
      Sweph.swe_set_sid_mode(
          SiderealMode(sidMode), SiderealModeFlag.SE_SIDBIT_NONE, 0);
    } catch (e) {
      throw Exception('Failed to set ayanamsa mode: $e');
    }
  }

  /// Calculate sidereal longitude of a planet
  /// @param jdUtc: Julian Day Number (UTC)
  /// @param planet: Planet constant from PanchangaConstants
  /// @return: Sidereal longitude in degrees (0-360)
  static double siderealLongitude(double jdUtc, int planet) {
    try {
      final flags = SwephFlag.SEFLG_SWIEPH | SwephFlag.SEFLG_SIDEREAL;

      // Handle Ketu (opposite of Rahu)
      int actualPlanet =
          planet == PanchangaConstants.ketu ? PanchangaConstants.rahu : planet;

      final result =
          Sweph.swe_calc_ut(jdUtc, HeavenlyBody(actualPlanet), flags);
      double longitude = result.longitude;

      // Ketu is 180° opposite to Rahu
      if (planet == PanchangaConstants.ketu) {
        longitude = (longitude + 180) % 360;
      }

      return PanchangaUtils.norm360(longitude);
    } catch (e) {
      throw Exception('Failed to calculate sidereal longitude: $e');
    }
  }

  /// Get lunar longitude
  static double lunarLongitude(double jdUtc) {
    return siderealLongitude(jdUtc, PanchangaConstants.moon);
  }

  /// Get solar longitude
  static double solarLongitude(double jdUtc) {
    return siderealLongitude(jdUtc, PanchangaConstants.sun);
  }

  /// Calculate sunrise time
  /// @param jd: Julian Day Number (local time)
  /// @param place: Place information
  /// @return: Map with sunrise time and string representation
  static Map<String, dynamic> sunrise(double jd, Place place) {
    try {
      final dateInfo = PanchangaUtils.jdToGregorian(jd);
      final y = dateInfo[0] as int;
      final m = dateInfo[1] as int;
      final d = dateInfo[2] as int;

      final jdUtc = PanchangaUtils.gregorianToJd(y, m, d);
      final geoPos = GeoPosition(place.longitude, place.latitude, 0.0);

      final riseJd = Sweph.swe_rise_trans(
        jdUtc,
        HeavenlyBody.SE_SUN,
        SwephFlag.SEFLG_SWIEPH,
        RiseSetTransitFlag.SE_CALC_RISE | RiseSetTransitFlag.SE_BIT_DISC_CENTER,
        geoPos,
        1013.25,
        15.0,
      );

      if (riseJd == null) {
        throw Exception('Sunrise not found (circumpolar)');
      }

      // Convert JD to local time: riseJd is in UTC, add timezone to get local JD
      // Then extract hours from midnight
      final riseJdLocal = riseJd + place.timezone / 24;
      final riseDate = PanchangaUtils.jdToGregorian(riseJdLocal);
      final riseLocalTime = riseDate[3] as double; // Hours since midnight

      return {
        'time': riseLocalTime,
        'timeString': PanchangaUtils.toDms(riseLocalTime, asString: true),
        'jd': riseJd,
      };
    } catch (e) {
      throw Exception('Failed to calculate sunrise: $e');
    }
  }

  /// Calculate sunset time
  /// @param jd: Julian Day Number (local time)
  /// @param place: Place information
  /// @return: Map with sunset time and string representation
  static Map<String, dynamic> sunset(double jd, Place place) {
    try {
      final dateInfo = PanchangaUtils.jdToGregorian(jd);
      final y = dateInfo[0] as int;
      final m = dateInfo[1] as int;
      final d = dateInfo[2] as int;

      final jdUtc = PanchangaUtils.gregorianToJd(y, m, d);
      final geoPos = GeoPosition(place.longitude, place.latitude, 0.0);

      final setJd = Sweph.swe_rise_trans(
        jdUtc,
        HeavenlyBody.SE_SUN,
        SwephFlag.SEFLG_SWIEPH,
        RiseSetTransitFlag.SE_CALC_SET | RiseSetTransitFlag.SE_BIT_DISC_CENTER,
        geoPos,
        1013.25,
        15.0,
      );

      if (setJd == null) {
        throw Exception('Sunset not found (circumpolar)');
      }

      // Convert JD to local time: setJd is in UTC, add timezone to get local JD
      // Then extract hours from midnight
      final setJdLocal = setJd + place.timezone / 24;
      final setDate = PanchangaUtils.jdToGregorian(setJdLocal);
      final setLocalTime = setDate[3] as double; // Hours since midnight

      return {
        'time': setLocalTime,
        'timeString': PanchangaUtils.toDms(setLocalTime, asString: true),
        'jd': setJd,
      };
    } catch (e) {
      throw Exception('Failed to calculate sunset: $e');
    }
  }

  /// Calculate moonrise time
  static Map<String, dynamic> moonrise(double jd, Place place) {
    try {
      final dateInfo = PanchangaUtils.jdToGregorian(jd);
      final y = dateInfo[0] as int;
      final m = dateInfo[1] as int;
      final d = dateInfo[2] as int;

      final jdUtc = PanchangaUtils.gregorianToJd(y, m, d);
      final geoPos = GeoPosition(place.longitude, place.latitude, 0.0);

      final riseJd = Sweph.swe_rise_trans(
        jdUtc,
        HeavenlyBody.SE_MOON,
        SwephFlag.SEFLG_SWIEPH,
        RiseSetTransitFlag.SE_CALC_RISE,
        geoPos,
        1013.25,
        15.0,
      );

      if (riseJd == null) {
        throw Exception('Moonrise not found (circumpolar)');
      }

      // Convert JD to local time: riseJd is in UTC, add timezone to get local JD
      // Then extract hours from midnight
      final riseJdLocal = riseJd + place.timezone / 24;
      final riseDate = PanchangaUtils.jdToGregorian(riseJdLocal);
      final riseLocalTime = riseDate[3] as double; // Hours since midnight

      return {
        'time': riseLocalTime,
        'timeString': PanchangaUtils.toDms(riseLocalTime, asString: true),
        'jd': riseJd,
      };
    } catch (e) {
      throw Exception('Failed to calculate moonrise: $e');
    }
  }

  /// Calculate moonset time
  static Map<String, dynamic> moonset(double jd, Place place) {
    try {
      final dateInfo = PanchangaUtils.jdToGregorian(jd);
      final y = dateInfo[0] as int;
      final m = dateInfo[1] as int;
      final d = dateInfo[2] as int;

      final jdUtc = PanchangaUtils.gregorianToJd(y, m, d);
      final geoPos = GeoPosition(place.longitude, place.latitude, 0.0);

      final setJd = Sweph.swe_rise_trans(
        jdUtc,
        HeavenlyBody.SE_MOON,
        SwephFlag.SEFLG_SWIEPH,
        RiseSetTransitFlag.SE_CALC_SET,
        geoPos,
        1013.25,
        15.0,
      );

      if (setJd == null) {
        throw Exception('Moonset not found (circumpolar)');
      }

      // Convert JD to local time: setJd is in UTC, add timezone to get local JD
      // Then extract hours from midnight
      final setJdLocal = setJd + place.timezone / 24;
      final setDate = PanchangaUtils.jdToGregorian(setJdLocal);
      final setLocalTime = setDate[3] as double; // Hours since midnight

      return {
        'time': setLocalTime,
        'timeString': PanchangaUtils.toDms(setLocalTime, asString: true),
        'jd': setJd,
      };
    } catch (e) {
      throw Exception('Failed to calculate moonset: $e');
    }
  }

  /// Calculate nakshatra and pada from longitude
  /// @param longitude: Longitude in degrees
  /// @return: [nakshatra (1-27), pada (1-4), remainder in degrees]
  static List<dynamic> nakshatraPada(double longitude) {
    const oneStar = 360.0 / 27;
    const onePada = 360.0 / 108;

    final quotient = (longitude / oneStar).floor();
    final remainder = longitude % oneStar;
    final pada = (remainder / onePada).floor();

    return [quotient + 1, pada + 1, remainder];
  }

  /// Calculate Tithi (lunar day)
  /// @param jd: Julian Day Number
  /// @param place: Place information
  /// @return: TithiInfo object
  static TithiInfo tithi(double jd, Place place) {
    try {
      final dateInfo = PanchangaUtils.jdToGregorian(jd);
      final jdHours = dateInfo[3] as double;

      final jdUtc = jd - place.timezone / 24;

      // Calculate current tithi
      final moonLong = lunarLongitude(jdUtc);
      final sunLong = solarLongitude(jdUtc);
      double tithiPhase = (moonLong - sunLong) % 360;

      const oneTithi = 360.0 / 30;
      final tithiNum = (tithiPhase / oneTithi).ceil();
      final degreesLeft = tithiNum * oneTithi - tithiPhase;

      // Calculate moon and sun speeds
      final moonSpeed = _dailyMoonSpeed(jd, place);
      final sunSpeed = _dailySunSpeed(jd, place);
      final relativeSpeed = moonSpeed - sunSpeed;

      // Calculate end time in hours from midnight (jdHours is from JD which uses noon)
      final endTime = jdHours + (degreesLeft / relativeSpeed) * 24;
      final startTime =
          endTime - ((endTime - jdHours) / (degreesLeft / oneTithi));

      final tithiName = PanchangaConstants.tithiNames[tithiNum - 1];

      // Check if there's a second tithi
      if (endTime < 24.0) {
        final nextJd = jd + endTime / 24;
        final nextTithi = tithi(nextJd, place);

        return TithiInfo(
          number: tithiNum,
          name: tithiName,
          startTime: startTime < 0 ? 24 + startTime : startTime,
          endTime: endTime,
          nextTithiName: nextTithi.name,
          nextTithiEnd: endTime + (nextTithi.endTime - nextTithi.startTime),
        );
      }

      return TithiInfo(
        number: tithiNum,
        name: tithiName,
        startTime: startTime < 0 ? 24 + startTime : startTime,
        endTime: endTime,
      );
    } catch (e) {
      throw Exception('Failed to calculate tithi: $e');
    }
  }

  /// Calculate Nakshatra (lunar mansion)
  /// @param jd: Julian Day Number
  /// @param place: Place information
  /// @return: NakshatraInfo object
  static NakshatraInfo nakshatra(double jd, Place place) {
    try {
      final dateInfo = PanchangaUtils.jdToGregorian(jd);
      final jdHours = dateInfo[3] as double;
      final jdUtc = jd - place.timezone / 24;

      // Calculate current nakshatra  
      final moonLong = lunarLongitude(jdUtc);
      final nakData = nakshatraPada(moonLong);
      final nakNum = nakData[0] as int;
      final padaNum = nakData[1] as int;

      const oneStar = 360.0 / 27;
      final degreesLeft = nakNum * oneStar - moonLong;

      final moonSpeed = _dailyMoonSpeed(jd, place);
      // Calculate end time in hours from midnight
      final endTime = jdHours + (degreesLeft / moonSpeed) * 24;

      // Calculate start time based on current position and speed
      // Instead of recursively calling nakshatra for previous day
      final nakData0 = nakshatraPada(moonLong);
      final remainder = nakData0[2] as double;
      final elapsedTime = (remainder / moonSpeed) * 24;
      final startTime = jdHours - elapsedTime;

      final nakName = PanchangaConstants.nakshatraNames[nakNum - 1];
      
      // Get detailed nakshatra information
      final details = PanchangaConstants.nakshatraDetails[nakNum - 1];

      // Check if there's a second nakshatra
      if (endTime < 24.0) {
        final nextNakNum = (nakNum % 27) + 1;
        final nextNakName = PanchangaConstants.nakshatraNames[nextNakNum - 1];

        return NakshatraInfo(
          number: nakNum,
          name: nakName,
          pada: padaNum,
          startTime: startTime < 0 ? 24 + startTime : startTime,
          endTime: endTime,
          nextNakshatraName: nextNakName,
          nextNakshatraPada: 1,
          nextNakshatraEnd: 24.0,
          lord: details['lord'] as String,
          deity: details['deity'] as String,
          symbol: details['symbol'] as String,
          animal: details['animal'] as String,
          gender: details['gender'] as String,
          gana: details['gana'] as String,
          element: details['element'] as String,
          quality: details['quality'] as String,
          physicalItems: List<String>.from(details['physicalItems'] as List),
          characteristics: details['characteristics'] as String,
        );
      }

      return NakshatraInfo(
        number: nakNum,
        name: nakName,
        pada: padaNum,
        startTime: startTime < 0 ? 24 + startTime : startTime,
        endTime: endTime,
        lord: details['lord'] as String,
        deity: details['deity'] as String,
        symbol: details['symbol'] as String,
        animal: details['animal'] as String,
        gender: details['gender'] as String,
        gana: details['gana'] as String,
        element: details['element'] as String,
        quality: details['quality'] as String,
        physicalItems: List<String>.from(details['physicalItems'] as List),
        characteristics: details['characteristics'] as String,
      );
    } catch (e) {
      throw Exception('Failed to calculate nakshatra: $e');
    }
  }

  /// Calculate Yoga
  /// @param jd: Julian Day Number
  /// @param place: Place information
  /// @return: YogaInfo object
  static YogaInfo yoga(double jd, Place place) {
    try {
      final dateInfo = PanchangaUtils.jdToGregorian(jd);
      final jdHours = dateInfo[3] as double;

      final sunriseData = sunrise(jd, place);
      final sunriseJd = sunriseData['jd'] as double;

      // Yoga = (Moon longitude + Sun longitude) / 13.333...
      final moonLong = lunarLongitude(sunriseJd - place.timezone / 24);
      final sunLong = solarLongitude(sunriseJd - place.timezone / 24);
      final total = (moonLong + sunLong) % 360;

      const oneYoga = 360.0 / 27;
      final yogaNum = (total / oneYoga).ceil();
      final degreesLeft = yogaNum * oneYoga - total;

      final moonSpeed = _dailyMoonSpeed(jd, place);
      final sunSpeed = _dailySunSpeed(jd, place);
      final totalSpeed = moonSpeed + sunSpeed;

      final endTime = jdHours + (degreesLeft / totalSpeed) * 24;

      final yogaName = PanchangaConstants.yogaNames[yogaNum - 1];

      return YogaInfo(
        number: yogaNum,
        name: yogaName,
        endTime: endTime,
      );
    } catch (e) {
      throw Exception('Failed to calculate yoga: $e');
    }
  }

  /// Calculate Karana
  /// @param jd: Julian Day Number
  /// @param place: Place information
  /// @return: KaranaInfo object
  static KaranaInfo karana(double jd, Place place) {
    try {
      final tithiData = tithi(jd, place);
      final tithiNum = tithiData.number;

      // There are 2 karanas per tithi
      // Karana = (Tithi - 1) * 2 + karana_within_tithi
      // First 7 karanas repeat 8 times, then 4 fixed karanas

      int karanaNum;
      if (tithiNum == 30) {
        // Amavasya - last 4 karanas
        karanaNum = 8; // Shakuni
      } else if (tithiNum == 15) {
        // Purnima - last 4 karanas
        karanaNum = 9; // Chatushpada
      } else {
        // Regular karanas (1-7 repeat)
        karanaNum = ((tithiNum - 1) * 2) % 7 + 1;
      }

      final karanaName = PanchangaConstants.karanaNames[karanaNum - 1];

      return KaranaInfo(
        number: karanaNum,
        name: karanaName,
        endTime: tithiData.endTime,
      );
    } catch (e) {
      throw Exception('Failed to calculate karana: $e');
    }
  }

  /// Calculate Moon's Rasi (zodiac sign)
  /// @param jd: Julian Day Number
  /// @param place: Place information
  /// @return: RasiInfo object
  static RasiInfo moonRasi(double jd, Place place) {
    try {
      final jdUtc = jd - place.timezone / 24;
      final moonLong = lunarLongitude(jdUtc);

      final rasiNum = (moonLong / 30).floor() + 1;
      final rasiName = PanchangaConstants.rasiNames[rasiNum - 1];

      // Calculate when moon leaves this rasi
      final degreesLeft = rasiNum * 30 - moonLong;
      final moonSpeed = _dailyMoonSpeed(jd, place);

      final dateInfo = PanchangaUtils.jdToGregorian(jd);
      final jdHours = dateInfo[3] as double;
      final endTime = jdHours + (degreesLeft / moonSpeed) * 24;

      return RasiInfo(
        number: rasiNum,
        name: rasiName,
        endTime: endTime,
      );
    } catch (e) {
      throw Exception('Failed to calculate rasi: $e');
    }
  }

  /// Calculate day length
  static double dayLength(double jd, Place place) {
    final sunriseData = sunrise(jd, place);
    final sunsetData = sunset(jd, place);
    return sunsetData['time'] - sunriseData['time'];
  }

  /// Calculate night length
  static double nightLength(double jd, Place place) {
    final sunsetData = sunset(jd, place);
    final nextSunriseData = sunrise(jd + 1, place);
    return 24.0 + nextSunriseData['time'] - sunsetData['time'];
  }

  /// Get weekday name
  static String weekday(double jd) {
    final dateInfo = PanchangaUtils.jdToGregorian(jd);
    final date = DateTime(dateInfo[0], dateInfo[1], dateInfo[2]);
    return PanchangaConstants.weekdayNames[date.weekday % 7];
  }

  /// Calculate complete panchanga for a day
  /// @param date: DateTime object
  /// @param place: Place information
  /// @return: Complete PanchangaData object
  static PanchangaData calculatePanchanga(DateTime date, Place place) {
    try {
      if (!_initialized) {
        initialize();
      }

      final jd = PanchangaUtils.gregorianToJd(
        date.year,
        date.month,
        date.day,
        hour: 12,
      );

      final sunriseData = sunrise(jd, place);
      final sunsetData = sunset(jd, place);
      final moonriseData = moonrise(jd, place);
      final moonsetData = moonset(jd, place);

      final tithiData = tithi(jd, place);
      final nakshatraData = nakshatra(jd, place);
      final yogaData = yoga(jd, place);
      final karanaData = karana(jd, place);
      final rasiData = moonRasi(jd, place);

      final dayLen = dayLength(jd, place);
      final nightLen = nightLength(jd, place);
      final weekdayName = weekday(jd);

      return PanchangaData(
        date: date,
        place: place,
        sunriseTime: sunriseData['time'],
        sunriseString: sunriseData['timeString'],
        sunsetTime: sunsetData['time'],
        sunsetString: sunsetData['timeString'],
        moonriseTime: moonriseData['time'],
        moonriseString: moonriseData['timeString'],
        moonsetTime: moonsetData['time'],
        moonsetString: moonsetData['timeString'],
        tithi: tithiData,
        nakshatra: nakshatraData,
        yoga: yogaData,
        karana: karanaData,
        moonRasi: rasiData,
        weekday: weekdayName,
        dayLength: dayLen,
        nightLength: nightLen,
      );
    } catch (e) {
      throw Exception('Failed to calculate panchanga: $e');
    }
  }

  /// Helper: Calculate daily moon speed
  static double _dailyMoonSpeed(double jd, Place place) {
    final jdUtc = jd - place.timezone / 24;
    final todayLong = lunarLongitude(jdUtc);
    final tomorrowLong = lunarLongitude(jdUtc + 1);

    double speed = tomorrowLong - todayLong;
    if (speed < 0) speed += 360;

    return speed;
  }

  /// Helper: Calculate daily sun speed
  static double _dailySunSpeed(double jd, Place place) {
    final jdUtc = jd - place.timezone / 24;
    final todayLong = solarLongitude(jdUtc);
    final tomorrowLong = solarLongitude(jdUtc + 1);

    double speed = tomorrowLong - todayLong;
    if (speed < 0) speed += 360;

    return speed;
  }

  /// Get planet positions for a given time
  /// @param jd: Julian Day Number
  /// @param place: Place information
  /// @return: List of PlanetPosition objects
  static List<PlanetPosition> planetPositions(double jd, Place place) {
    try {
      final jdUtc = jd - place.timezone / 24;
      final positions = <PlanetPosition>[];

      for (int i = 0; i < PanchangaConstants.planetList.length; i++) {
        final planet = PanchangaConstants.planetList[i];
        final longitude = siderealLongitude(jdUtc, planet);

        // Get detailed position info
        final flags = SwephFlag.SEFLG_SWIEPH | SwephFlag.SEFLG_SIDEREAL;
        int actualPlanet = planet == PanchangaConstants.ketu
            ? PanchangaConstants.rahu
            : planet;

        final result =
            Sweph.swe_calc_ut(jdUtc, HeavenlyBody(actualPlanet), flags);

        final rasiNum = (longitude / 30).floor() + 1;
        final rasiLong = longitude % 30;
        final isRetrograde = result.speedInLongitude < 0;

        positions.add(PlanetPosition(
          planet: i,
          name: PanchangaConstants.planetNames[i],
          longitude: longitude,
          latitude: result.latitude,
          distance: result.distance,
          longitudeSpeed: result.speedInLongitude,
          isRetrograde: isRetrograde && i < 7, // Rahu/Ketu always retrograde
          rasi: rasiNum,
          rasiName: PanchangaConstants.rasiNames[rasiNum - 1],
          rasiLongitude: rasiLong,
        ));
      }

      return positions;
    } catch (e) {
      throw Exception('Failed to get planet positions: $e');
    }
  }
}
