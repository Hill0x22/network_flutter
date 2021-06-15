part of network_flutter;

class RequestEmptyError extends DioError {}

class RequestNotFoundError extends DioError {}

class RequestNetworkError extends DioError {}

class RequestResponseError extends DioError {
  RequestResponseError(this.message, this.statusCode);
  final String message;
  final int statusCode;
}
