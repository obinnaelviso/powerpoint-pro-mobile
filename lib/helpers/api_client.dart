import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:project_ppt_pro/helpers/api_status.dart';

//Singleton class
class ApiClient {
  String baseUrl = "https://powerpoint-pro.unifieddiamond.com/api";
  static final ApiClient _apiClient = ApiClient._internal();

  final Map<String, String> _headers = {
    HttpHeaders.acceptHeader: "application/json",
  };

  factory ApiClient() {
    return _apiClient;
  }

  ApiClient._internal();

  void setBaseUrl(String url) {
    baseUrl = url;
  }

  Future<dynamic> get(String path) async => await _makeRequest(
      () async => await http.get(getRoute(path), headers: _headers));

  Future<dynamic> post(String path, Map<String, dynamic> body) async =>
      await _makeRequest(() async =>
          await http.post(getRoute(path), body: body, headers: _headers));

  Future<dynamic> put(String route, Map<String, dynamic> body) async =>
      await _makeRequest(() async =>
          await http.put(getRoute(route), body: body, headers: _headers));

  Future<dynamic> delete(String path) async => await _makeRequest(
      () async => await http.delete(getRoute(path), headers: _headers));

  Future<dynamic> multipart(String path, File file) async =>
      await _makeRequest(() async {
        var req = http.MultipartRequest("POST", getRoute(path));
        req.headers.addAll(_headers);
        req.files.add(await http.MultipartFile.fromPath("file", file.path));
        return await req.send();
      });

  Future<dynamic> _makeRequest(Future<dynamic> Function() serverRequest) async {
    try {
      var response = await serverRequest();
      int statusCode = response.statusCode;
      Map<String, dynamic> data = {};
      dynamic body;
      if (response is http.StreamedResponse) {
        body = await response.stream.bytesToString();
      } else {
        body = response.body;
      }
      data = jsonDecode(body);

      switch (statusCode) {
        case 200:
          {
            return Success(data['message'], data['data']);
          }
        case 422:
          {
            return Failure(data['message'], data['errors']);
          }
        case 401:
          {
            return Failure(data['message'], {});
          }
        case 404:
          {
            return Failure("Not found", {});
          }
        default:
          {
            return Failure(data['message'], {});
          }
      }
    } on HttpException {
      return Failure("No internet access. Please connect to the internet", {});
    } on FormatException {
      return Failure("Invalid JSON", {});
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return Failure("Unknown error", {});
    }
  }

  void setToken(String token) {
    _headers[HttpHeaders.authorizationHeader] = "Bearer $token";
  }

  Uri getRoute(String path, {bool rawUrl = false}) {
    return Uri.parse(rawUrl ? path : baseUrl + path);
  }
}
