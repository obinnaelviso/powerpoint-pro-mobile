import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:powerpoint_pro/helpers/api_status.dart';

class ApiClient {
  String baseUrl = "http://192.168.95.194/api";

  final Map<String, String> _headers = {
    HttpHeaders.acceptHeader: "application/json",
  };

  void setBaseUrl(String url) {
    baseUrl = url;
  }

  Future<dynamic> get(String path) async => await _makeRequest(
      () async => await http.get(getRoute(path), headers: _headers));

  Future<dynamic> post(String path, Map<String, dynamic> body) async =>
      await _makeRequest(() async =>
          await http.post(getRoute(path), body: body, headers: _headers));

  Future<dynamic> put(String path, Map<String, dynamic> body) async =>
      await _makeRequest(() async =>
          await http.put(getRoute(path), body: body, headers: _headers));

  Future<dynamic> delete(String path, Map<String, dynamic> body) async =>
      await _makeRequest(() async =>
          await http.delete(getRoute(path), body: body, headers: _headers));

  Future<dynamic> _makeRequest(Future<dynamic> Function() serverRequest) async {
    try {
      var response = await serverRequest();
      int statusCode = response.statusCode;
      Map<String, dynamic> data = jsonDecode(response.body);
      switch (statusCode) {
        case 200:
          {
            return Success(data['message'], data['data']);
          }
        case 422:
          {
            return Failure(data['message'], data['errors']);
          }
        default:
          {
            return Failure(data['message'], data['errors']);
          }
      }
    } on HttpException {
      return Failure("No internet access. Please connect to the internet", {});
    } on FormatException {
      return Failure("Invalid JSON", {});
    } catch (e) {
      print(e);
      return Failure("Unknown error", {});
    }
  }

  void setToken(String token) {
    _headers[HttpHeaders.authorizationHeader] = "Bearer $token";
  }

  Uri getRoute(String path) {
    return Uri.parse(baseUrl + path);
  }
}
