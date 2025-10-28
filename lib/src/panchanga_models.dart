/// Data models for Panchanga calculations
/// Ported from PyJHora
///
/// This file contains all the data models used for representing
/// panchanga elements like Place, Tithi, Nakshatra, Yoga, Karana, etc.
library;

/// Represents a geographical place with coordinates and timezone
class Place {
  final String name;
  final double latitude;
  final double longitude;
  final double timezone; // in hours (e.g., 5.5 for IST)

  Place(this.name, this.latitude, this.longitude, this.timezone);

  @override
  String toString() {
    return 'Place(name: $name, lat: $latitude, long: $longitude, tz: $timezone)';
  }
}

/// Represents Tithi (Lunar day) information
class TithiInfo {
  final int number; // 1-30
  final String name;
  final double startTime; // in decimal hours
  final double endTime; // in decimal hours
  final String? nextTithiName;
  final double? nextTithiEnd;

  TithiInfo({
    required this.number,
    required this.name,
    required this.startTime,
    required this.endTime,
    this.nextTithiName,
    this.nextTithiEnd,
  });

  bool get hasTwoTithis => nextTithiName != null;

  @override
  String toString() {
    if (hasTwoTithis) {
      return 'Tithi: $name (${_formatTime(startTime)} - ${_formatTime(endTime)}), '
          '$nextTithiName (${_formatTime(endTime)} - ${_formatTime(nextTithiEnd!)})';
    }
    return 'Tithi: $name (${_formatTime(startTime)} - ${_formatTime(endTime)})';
  }

  String _formatTime(double hours) {
    final h = hours.floor();
    final m = ((hours - h) * 60).floor();
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }
}

/// Represents Nakshatra (Lunar mansion) information with comprehensive details
class NakshatraInfo {
  final int number; // 1-27
  final String name;
  final int pada; // 1-4
  final double startTime; // in decimal hours
  final double endTime; // in decimal hours
  final String? nextNakshatraName;
  final int? nextNakshatraPada;
  final double? nextNakshatraEnd;
  
  // Extended nakshatra properties
  final String lord;
  final String deity;
  final String symbol;
  final String animal;
  final String gender;
  final String gana;
  final String element;
  final String quality;
  final List<String> physicalItems;
  final String characteristics;

  NakshatraInfo({
    required this.number,
    required this.name,
    required this.pada,
    required this.startTime,
    required this.endTime,
    this.nextNakshatraName,
    this.nextNakshatraPada,
    this.nextNakshatraEnd,
    required this.lord,
    required this.deity,
    required this.symbol,
    required this.animal,
    required this.gender,
    required this.gana,
    required this.element,
    required this.quality,
    required this.physicalItems,
    required this.characteristics,
  });

  bool get hasTwoNakshatras => nextNakshatraName != null;

  @override
  String toString() {
    if (hasTwoNakshatras) {
      return 'Nakshatra: $name Pada $pada (${_formatTime(startTime)} - ${_formatTime(endTime)}), '
          '$nextNakshatraName Pada $nextNakshatraPada (${_formatTime(endTime)} - ${_formatTime(nextNakshatraEnd!)})';
    }
    return 'Nakshatra: $name Pada $pada (${_formatTime(startTime)} - ${_formatTime(endTime)})';
  }

  String _formatTime(double hours) {
    final h = hours.floor();
    final m = ((hours - h) * 60).floor();
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }
}

/// Represents Yoga information
class YogaInfo {
  final int number; // 1-27
  final String name;
  final double endTime; // in decimal hours

  YogaInfo({
    required this.number,
    required this.name,
    required this.endTime,
  });

  @override
  String toString() {
    return 'Yoga: $name (ends at ${_formatTime(endTime)})';
  }

  String _formatTime(double hours) {
    final h = hours.floor();
    final m = ((hours - h) * 60).floor();
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }
}

/// Represents Karana information
class KaranaInfo {
  final int number; // 1-11
  final String name;
  final double endTime; // in decimal hours

  KaranaInfo({
    required this.number,
    required this.name,
    required this.endTime,
  });

  @override
  String toString() {
    return 'Karana: $name (ends at ${_formatTime(endTime)})';
  }

  String _formatTime(double hours) {
    final h = hours.floor();
    final m = ((hours - h) * 60).floor();
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }
}

/// Represents Rasi (Zodiac sign) information
class RasiInfo {
  final int number; // 1-12
  final String name;
  final double endTime; // in decimal hours

  RasiInfo({
    required this.number,
    required this.name,
    required this.endTime,
  });

