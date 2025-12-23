/// Utility functions for Panchanga calculations
/// Ported from PyJHora's utils.py and drik.py
///
/// This class provides utility functions for astronomical calculations
/// including Julian Day conversions, angle normalization, and interpolation
library;

import 'dart:math' as math;

class PanchangaUtils {
  /// Normalize angle to 0-360 degrees
  /// @param degrees: angle in degrees
  /// @return: normalized angle in the range [0, 360)
  static double norm360(double degrees) {
    return degrees % 360;
  }

  /// Convert degrees, minutes, seconds to decimal degrees
  /// @param degrees: degrees
  /// @param minutes: minutes
  /// @param seconds: seconds
  /// @return: decimal degrees
  static double fromDms(int degrees, int minutes, double seconds) {
    return degrees + minutes / 60.0 + seconds / 3600.0;
  }

  /// Convert decimal hours to hours, minutes, seconds
  /// @param decimalHours: decimal hours (can be >= 24 for next day times)
  /// @param asString: if true, return formatted string
  /// @return: [hours, minutes, seconds] or formatted string
  static dynamic toDms(double decimalHours, {bool asString = false}) {
    // Normalize to 24-hour format (handle times >= 24 hours)
    final normalizedHours = decimalHours % 24;
    final int hours = normalizedHours.floor();
    final double minutesDecimal = (normalizedHours - hours) * 60;
    final int minutes = minutesDecimal.floor();
    final double seconds = (minutesDecimal - minutes) * 60;

    if (asString) {
      // Determine AM/PM based on 24-hour time
      final period = hours < 12 ? 'AM' : 'PM';
      // Convert to 12-hour format
      final displayHours = hours == 0 ? 12 : (hours > 12 ? hours - 12 : hours);
      return '${displayHours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.floor().toString().padLeft(2, '0')} $period';
    }
    return [hours, minutes, seconds];
  }

  /// Convert Gregorian date to Julian Day Number
  /// @param year: year
  /// @param month: month (1-12)
  /// @param day: day
  /// @param hour: hour (0-23, can be fractional)
  /// @param minute: minute (0-59)
  /// @param second: second (0-59)
  /// @return: Julian Day Number
  static double gregorianToJd(int year, int month, int day,
      {double hour = 12, int minute = 0, double second = 0}) {
    int a = (14 - month) ~/ 12;
    int y = year + 4800 - a;
    int m = month + 12 * a - 3;

    double jdn = day +
        (153 * m + 2) ~/ 5 +
        365 * y +
        y ~/ 4 -
        y ~/ 100 +
        y ~/ 400 -
        32045;

    // Add time component
    double jd = jdn + (hour - 12) / 24.0 + minute / 1440.0 + second / 86400.0;
    return jd;
  }

  /// Convert Julian Day Number to Gregorian date
  /// @param jd: Julian Day Number
  /// @return: [year, month, day, hours]
  static List<dynamic> jdToGregorian(double jd) {
    final int z = (jd + 0.5).floor();
    final double f = (jd + 0.5) - z;

    int a = z;
    if (z >= 2299161) {
      final int alpha = ((z - 1867216.25) / 36524.25).floor();
      a = z + 1 + alpha - (alpha / 4).floor();
    }

    final int b = a + 1524;
    final int c = ((b - 122.1) / 365.25).floor();
    final int d = (365.25 * c).floor();
    final int e = ((b - d) / 30.6001).floor();

    final int day = b - d - (30.6001 * e).floor();
    final int month = e < 14 ? e - 1 : e - 13;
    final int year = month > 2 ? c - 4716 : c - 4715;
    final double hours = f * 24;

    return [year, month, day, hours];
  }

  /// Unwrap angles to handle 360-degree boundary crossing
  /// @param angles: list of angles
  /// @return: unwrapped angles
  static List<double> unwrapAngles(List<double> angles) {
    List<double> result = [angles[0]];
    for (int i = 1; i < angles.length; i++) {
      double diff = angles[i] - angles[i - 1];
      if (diff > 180) {
        result.add(angles[i] - 360);
      } else if (diff < -180) {
        result.add(angles[i] + 360);
      } else {
        result.add(angles[i]);
      }
    }
    return result;
  }

