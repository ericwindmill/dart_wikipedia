// ignore_for_file: always_specify_types

import 'event_type.dart';
import 'summary.dart';

class OnThisDayEvent {
  /// Returns a new [OnThisDayEvent] instance.
  OnThisDayEvent({
    required this.text,
    required this.type,
    this.pages = const <Summary>[],
    this.year,
  });

  /// Short description of the event
  String text;

  /// List of pages related to the event
  List<Summary> pages;

  /// Year of the event
  final int? year;

  /// Selected: a list of a few selected anniversaries which occur on the
  ///   provided day and month; often the entries are curated for
  ///   the current year
  /// Births: a list of birthdays which happened on the provided day and month
  /// Deaths: a list of deaths which happened on the provided day and month
  /// Holidays: a list of fixed holidays celebrated on the
  ///   provided day and month
  /// Events: a list of significant events which happened on the provided
  ///   day and month and which are not covered by the other types yet
  final EventType type;

  /// Returns -1 if [year] is null
  int get yearsAgo => year != null ? DateTime.now().year - year! : -1;

  @override
  String toString() => 'OnThisDayInner[text=$text, type=${type.name}]';

  static OnThisDayEvent fromJson(Map<String, Object?> json, EventType t) {
    return switch (json) {
      {
        'text': final String text,
        'year': final int year,
        'pages': final Iterable pages,
      } =>
        OnThisDayEvent(
          text: text,
          year: year,
          pages: <Summary>[for (final p in pages) Summary.fromJson(p)],
          type: t,
        ),
      // holidays don't have years
      {'text': final String text, 'pages': final Iterable pages} =>
        OnThisDayEvent(
          text: text,
          pages: <Summary>[
            for (final Map<String, Object?> p in pages) Summary.fromJson(p),
          ],
          type: t,
        ),
      _ =>
        throw const FormatException('Invalid json in OnThisDayEvent.fromJson'),
    };
  }
}
