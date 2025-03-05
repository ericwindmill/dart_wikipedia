import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_app/features/feed/feed_repository.dart';
import 'package:flutter_app/ui/app_localization.dart';
import 'package:wikipedia/wikipedia.dart';

class FeedViewModel extends ChangeNotifier {
  FeedViewModel({required FeedRepository repository})
    : _feedRepository = repository {
    getFeed();
  }

  final FeedRepository _feedRepository;

  String error = '';

  bool get hasError => error != '';

  UnmodifiableListView<Summary> get mostRead =>
      UnmodifiableListView<Summary>(_feed?.mostRead?.take(7) ?? <Summary>[]);

  UnmodifiableListView<OnThisDayEvent> get timelinePreview =>
      UnmodifiableListView<OnThisDayEvent>(
        _feed?.onThisDayTimeline?.take(4).toList() ?? <OnThisDayEvent>[],
      );

  bool get hasImageOfTheDay {
    if (_feed?.imageOfTheDay?.originalImage == null &&
        _feed?.imageOfTheDay?.thumbnail == null) {
      return false;
    }

    return _acceptableImageType(_feed!.imageOfTheDay!.originalImage.source) ||
        _acceptableImageType(_feed!.imageOfTheDay!.thumbnail!.source);
  }

  ImageFile? get imageOfTheDaySource {
    if (!hasImageOfTheDay) return null;
    if (_acceptableImageType(imageOfTheDay?.originalImage.source)) {
      return imageOfTheDay!.originalImage;
    }
    if (_acceptableImageType(imageOfTheDay?.thumbnail?.source)) {
      return imageOfTheDay!.thumbnail;
    }
    return null;
  }

  WikipediaImage? get imageOfTheDay => _feed?.imageOfTheDay;

  Summary? get todaysFeaturedArticle => _todaysFeaturedArticle;

  Summary? get randomArticle => _randomArticle;

  String get readableDate => DateTime.now().humanReadable;

  Summary? _todaysFeaturedArticle;
  Summary? _randomArticle;
  WikipediaFeed? _feed;

  bool get hasData =>
      _feed != null ||
      todaysFeaturedArticle != null ||
      timelinePreview.isNotEmpty ||
      _randomArticle != null;

  bool _acceptableImageType(String? sourceName) {
    if (sourceName != null) {
      final ext = getFileExtension(sourceName);
      if (ext != null && acceptableImageFormats.contains(ext.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  Future<void> getFeed() async {
    try {
      _feed = await _feedRepository.getWikipediaFeed();

      // As a fallback, show a random article
      _todaysFeaturedArticle =
          _feed!.todaysFeaturedArticle ??
          await _feedRepository.getRandomArticle();

      _randomArticle = await _feedRepository.getRandomArticle();
    } on Exception catch (e) {
      debugPrint(e.toString());
      error = AppStrings.failedToGetDailyFeedDataFromWikipedia;
    } finally {
      notifyListeners();
    }
  }
}
