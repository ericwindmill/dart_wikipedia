import 'dart:io';

import 'package:cli/cli.dart';
import 'package:test/test.dart';

void main() {
  group('logger', () {
    test('initFileLogger logs to a file', () {
      final log = 'This is a test.';
      final name = 'test';
      final logger = initFileLogger(name);
      logger.info(log);

      final now = DateTime.now();

      final segments = Platform.script.path.split('/');
      final projectDir = segments.sublist(0, segments.length - 2).join('/');
      final dir = Directory('$projectDir/logs');
      expect(dir.existsSync(), true);
      final logFile = File(
        '${dir.path}/${now.year}_${now.month}_${now.day}_$name.txt',
      );
      expect(logFile.existsSync(), true);
      String contents = logFile.readAsStringSync();
      expect(contents, contains(log));
    });
  });
}
