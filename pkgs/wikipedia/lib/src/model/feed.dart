// ignore_for_file: always_specify_types

import 'event_type.dart';
import 'image.dart';
import 'on_this_day_event.dart';
import 'summary.dart';

class WikipediaFeed {
  WikipediaFeed({
    required this.todaysFeaturedArticle,
    required this.onThisDayTimeline,
    required this.mostRead,
    required this.imageOfTheDay,
  });
  final Summary? todaysFeaturedArticle;
  final List<OnThisDayEvent>? onThisDayTimeline;
  final List<Summary>? mostRead;
  final WikipediaImage? imageOfTheDay;

  static WikipediaFeed fromJson(Map<String, Object?> json) {
    final featured =
        json.containsKey('tfa')
            ? Summary.fromJson(json['tfa']! as Map<String, Object?>)
            : null;
    final timeline =
        json.containsKey('onthisday')
            ? (json['onthisday'] as List<dynamic>?)
                ?.map(
                  (e) => OnThisDayEvent.fromJson(
                    e as Map<String, dynamic>,
                    EventType.birthday,
                  ),
                )
                .toList()
            : null;
    final image =
        json.containsKey('image')
            ? WikipediaImage.fromJson(json['image']! as Map<String, Object?>)
            : null;

    final mostReadJson =
        json.containsKey('mostread')
            ? (json['mostread']! as Map<String, Object?>)
            : null;
    List<Summary>? mostRead;
    if (mostReadJson != null) {
      mostRead =
          (mostReadJson['articles']! as List<Object?>)
              .map(
                (article) => Summary.fromJson(article! as Map<String, Object?>),
              )
              .toList();
    }

    return WikipediaFeed(
      todaysFeaturedArticle: featured,
      onThisDayTimeline: timeline,
      mostRead: mostRead,
      imageOfTheDay: image,
    );
  }
}
