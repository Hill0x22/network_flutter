part of network_flutter;

class Request extends _Request {
  // Singleton instance
  factory Request() {
    return _instance;
  }
  Request._internal();
  static final Request _instance = Request._internal();
}

class _Request {
  _Request() {
// Internal Api request

    _internalDio = Dio(BaseOptions(
      connectTimeout: _timeoutSeconds,
      receiveTimeout: _timeoutSeconds,
      sendTimeout: _timeoutSeconds,
    ));
    _internalDio.transformer = RequestJSONTransformer();
    _internalDio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
    _internalDio.interceptors.add(RequestErrorInterceptors());
    _internalDio.interceptors.add(RequestParseInterceptors());
    (_internalDio.httpClientAdapter as DefaultHttpClientAdapter)
        .onHttpClientCreate = (client) {
      client.badCertificateCallback = (cert, host, port) => true;
    };

// External Api Requests

    _externalDio = Dio(BaseOptions(
      connectTimeout: _timeoutSeconds,
      receiveTimeout: _timeoutSeconds,
      sendTimeout: _timeoutSeconds,
    ));
    _externalDio.transformer = RequestJSONTransformer();
    _externalDio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
    _externalDio.interceptors.add(RequestErrorInterceptors());
    (_externalDio.httpClientAdapter as DefaultHttpClientAdapter)
        .onHttpClientCreate = (client) {
      client.badCertificateCallback = (cert, host, port) => true;
    };
  }

  static const _timeoutSeconds = 25000;
  static const _timeoutDuration = Duration(milliseconds: _timeoutSeconds);

  @protected
  Dio _internalDio;
  @protected
  Dio _externalDio;

  void setup(String baseUrl, {Map<String, String> headers}) {
    _internalDio.options.baseUrl = baseUrl;
    if (headers != null) {
      _internalDio.options.headers.addAll(headers);
    }
  }

  void setupProxy(String proxyUrl) {
    if (proxyUrl?.isNotEmpty == true) {
      final baseAdapter =
          _internalDio.httpClientAdapter as DefaultHttpClientAdapter;
      baseAdapter.onHttpClientCreate = (client) {
        client.findProxy = (_) {
          return 'PROXY $proxyUrl';
        };
        client.badCertificateCallback = (cert, host, port) => true;
      };
      final extAdapter =
          _externalDio.httpClientAdapter as DefaultHttpClientAdapter;
      extAdapter.onHttpClientCreate = (client) {
        client.findProxy = (_) {
          return 'PROXY $proxyUrl';
        };
        client.badCertificateCallback = (cert, host, port) => true;
      };
    }
  }

  void updateBaseUrl(String baseUrl) {
    if (baseUrl?.isNotEmpty == true) {
      _internalDio.options.baseUrl = baseUrl;
    }
  }

  void updateLanguage(String language) {
    _internalDio.options.headers.update('app-language', (value) => language);
  }

  void updateHeader(String name, String value) {
    _internalDio.options.headers.update(
      name,
      (_) => value,
      ifAbsent: () => value,
    );
  }

  RequestResponseError getResponseError(dynamic error) {
    if (error is DioError && error.error is RequestResponseError) {
      return error.error as RequestResponseError;
    }
    return RequestResponseError('', -1);
  }

  Options _processOptions({
    Options options,
    String method,
    String authorization,
  }) {
    final processOptions = options ?? Options();
    processOptions.extra = {
      ...processOptions.extra,
      'authorization': authorization,
    };
    processOptions.method = method ?? processOptions.method;
    return processOptions;
  }

  // **** Internal Api Request **** //

  Future<T> getValue<T>(
    String path, {
    Map<String, dynamic> params,
    Options options,
    bool useAuthToken,
    String authorization,
    CancelToken cancelToken,
  }) async {
    final request = _internalDio.get(
      path,
      queryParameters: params,
      options: _processOptions(
        options: options,
        authorization: authorization,
      ),
      cancelToken: cancelToken,
    );
    final response = await request.timeout(_timeoutDuration);
    return response.data as T;
  }

  Future<Map<String, dynamic>> getObject(
    String path, {
    Map<String, dynamic> params,
    Options options,
    String authorization,
    CancelToken cancelToken,
  }) async {
    final request = _internalDio.get(
      path,
      queryParameters: params,
      options: _processOptions(
        options: options,
        authorization: authorization,
      ),
      cancelToken: cancelToken,
    );
    final response = await request.timeout(_timeoutDuration);
    final data = response.data;
    if (data is Map) {
      return data.cast<String, dynamic>();
    }
    return {};
  }

  Future<List<T>> getListOfValues<T>(
    String path, {
    Map<String, dynamic> params,
    Options options,
    String authorization,
    CancelToken cancelToken,
  }) async {
    final request = _internalDio.get(
      path,
      queryParameters: params,
      options: _processOptions(
        options: options,
        authorization: authorization,
      ),
      cancelToken: cancelToken,
    );
    final response = await request.timeout(_timeoutDuration);
    final data = response.data;
    if (data is List) {
      return List.castFrom<dynamic, T>(data);
    }
    return <T>[];
  }

  Future<List<Map<String, dynamic>>> getListOfObjects(
    String path, {
    Map<String, dynamic> params,
    Options options,
    String authorization,
    CancelToken cancelToken,
  }) async {
    final request = _internalDio.get(
      path,
      queryParameters: params,
      options: _processOptions(
        options: options,
        authorization: authorization,
      ),
      cancelToken: cancelToken,
    );
    final response = await request.timeout(_timeoutDuration);
    final data = response.data;
    if (data is List) {
      return List<Map<String, dynamic>>.from(
        data.map(
          (e) => Map<String, dynamic>.from(e as Map<String, dynamic>),
        ),
      );
    } else {
      return List<Map<String, dynamic>>.from([data]);
    }
  }

