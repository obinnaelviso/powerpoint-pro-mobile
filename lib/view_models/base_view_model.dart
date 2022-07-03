import 'package:flutter/material.dart';
import 'package:powerpoint_pro/helpers/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/api_client.dart';

class BaseViewModel with ChangeNotifier {
  ApiClient api = ApiClient();
  bool _loading = false;
  bool get loading => _loading;
  String? _message;
  String? get message => _message;
  Map<String, dynamic> _errors = {};
  Map<String, dynamic> get errors => _errors;

  void setLoading(bool loading) {
    _loading = loading;
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
