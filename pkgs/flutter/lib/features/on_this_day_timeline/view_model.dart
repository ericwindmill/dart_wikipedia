import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:wikipedia/wikipedia.dart';

import 'repository.dart';

class TimelineViewModel extends ChangeNotifier {
  TimelineViewModel({required TimelineRepository repository})
    : _repository = repository {
    getTimelineForDay(_date.month, _date.day);
  }

  Summary? _activeArticle;

  Summary? get activeArticle => _activeArticle;

  set activeArticle(Summary? value) {
    _activeArticle = value;
    notifyListeners();
  }

  final TimelineRepository _repository;

  List<OnThisDayEvent> _filteredEvents = <OnThisDayEvent>[];
  UnmodifiableListView<OnThisDayEvent> get filteredEvents =>
      UnmodifiableListView<OnThisDayEvent>(_filteredEvents);

  final DateTime _date = DateTime.now();

  late OnThisDayTimeline _timeline;

  String? error;

  bool get hasData => _filteredEvents.isNotEmpty;

  bool get hasError => error != null;

  // Be default, only show 'selected' events
  ValueNotifier<Map<EventType, bool>> selectEventTypes =
      ValueNotifier<Map<EventType, bool>>(<EventType, bool>{
        EventType.holiday: false,
        EventType.birthday: false,
        EventType.death: false,
        EventType.selected: true,
        EventType.event: true,
      });

  void toggleSelectedType({required bool isChecked, required EventType type}) {
    selectEventTypes.value[type] = isChecked;
    notifyListeners();
  }

  /// Returns the date with the format 'Month DD'
  String get readableDate {
    return _date.humanReadable;
  }

  String get readableYearRange {
    if (filteredEvents.every(
      (OnThisDayEvent e) => e.type == EventType.holiday,
    )) {
      return '';
    }

    final int start =
        filteredEvents
            .lastWhere((OnThisDayEvent e) => e.type != EventType.holiday)
            .year!;
    final int end =
        filteredEvents
            .firstWhere((OnThisDayEvent e) => e.type != EventType.holiday)
            .year!;

    return '${start.absYear}-${end.absYear}';
  }

  void filterEvents() {
    final Map<EventType, bool> selectedTypes = selectEventTypes.value;
    _filteredEvents =
        _timeline.all.where((OnThisDayEvent event) {
          return selectedTypes[event.type]!;
        }).toList();

    _filteredEvents.sort((OnThisDayEvent eventA, OnThisDayEvent eventB) {
      // Sorts all holidays to the end
      if (eventA.type == EventType.holiday) return -1;
      if (eventB.type == EventType.holiday) return 1;
      return eventB.year!.compareTo(eventA.year!);
    });

    notifyListeners();
  }

  Future<void> getTimelineForDay(int month, int day) async {
    try {
      _timeline = await _repository.getTimelineForDate(month, day);
      filterEvents();
    } on Exception catch (e) {
      debugPrint(e.toString());
      error = 'Failed to get timeline from Wikipedia.';
    } finally {
      notifyListeners();
    }
  }
}
