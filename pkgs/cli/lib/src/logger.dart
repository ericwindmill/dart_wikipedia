/*
 * // Copyright 2025 The Dart and Flutter teams. All rights reserved.
 * // Use of this source code is governed by a BSD-style license that can be
 * // found in the LICENSE file.
 */

import 'dart:io';

import 'package:logging/logging.dart';

/// Creates a logger that logs to a txt file
Logger initFileLogger(String name) {
  hierarchicalLoggingEnabled = true;
  final logger = Logger(name);
  final now = DateTime.now();

  final segments = Platform.script.path.split('/');
  final projectDir = segments.sublist(0, segments.length - 2).join('/');
  final dir = Directory('$projectDir/logs');
  if (!dir.existsSync()) dir.createSync();
  final logFile = File(
    '${dir.path}/${now.year}_${now.month}_${now.day}_$name.txt',
  );

  logger.level = Level.ALL;
  logger.onRecord.listen((record) {
    final msg =
        '[${record.time} - ${record.loggerName}] ${record.level.name}: ${record.message}';
    logFile.writeAsStringSync('$msg \n', mode: FileMode.append);
  });

  return logger;
}
