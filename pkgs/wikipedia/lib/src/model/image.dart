import 'image_file.dart';

/// Contains images of different sizes and metadata
class WikipediaImage {
  WikipediaImage({
    required this.title,
    required this.originalImage,
    this.artist,
    this.description,
    this.caption,

    this.thumbnail,
  });

  final String title;
  final ImageFile originalImage;
  final String? artist;
  final String? description;
  final String? caption;
  final ImageFile? thumbnail;

  static WikipediaImage fromJson(Map<String, Object?> json) {
    return switch (json) {
      {
        'title': final String title,
        'thumbnail': final Map<String, Object?> thumbnail,
        'image': final Map<String, Object?> originalImage,
        'artist': {'text': final String artistName},
        'description': {'text': final String description},
        'structured': {'captions': {'en': final String caption}},
      } =>
        WikipediaImage(
          title: title,
          artist: artistName,
          description: description,
          caption: caption,
          originalImage: ImageFile.fromJson(originalImage),
          thumbnail: ImageFile.fromJson(thumbnail),
        ),
      {
        'title': final String title,
        'thumbnail': final Map<String, Object?> thumbnail,
        'image': final Map<String, Object?> originalImage,
        'artist': {'text': final String artistName},
        'description': {'text': final String description},
      } =>
        WikipediaImage(
          title: title,
          artist: artistName,
          description: description,
          originalImage: ImageFile.fromJson(originalImage),
          thumbnail: ImageFile.fromJson(thumbnail),
        ),
      // minimum required image properties
      {
        'title': final String title,
        'image': final Map<String, Object?> originalImage,
      } =>
        WikipediaImage(
          title: title,
          originalImage: ImageFile.fromJson(originalImage),
        ),
      {
        'title': final String title,
        'thumbnail': final Map<String, Object?> thumbnailImage,
      } =>
        WikipediaImage(
          title: title,
          originalImage: ImageFile.fromJson(thumbnailImage),
        ),
      _ => throw FormatException('Could not deserialize Image, json=$json'),
    };
  }

  static List<WikipediaImage> listFromJson(Map<String, Object?> json) {
    final List<WikipediaImage> images = <WikipediaImage>[];
    if (json case {'query': {'pages': final Map<String, Object?> pages}}) {
      for (final MapEntry<String, Object?>(:Object? value) in pages.entries) {
        images.add(WikipediaImage.fromJson(value! as Map<String, Object?>));
      }
    }
    return images;
  }
}
