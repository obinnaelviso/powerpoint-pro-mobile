import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:powerpoint_pro/helpers/api_status.dart';
import 'package:powerpoint_pro/models/user.dart';
import 'package:powerpoint_pro/view_models/base_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel extends BaseViewModel {
  User? _user;
  User? get user => _user;

  String _currentEmail = "";
  String get currentEmail => _currentEmail;

  Future<void> login(Map<String, dynamic> credentials) async {
    setLoading(true);
    setMessage("");
    setErrors({});
    credentials["device_name"] = await _getDeviceInfo();
    var response = await api.post("/login", credentials);
    if (response is Success) {
      setFailure(false);
      setSuccess(true);
      if (response.data != null) {
        setUser(response.data!["user"] as Map<String, dynamic>);
        setToken(response.data!["token"]);
      }
    }
    if (response is Failure) {
      setFailure(true);
      setSuccess(false);
      setErrors(response.data);
    }
    setLoading(false);
    setMessage(response.message ?? "");
  }

  Future<void> logout() async {
    setLoading(true);
    setMessage("");
    setErrors({});
    var response = await api.post("/logout", {});
    if (response is Success) {
      setToken("");
      _setRole("");
      setSuccess(true);
      setFailure(false);
    }
    if (response is Failure) {
      setErrors(response.data);
      setSuccess(false);
      setFailure(true);
    }
    setLoading(false);
    setMessage(response.message ?? "");
  }

  Future<void> sendOtp(Map<String, dynamic> credentials) async {
    setLoading(true);
    setMessage("");
    setErrors({});
    var response = await api.post("/otp/email", credentials);
    if (response is Success) {
      setSuccess(true);
      setFailure(false);
      _setCurrentEmail(credentials["email"]);
    }
    if (response is Failure) {
      setSuccess(false);
      setFailure(true);
      setErrors(response.data);
    }
    setLoading(false);
    setMessage(response.message ?? "");
  }

  Future<void> verifyOtp(Map<String, dynamic> credentials) async {
    setLoading(true);
    setMessage("");
    setErrors({});
    var response = await api.post("/verify/email", credentials);
    if (response is Success) {
      setSuccess(true);
      setFailure(false);
    }
    if (response is Failure) {
      setSuccess(false);
      setFailure(true);
      setErrors(response.data);
    }
    setLoading(false);
    setMessage(response.message ?? "");
  }

  Future<void> changePassword(Map<String, dynamic> credentials) async {
    setLoading(true);
    setMessage("");
    setErrors({});
    var response = await api.post("/reset-password", credentials);
    if (response is Success) {
      setSuccess(true);
      setFailure(false);
    }
    if (response is Failure) {
      setSuccess(false);
      setFailure(true);
      setErrors(response.data);
    }
    setLoading(false);
    setMessage(response.message ?? "");
  }

  Future<void> register(Map<String, dynamic> credentials) async {
    setLoading(true);
    setMessage("");
    setErrors({});
    var response = await api.post("/register", credentials);
    if (response is Success) {
      login({
        "email": credentials["email"],
        "password": credentials["password"],
      });
    }
    if (response is Failure) {
      setErrors(response.data);
    }
    setLoading(false);
    setMessage(response.message ?? "");
  }

  void setUser(Map<String, dynamic> userJson) {
    _user = User.fromMap(userJson);
    _setRole(_user!.role!);
    notifyListeners();
  }

  void _setRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("role", role);
  }

  void _setCurrentEmail(String email) {
    _currentEmail = email;
    notifyListeners();
  }

  Future<String?> _getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.brand.toString().toUpperCase() +
          " " +
          androidInfo.model.toString();
    }
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.model;
    }
    return null;
  }
}
