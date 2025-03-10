class HttpException implements Exception {
  /// A message describing the exception.
  final String? message;

  /// The HTTP status code
  final int? statusCode;

  HttpException(this.message, {this.statusCode});
}
