// ignore_for_file: avoid_print

import 'dart:io';

import 'package:server/routes/article.dart';
import 'package:server/routes/page_summary.dart';
import 'package:server/routes/timeline.dart';
import 'package:server/routes/wikipedia_feed.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

// Configure routes.
final _router =
    Router()
      ..get('/', (Request _) => Response.ok("It's alive!"))
      ..mount('/page', PageSummaryApiRemote().router.call)
      ..mount('/article', ArticleApi().router.call)
      ..mount('/feed', WikipediaFeedApiRemote().router.call)
      ..mount('/timeline', TimelineApiRemote().router.call);

final _devRouter =
    Router()
      ..get('/', (Request _) => Response.ok("It's alive!"))
      ..mount('/page', PageSummaryApiDev().router.call)
      ..mount('/article', ArticleApi().router.call)
      ..mount('/feed', WikipediaFeedApiDev().router.call)
      ..mount('/timeline', TimelineApiDev().router.call);

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  final Pipeline pipeline = const Pipeline().addMiddleware(logRequests());

  final Handler handler =
      args.isNotEmpty && args.first.contains('dev')
          ? _devRouter.call
          : _router.call;

  pipeline.addHandler(handler);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
