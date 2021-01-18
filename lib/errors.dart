part of network_flutter;

class RequestEmptyError extends Error {}

class RequestNotFoundError extends Error {}

class RequestNetworkError extends Error {}

class RequestResponseError extends Error {
  RequestResponseError(this.message, this.statusCode);
  final String message;
  final int statusCode;
}
