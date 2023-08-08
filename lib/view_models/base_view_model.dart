import 'package:flutter/material.dart';
import 'package:project_ppt_pro/helpers/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseViewModel with ChangeNotifier {
  ApiClient api = ApiClient();
  bool _loading = false;
  bool get loading => _loading;
  bool _success = false;
  bool get success => _success;
  bool _failure = false;
  bool get failure => _failure;
  String? _message;
  String? get message => _message;
  Map<String, dynamic> _errors = {};
  Map<String, dynamic> get errors => _errors;

  void setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  void setSuccess(bool isSuccess) {
    _success = isSuccess;
    notifyListeners();
  }

  void setFailure(bool isFailure) {
    _failure = isFailure;
    notifyListeners();
  }

  void setMessage(String message) {
    _message = message;
    notifyListeners();
  }

  void setErrors(Map<String, dynamic> errors) {
    _errors = errors;
    notifyListeners();
  }

  void setToken(String token) async {
    api.setToken(token);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
  }
}
