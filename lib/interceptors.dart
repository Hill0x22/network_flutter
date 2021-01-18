part of network_flutter;

class RequestErrorInterceptors extends InterceptorsWrapper {
  @override
  Future<dynamic> onError(DioError error) async {
    if (error.error is SocketException || error.error is HandshakeException) {
      return RequestNetworkError();
    }
    if (error.response == null || error.response.data == null) {
      return RequestEmptyError();
    }
    if (error.response.statusCode == 503) {
      return RequestEmptyError();
    }
    if (error.response.statusCode == 502) {
      return RequestEmptyError();
    }
    // When is 404 response.data is empty
    if (error.response.statusCode == 404) {
      return RequestNotFoundError();
    }
    return RequestResponseError(
      error.response.data['message']?.toString() ?? error.message ?? 'unknown',
      error.response.statusCode ?? 500,
    );
  }
}

class RequestParseInterceptors extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) async {
    final authorization = options.extra['authorization']?.toString() ?? '';

    if (authorization.isNotEmpty) {
      options.headers.update(
        'authorization',
        (_) => 'Basic $authorization',
        ifAbsent: () => 'Basic $authorization',
      );
    }

    return options;
  }

  @override
  Future<dynamic> onResponse(Response<dynamic> response) async {
    if (response.statusCode == 200) {
      return response.data['result'];
    }
    throw Exception(response.data['message']);
  }
}


