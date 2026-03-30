class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic errorData;

  ApiException(this.message, {this.statusCode, this.errorData});

  @override
  String toString() => message;
}