  Future<T> post<T>(
    String path,
    Map<String, dynamic> data, {
    Map<String, dynamic> params,
    Options options,
    String authorization,
    CancelToken cancelToken,
  }) async {
    final request = _internalDio.post(
      path,
      data: data,
      queryParameters: params,
      options: _processOptions(
        options: options,
        authorization: authorization,
      ),
      cancelToken: cancelToken,
    );
    final response = await request.timeout(_timeoutDuration);
    return response.data as T;
  }

  Future<T> put<T>(
    String path,
    Map<String, dynamic> data, {
    Map<String, dynamic> params,
    Options options,
    String authorization,
    CancelToken cancelToken,
    Function(int, int) onSendProgress,
  }) async {
    final request = _internalDio.put(
      path,
      data: data,
      queryParameters: params,
      options: _processOptions(
        options: options,
        authorization: authorization,
      ),
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
    );
    final response = await request.timeout(_timeoutDuration);
    return response.data as T;
  }

  Future<T> patch<T>(
    String path,
    Map<String, dynamic> data, {
    Map<String, dynamic> params,
    Options options,
    String authorization,
    CancelToken cancelToken,
  }) async {
    final request = _internalDio.patch(
      path,
      data: data,
      queryParameters: params,
      options: _processOptions(
        options: options,
        authorization: authorization,
      ),
      cancelToken: cancelToken,
    );
    final response = await request.timeout(_timeoutDuration);
    return response.data as T;
  }

  Future<T> delete<T>(
    String path, {
    Map<String, dynamic> data,
    Map<String, dynamic> queryParameters,
    Options options,
    String authorization,
    CancelToken cancelToken,
  }) async {
    final request = _internalDio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: _processOptions(
        options: options,
        authorization: authorization,
      ),
      cancelToken: cancelToken,
    );
    final response = await request.timeout(_timeoutDuration);
    return response.data as T;
  }

  Future<Response> download(
    String urlPath,
    String savePath, {
    Function(int, int) onReceiveProgress,
    Map<String, dynamic> params,
    String lengthHeader = HttpHeaders.contentLengthHeader,
    dynamic data,
    Options options,
    CancelToken cancelToken,
  }) {
    return _internalDio.download(
      urlPath,
      savePath,
      onReceiveProgress: onReceiveProgress,
      queryParameters: params,
      cancelToken: cancelToken,
      lengthHeader: lengthHeader,
      data: data,
      options: _processOptions(
        options: options,
      ),
    );
  }

  // **** External Api Request **** //

  Future<T> getExternalObject<T>(
    String path, {
    @required String baseUrl,
    Map<String, dynamic> params,
    Map<String, String> headers,
    CancelToken cancelToken,
    T Function(Response<dynamic>) onResponse,
  }) async {
    final request = _externalDio.get(
      path,
      options: RequestOptions(
        headers: headers,
        baseUrl: baseUrl,
      ),
      queryParameters: params,
      cancelToken: cancelToken,
    );
    final response = await request.timeout(_timeoutDuration);
    final result = onResponse != null ? onResponse(response) : response.data;
    return result as T;
  }

  Future<List<Map<String, dynamic>>> getExternalListOfObjects(
    String path, {
    @required String baseUrl,
    Map<String, dynamic> params,
    Map<String, String> headers,
    CancelToken cancelToken,
    dynamic Function(Response<dynamic>) onResponse,
  }) async {
    final request = _externalDio.get(
      path,
      options: RequestOptions(
        headers: headers,
        baseUrl: baseUrl,
      ),
      queryParameters: params,
      cancelToken: cancelToken,
    );
    final response = await request.timeout(_timeoutDuration);
    final result = onResponse != null ? onResponse(response) : response.data;
    if (result == null) {
      return [];
    } else if (result is List) {
      return List<Map<String, dynamic>>.from(
        result.map(
          (e) => Map<String, dynamic>.from(e as Map<String, dynamic>),
        ),
      );
    } else {
      return List<Map<String, dynamic>>.from([result]);
    }
  }

  Future<T> putExternal<T>(
    String path,
    FormData data, {
    @required String baseUrl,
    Map<String, dynamic> params,
    Map<String, String> headers,
    CancelToken cancelToken,
    Function(int, int) onSendProgress,
    dynamic Function(Response<dynamic>) onResponse,
  }) async {
    final request = _externalDio.put(
      path,
      data: data,
      options: RequestOptions(
        headers: headers,
        baseUrl: baseUrl,
      ),
      queryParameters: params,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
    );
    final response = await request.timeout(_timeoutDuration);
    final result = onResponse != null ? onResponse(response) : response.data;
    return result as T;
  }

  Future<T> postExternal<T>(
    String path, {
    @required String baseUrl,
    Map<String, dynamic> data,
    Map<String, dynamic> params,
    Map<String, String> headers,
    CancelToken cancelToken,
    dynamic Function(Response<dynamic>) onResponse,
  }) async {
    final request = _externalDio.post(
      path,
      data: data,
      queryParameters: params,
      options: RequestOptions(
        headers: headers,
        baseUrl: baseUrl,
      ),
      cancelToken: cancelToken,
    );
    final response = await request.timeout(_timeoutDuration);
    final result = onResponse != null ? onResponse(response) : response.data;
    return result as T;
  }
}
