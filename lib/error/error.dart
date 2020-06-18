class BaseGQLException implements Exception {
  final String message;

  BaseGQLException(this.message);

  String toString() => 'BaseGQLException: ${this.message}';
}