  @override
  String toString() {
    return 'Rasi: $name (ends at ${_formatTime(endTime)})';
  }

  String _formatTime(double hours) {
    final h = hours.floor();
    final m = ((hours - h) * 60).floor();
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }
}

/// Represents complete Panchanga data for a day
class PanchangaData {
  final DateTime date;
  final Place place;
  final double sunriseTime; // decimal hours
  final String sunriseString;
  final double sunsetTime; // decimal hours
  final String sunsetString;
  final double moonriseTime; // decimal hours
  final String moonriseString;
  final double moonsetTime; // decimal hours
  final String moonsetString;
  final TithiInfo tithi;
  final NakshatraInfo nakshatra;
  final YogaInfo yoga;
  final KaranaInfo karana;
  final RasiInfo moonRasi;
  final String weekday;
  final double dayLength; // in hours
  final double nightLength; // in hours

  PanchangaData({
    required this.date,
    required this.place,
    required this.sunriseTime,
    required this.sunriseString,
    required this.sunsetTime,
    required this.sunsetString,
    required this.moonriseTime,
    required this.moonriseString,
    required this.moonsetTime,
    required this.moonsetString,
    required this.tithi,
    required this.nakshatra,
    required this.yoga,
    required this.karana,
    required this.moonRasi,
    required this.weekday,
    required this.dayLength,
    required this.nightLength,
  });

  @override
  String toString() {
    return '''
Panchanga for ${date.toString().split(' ')[0]} at ${place.name}
============================================
Weekday: $weekday
Sunrise: $sunriseString
Sunset: $sunsetString
Day Length: ${dayLength.toStringAsFixed(2)} hours
Night Length: ${nightLength.toStringAsFixed(2)} hours

$tithi
$nakshatra
$yoga
$karana
$moonRasi

Moonrise: $moonriseString
Moonset: $moonsetString
============================================
''';
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'place': {
        'name': place.name,
        'latitude': place.latitude,
        'longitude': place.longitude,
        'timezone': place.timezone,
      },
      'sunrise': {
        'time': sunriseTime,
        'timeString': sunriseString,
      },
      'sunset': {
        'time': sunsetTime,
        'timeString': sunsetString,
      },
      'moonrise': {
        'time': moonriseTime,
        'timeString': moonriseString,
      },
      'moonset': {
        'time': moonsetTime,
        'timeString': moonsetString,
      },
      'tithi': {
        'number': tithi.number,
        'name': tithi.name,
        'startTime': tithi.startTime,
        'endTime': tithi.endTime,
        'hasTwoTithis': tithi.hasTwoTithis,
        'nextTithiName': tithi.nextTithiName,
        'nextTithiEnd': tithi.nextTithiEnd,
      },
      'nakshatra': {
        'number': nakshatra.number,
        'name': nakshatra.name,
        'pada': nakshatra.pada,
        'startTime': nakshatra.startTime,
        'endTime': nakshatra.endTime,
        'hasTwoNakshatras': nakshatra.hasTwoNakshatras,
        'nextNakshatraName': nakshatra.nextNakshatraName,
        'nextNakshatraPada': nakshatra.nextNakshatraPada,
        'nextNakshatraEnd': nakshatra.nextNakshatraEnd,
      },
      'yoga': {
        'number': yoga.number,
        'name': yoga.name,
        'endTime': yoga.endTime,
      },
      'karana': {
        'number': karana.number,
        'name': karana.name,
        'endTime': karana.endTime,
      },
      'moonRasi': {
        'number': moonRasi.number,
        'name': moonRasi.name,
        'endTime': moonRasi.endTime,
      },
      'weekday': weekday,
      'dayLength': dayLength,
      'nightLength': nightLength,
    };
  }
}

/// Planet position information
class PlanetPosition {
  final int planet;
  final String name;
  final double longitude; // Sidereal longitude in degrees
  final double latitude;
  final double distance; // from Earth
  final double longitudeSpeed; // degrees per day
  final bool isRetrograde;
  final int rasi; // 1-12
  final String rasiName;
  final double rasiLongitude; // within the rasi (0-30)

  PlanetPosition({
    required this.planet,
    required this.name,
    required this.longitude,
    required this.latitude,
    required this.distance,
    required this.longitudeSpeed,
    required this.isRetrograde,
    required this.rasi,
    required this.rasiName,
    required this.rasiLongitude,
  });

  @override
  String toString() {
    final retroStr = isRetrograde ? ' (R)' : '';
    return '$name: $rasiName ${rasiLongitude.toStringAsFixed(2)}°$retroStr';
  }
}
