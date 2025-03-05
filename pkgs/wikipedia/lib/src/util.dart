/*
 * // Copyright 2025 The Dart and Flutter teams. All rights reserved.
 * // Use of this source code is governed by a BSD-style license that can be
 * // found in the LICENSE file.
 */

bool verifyMonthAndDate({required int month, required int day}) {
  final List<int> longMonths = <int>[1, 3, 5, 7, 8, 10, 12];
  final List<int> shortMonths = <int>[4, 6, 9, 11];
  if (month < 1 || month > 12) return false;
  if (day < 1) return false;
  if (longMonths.contains(month)) {
    if (day > 31) return false;
  } else if (shortMonths.contains(30)) {
    if (day > 30) return false;
  } else {
    if (day > 29) return false;
  }

  return true;
}

String toStringWithPad(int number) {
  if (number < 10) {
    return number.toString().padLeft(2, '0');
  }

  return number.toString();
}

String padNums(String number) {
  final int asInt = int.parse(number);
  if (asInt < 10) {
    return number.padLeft(2, '0');
  }

  return number;
}

Map<int, String> months = <int, String>{
  1: 'January',
  2: 'February',
  3: 'March',
  4: 'April',
  5: 'May',
  6: 'June',
  7: 'July',
  8: 'August',
  9: 'September',
  10: 'October',
  11: 'November',
  12: 'December',
};

extension Readable on DateTime {
  String get humanReadable {
    return '${months[month]} $day';
  }
}

/// Turns ints into Strings with BCE
/// if the year is negative
extension ReadableYear on int {
  String get absYear {
    if (this < 0) {
      return '${abs()} BCE';
    }

    return abs().toString();
  }
}

String? getFileExtension(String file) {
  final segments = file.split('.');
  if (segments.isNotEmpty) return segments.last;
  return null;
}

const acceptableImageFormats = ['png', 'jpg', 'jpeg'];
