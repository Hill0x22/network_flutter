part of network_flutter;

class RequestErrorInterceptors extends InterceptorsWrapper {
  final Function noAuth;
  RequestErrorInterceptors(this.noAuth);

  @override
  void onError(
    DioError error,
    ErrorInterceptorHandler handler,
  ) async {
    var mError = error;
    if (error.error is SocketException || error.error is HandshakeException) {
      mError = RequestNetworkError();
    } else if (error.response == null || error.response.data == null) {
      mError = RequestEmptyError();
    } else if (error.response.statusCode == 503) {
      mError = RequestEmptyError();
    } else if (error.response.statusCode == 502) {
      mError = RequestEmptyError();
    } else if (error.response.statusCode == 404) {
      // When is 404 response.data is empty
      mError = RequestNotFoundError();
    } else if (error.response.statusCode == 401) {
      mError = DioError(error: null);
      noAuth();
    }

    if (mError.response != null &&
        mError.response.data != null &&
        mError.response.data['message'] != null) {
      mError.error = mError.response.data['message']?.toString();
    }

    handler.next(mError);
  }
}

class RequestParseInterceptors extends InterceptorsWrapper {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final authorization = options.extra['authorization']?.toString() ?? '';

    if (authorization.isNotEmpty) {
      options.headers.update(
        'Authorization',
        (_) => '$authorization',
        ifAbsent: () => '$authorization',
      );
    }

    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async {
    if (response.statusCode == 200) {
      response.data = response.data['result'] ?? response.data['data']  ?? '';
      handler.next(response);
      return;
    }
    handler.next(response);
    // throw Exception(response.data['message']);
  }
}
