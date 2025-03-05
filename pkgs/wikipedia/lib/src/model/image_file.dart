import '../util.dart';

/// Image path and size, but doesn't contain any Wikipedia descriptions.
///
/// For images with metadata, see [WikipediaImage]
class ImageFile {
  /// Returns a new [ImageFile] instance.
  ImageFile({required this.source, required this.width, required this.height});

  /// Original image URI
  String source;

  /// Original image width
  int width;

  /// Original image height
  int height;

  String get extension {
    final extension = getFileExtension(source);
    // by default, return a non-viable image extension
    return extension ?? 'err';
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'source': source,
      'width': width,
      'height': height,
    };
  }

  /// Returns a new [ImageFile] instance
  // ignore: prefer_constructors_over_static_methods
  static ImageFile fromJson(Map<String, Object?> json) {
    if (json case {
      'source': final String source,
      'height': final int height,
      'width': final int width,
    }) {
      return ImageFile(source: source, width: width, height: height);
    }
    throw FormatException('Could not deserialize OriginalImage, json=$json');
  }

  @override
  String toString() =>
      'OriginalImage[source_=$source, width=$width, height=$height]';
}
