import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'logger.dart';
import 'request.dart';

final logger = Logger();
typedef ResponseMiddleware = Map<String, dynamic> Function(http.Response);

class Client {
  http.Client httpClient = http.Client();
  String baseURL = '';
  Map<String, String>? headers;
  Duration? timeout;
  int? retryCount;
  String? proxyURL;
  ResponseMiddleware? afterResponse;

  Client(
      {this.baseURL = '',
      this.headers,
      this.timeout,
      this.retryCount,
      this.proxyURL,
      this.afterResponse});

  Client.withClient(this.httpClient,
      {this.baseURL = '',
      this.headers,
      this.timeout,
      this.retryCount,
      this.proxyURL,
      this.afterResponse});

  @override
  String toString() {
    return 'Client{baseURL: $baseURL, headers: $headers, timeout: $timeout, retryCount: $retryCount, proxyURL: $proxyURL}';
  }

  Request R() {
    return Request(this);
  }

  Request newRequest() {
    return R();
  }

  Future<Response> get(Request req) async {
    var resp = Response(req);
    var uri = parseRequestURL(this, req);
    if (uri == null) {
      return resp;
    }

    try {
      final response = await httpClient.get(uri, headers: req.headers);
      resp.rawResponse = response;
      resp.body = response.body;
      if (afterResponse != null) {
        resp.data = afterResponse!(response);
      } else {
        resp.data = jsonDecode(response.body);
      }
    } on SocketException {
      logger.e('No Internet connection 😑');
    } on HttpException {
      logger.e("Couldn't find the post 😱");
    } on FormatException {
      logger.w('Bad response format 👎');
    } finally {
      // httpClient.close();
    }
    return resp;
  }

  Future<Response> post(Request req) async {
    var resp = Response(req);
    var uri = parseRequestURL(this, req);
    if (uri == null) {
      return resp;
    }

    try {
      final response = await httpClient.post(
        Uri.parse(req.url),
        headers: req.headers,
        body: req.body,
      );
      resp.rawResponse = response;
      resp.body = response.body;
    } on Exception catch (err) {
      logger.e(err);
    }
    return resp;
  }

  Future<Response> put(Request req) async {
    var resp = Response(req);
    var uri = parseRequestURL(this, req);
    if (uri == null) {
      return resp;
    }

    try {
      final response = await httpClient.put(
        Uri.parse(req.url),
        headers: req.headers,
        body: req.body,
      );
      resp.rawResponse = response;
      resp.body = response.body;
    } on Exception catch (err) {
      logger.e(err);
    }
    return resp;
  }

  Future<Response> delete(Request req) async {
    var resp = Response(req);
    var uri = parseRequestURL(this, req);
    if (uri == null) {
      return resp;
    }

    try {
      final response = await httpClient.delete(
        Uri.parse(req.url),
        headers: req.headers,
        body: req.body,
      );
      resp.rawResponse = response;
      resp.body = response.body;
    } on Exception catch (err) {
      logger.e(err);
    }
    return resp;
  }

  static Uri? parseRequestURL(Client c, Request r) {
    if (r.pathParams.isNotEmpty) {
      r.pathParams.forEach((p, v) {
        r.url = r.url.replaceAll('{$p}', v); //todo escape
      });
    }
    r.url = c.baseURL + r.url; //todo slash
    var u = Uri.tryParse(r.url);
    if (u == null) {
      logger.e('FormatException: $r');
      return null;
    }
    switch (u.scheme) {
      case 'http':
        if (u.queryParameters.isNotEmpty) {
          r.queryParam = {...u.queryParameters, ...r.queryParam};
        }
        u = Uri.http(u.host, u.path, r.queryParam);
        break;
      case 'https':
        if (u.queryParameters.isNotEmpty) {
          r.queryParam = {...u.queryParameters, ...r.queryParam};
        }
        u = Uri.https(u.host, u.path, r.queryParam);
        break;
      default:
        logger.e('FormatException: $r');
        return null;
    }
    // merge
    if (c.headers != null) {
      r.headers = {...c.headers!, ...r.headers};
    }
    logger.d(r.headers);
    logger.d(u.toString());
    return u;
  }
}
