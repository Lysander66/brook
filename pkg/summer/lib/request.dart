import 'dart:convert';

import 'package:http/http.dart' as http;

import 'client.dart';

class Request {
  Client client;
  late String url;
  String method = '';
  Map<String, String> headers = {};
  Map<String, String> queryParam = {};
  Map<String, String> pathParams = {};
  Map<String, dynamic>? formData;
  Object? body;

  Request(this.client);

  @override
  String toString() {
    return 'Request{url: $url, method: $method, headers: $headers, queryParam: $queryParam, pathParams: $pathParams, formData: $formData, body: $body}';
  }

  Request setHeader(String header, String value) {
    headers[header] = value;
    return this;
  }

  Request setHeaders(Map<String, String> headers) {
    this.headers.forEach((key, value) => setHeader(key, value));
    return this;
  }

  Request setQueryParam(String param, String value) {
    queryParam[param] = value;
    return this;
  }

  Request setQueryParams(Map<String, String> params) {
    params.forEach((key, value) => setQueryParam(key, value));
    return this;
  }

  Request setPathParam(String param, String value) {
    pathParams[param] = value;
    return this;
  }

  Request setPathParams(Map<String, String> params) {
    params.forEach((key, value) => setPathParam(key, value));
    return this;
  }

  Request setBody(Map<String, dynamic> b) {
    body = jsonEncode(b);
    return this;
  }

  Future<Response> get(String url) async {
    this.url = url;
    return client.get(this);
  }

  Future<Response> post(String url) async {
    this.url = url;
    return client.post(this);
  }

  Future<Response> put(String url) async {
    this.url = url;
    return client.put(this);
  }

  Future<Response> delete(String url) async {
    this.url = url;
    return client.delete(this);
  }
}

class Response {
  Response(this.request);

  late Request request;
  http.Response? rawResponse;
  String body = '';
  int? size;
  Duration? receivedAt;
  Map<String, dynamic> data = {};
}
