import 'dart:io';

import 'package:http/http.dart';
import 'package:test/test.dart';

void main() {
  const port = '8080';
  const host = 'http://0.0.0.0:$port';
  late Process p;

  setUp(() async {
    p = await Process.start(
      'dart',
      ['run', 'bin/server.dart', 'dev'],
      environment: {'PORT': port},
    );
    // Wait for server to start and print to stdout.
    await p.stdout.first;
  });

  tearDown(() => p.kill());

  test('404', () async {
    final response = await get(Uri.parse('$host/foobar'));
    expect(response.statusCode, 404);
  });

  test('Root', () async {
    final response = await get(Uri.parse(host));
    expect(response.statusCode, 200);
  });

  test('feed', () async {
    final response = await get(Uri.parse('$host/feed'));
    expect(response.statusCode, 200);
  });
}
