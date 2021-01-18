part of network_flutter;

class RequestJSONTransformer extends DefaultTransformer {
  RequestJSONTransformer() : super(jsonDecodeCallback: _parseJson);

  @override
  Future transformResponse(RequestOptions options, ResponseBody response) {
    response.headers['content-type'] = ['application/json'];
    return super.transformResponse(options, response);
  }
}

// Must be top-level function
dynamic _parseAndDecode(String response) {
  return jsonDecode(response);
}

Future<dynamic> _parseJson(String text) {
  return compute(_parseAndDecode, text);
}