  /// Inverse Lagrange interpolation
  /// Find x value for given y using 4-point Lagrange interpolation
  /// @param x: list of x values
  /// @param y: list of y values
  /// @param yTarget: target y value
  /// @return: interpolated x value
  static double inverseLagrange(
      List<double> x, List<double> y, double yTarget) {
    // Shift y values to make target y = 0
    List<double> yShifted = y.map((val) => val - yTarget).toList();

    // Find two points that bracket zero
    int i = 0;
    for (i = 0; i < yShifted.length - 1; i++) {
      if (yShifted[i] * yShifted[i + 1] <= 0) break;
    }

    // Use 4 points around the zero crossing for interpolation
    int start = math.max(0, i - 1);
    int end = math.min(yShifted.length, start + 4);
    start = end - 4;

    List<double> xSub = x.sublist(start, end);
    List<double> ySub = yShifted.sublist(start, end);

    // Newton's method for root finding with initial guess
    double xGuess = (xSub[i - start] + xSub[i + 1 - start]) / 2;

    for (int iter = 0; iter < 10; iter++) {
      double yVal = 0;
      double yPrime = 0;

      // Evaluate polynomial and its derivative
      for (int j = 0; j < xSub.length; j++) {
        double term = ySub[j];
        double termPrime = 0;

        for (int k = 0; k < xSub.length; k++) {
          if (k != j) {
            // Calculate derivative term
            double derivProd = 1;
            for (int m = 0; m < xSub.length; m++) {
              if (m != j && m != k) {
                derivProd *= (xGuess - xSub[m]) / (xSub[j] - xSub[m]);
              }
            }
            termPrime += derivProd / (xSub[j] - xSub[k]);

            term *= (xGuess - xSub[k]) / (xSub[j] - xSub[k]);
          }
        }
        yVal += term;
        yPrime += ySub[j] * termPrime;
      }

      if (yPrime.abs() < 1e-10) break;

      double xNew = xGuess - yVal / yPrime;
      if ((xNew - xGuess).abs() < 1e-6) {
        return xNew;
      }
      xGuess = xNew;
    }

    return xGuess;
  }

  /// Calculate Julian Day Number from date and time
  /// @param dob: date as (year, month, day)
  /// @param tob: time as (hour, minute, second)
  /// @return: Julian Day Number
  static double julianDayNumber(List<int> dob, List<num> tob) {
    return gregorianToJd(dob[0], dob[1], dob[2],
        hour: tob[0].toDouble(),
        minute: tob[1].toInt(),
        second: tob[2].toDouble());
  }

  /// Normalize angle to start from a specific angle
  /// @param angle: angle to normalize
  /// @param start: starting angle
  /// @return: normalized angle
  static double normalizeAngle(double angle, {double start = 0}) {
    while (angle < start) {
      angle += 360;
    }
    while (angle >= start + 360) {
      angle -= 360;
    }
    return angle;
  }

  /// Extend angle range to handle boundary crossings
  /// @param angles: list of angles
  /// @param rangeSize: size of the range (default 360)
  /// @return: extended list of angles
  static List<double> extendAngleRange(List<double> angles,
      [double rangeSize = 360]) {
    if (angles.isEmpty) return angles;

    List<double> extended = [];
    extended.add(angles[0]);

    for (int i = 1; i < angles.length; i++) {
      double angle = angles[i];
      double prev = extended.last;

      // If there's a large jump, we might be crossing a boundary
      if ((angle - prev).abs() > rangeSize / 2) {
        if (angle < prev) {
          angle += rangeSize;
        } else {
          angle -= rangeSize;
        }
      }
      extended.add(angle);
    }

    return extended;
  }

  /// Convert local time to UTC
  /// @param jd: Julian Day Number (local time)
  /// @param timezone: timezone offset in hours
  /// @return: Julian Day Number (UTC)
  static double localToUtc(double jd, double timezone) {
    return jd - timezone / 24.0;
  }

  /// Convert UTC to local time
  /// @param jdUtc: Julian Day Number (UTC)
  /// @param timezone: timezone offset in hours
  /// @return: Julian Day Number (local time)
  static double utcToLocal(double jdUtc, double timezone) {
    return jdUtc + timezone / 24.0;
  }

  /// Get fractional part of a number
  /// @param number: the number
  /// @return: fractional part
  static double frac(double number) {
    return number - number.floor();
  }

  /// Linear interpolation
  /// @param x0, y0: first point
  /// @param x1, y1: second point
  /// @param x: x value to interpolate
  /// @return: interpolated y value
  static double linearInterpolation(
      double x0, double y0, double x1, double y1, double x) {
    return y0 + (y1 - y0) * (x - x0) / (x1 - x0);
  }
}
