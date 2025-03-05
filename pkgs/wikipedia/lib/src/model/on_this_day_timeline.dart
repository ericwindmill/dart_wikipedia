// ignore_for_file: always_specify_types

import 'dart:collection';

import 'event_type.dart';
import 'on_this_day_event.dart';

class OnThisDayTimeline extends IterableMixin<OnThisDayEvent> {
  /// Returns a new [OnThisDayTimeline] instance.
  OnThisDayTimeline({
    this.all = const <OnThisDayEvent>[],
    this.births = const <OnThisDayEvent>[],
    this.deaths = const <OnThisDayEvent>[],
    this.events = const <OnThisDayEvent>[],
    this.holidays = const <OnThisDayEvent>[],
    this.selected = const <OnThisDayEvent>[],
  });

  final List<OnThisDayEvent> all;

  final List<OnThisDayEvent> births;

  final List<OnThisDayEvent> deaths;

  final List<OnThisDayEvent> events;

  final List<OnThisDayEvent> holidays;

  final List<OnThisDayEvent> selected;

  @override
  Iterator<OnThisDayEvent> get iterator => all.iterator;

  /// Returns a new [OnThisDayTimeline] instance
  static OnThisDayTimeline fromJson(Map<String, Object?> json) {
    final List<OnThisDayEvent> births =
        json.containsKey('births')
            ? (json['births']! as List)
                .map((e) => OnThisDayEvent.fromJson(e, EventType.birthday))
                .toList()
            : const <OnThisDayEvent>[];

    final List<OnThisDayEvent> deaths =
        json.containsKey('deaths')
            ? (json['deaths']! as List)
                .map((e) => OnThisDayEvent.fromJson(e, EventType.death))
                .toList()
            : const <OnThisDayEvent>[];

    final List<OnThisDayEvent> events =
        json.containsKey('events')
            ? (json['events']! as List)
                .map((e) => OnThisDayEvent.fromJson(e, EventType.event))
                .toList()
            : const <OnThisDayEvent>[];

    final List<OnThisDayEvent> holidays =
        json.containsKey('holidays')
            ? (json['holidays']! as List)
                .map((e) => OnThisDayEvent.fromJson(e, EventType.holiday))
                .toList()
            : const <OnThisDayEvent>[];

    final List<OnThisDayEvent> selected =
        json.containsKey('selected')
            ? (json['selected']! as List)
                .map((e) => OnThisDayEvent.fromJson(e, EventType.selected))
                .toList()
            : const <OnThisDayEvent>[];

    final all = <OnThisDayEvent>[
      ...births,
      ...deaths,
      ...events,
      ...holidays,
      ...selected,
    ]..sort((OnThisDayEvent eventA, OnThisDayEvent eventB) {
      // Sorts all holidays to the end
      if (eventA.type == EventType.holiday) return -1;
      if (eventB.type == EventType.holiday) return 1;
      return eventB.year!.compareTo(eventA.year!);
    });

    return OnThisDayTimeline(
      all: all,
      births: births,
      deaths: deaths,
      events: events,
      holidays: holidays,
      selected: selected,
    );
  }

  OnThisDayEvent operator [](int i) {
    return all[i];
  }

  @override
  String toString() =>
      'OnThisDayResponse['
      'births=$births, '
      'deaths=$deaths, '
      'events=$events, '
      'holidays=$holidays, '
      'selected=$selected'
      ']';
}
