import 'package:wikipedia/wikipedia.dart';

/// Simple Localizations similar to
/// https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization#an-alternative-class-for-the-apps-localized-resources
class AppStrings {
  static const Map<String, String> _strings = <String, String>{
    'wikipediaDart': 'Wikipedia Dart',
    'dailyFeed': 'Daily feed',
    'featuredArticle': 'Featured article',
    'today': 'Today',
    'onThisDay': 'On this day',
    'historicEvents': 'historic events',
    'imageOfTheDay': 'Image of the day',
    'by': 'By',
    'from': 'from',
    'imageOfTheDayFor': 'Image of the day for',
    'mostRead': 'Most read articles',
    'randomArticle': 'Random Article',
    'fromLanguageWikipedia': 'from English Wikipedia',
    'savedArticles': 'Saved articles',
    'noSavedArticles': 'No saved articles',
    'selectAnArticle': 'Select an article',

    // generic ui elements
    'saveForLater': 'Save for later',
    'filters': 'Filters',
    'confirmChoices': 'Confirm choices',

    // exception text
    'failedToFetch': 'Failed to get',
    'tryingAgain': 'Trying again.',
    'dataFromWikipedia': 'data from Wikipedia.',
  };

  // If string for "label" does not exist, will show "[LABEL]"
  static String _get(String label) =>
      _strings[label] ?? '[${label.toUpperCase()}]';

  static String get wikipediaDart => _get('wikipediaDart');
  static String get dailyFeed => _get('dailyFeed');
  static String get todaysFeaturedArticle => _get('featuredArticle');
  static String get today => _get('today');
  static String get onThisDay => _get('onThisDay');
  static String get _historicEvents => _get('historicEvents');
  static String get imageOfTheDay => _get('imageOfTheDay');
  static String get _imageOfTheDayFor => _get('imageOfTheDayFor');
  static String get mostRead => _get('mostRead');
  static String get randomArticle => _get('randomArticle');
  static String get dataFromWikipedia => _get('dataFromWikipedia');
  static String get fromLanguageWikipedia => _get('fromLanguageWikipedia');
  static String get fromToday => '$_from ${DateTime.now().humanReadable}';

  static String get _by => _get('by');
  static String get _from => _get('from');

  static String imageOfTheDayFor(String date) => '$_imageOfTheDayFor $date';
  static String by(String attribution) => '$_by $attribution';
  static String historicEvents(String count) => '$count $_historicEvents';
  static String yearRange(String years) => '$_from $years';

  // generic ui elements
  static String get saveForLater => _get('saveForLater');
  static String get filters => _get('filters');
  static String get confirmChoices => _get('confirmChoices');

  // Exception text
  static String get _failedToFetch => _get('failedToFetch');
  static String get tryingAgain => _get('tryingAgain');
  static String get failedToGetTimelineDataFromWikipedia =>
      '$_failedToFetch $onThisDay $dataFromWikipedia';

  static String get failedToGetDailyFeedDataFromWikipedia =>
      '$_failedToFetch $dailyFeed $dataFromWikipedia';
}
