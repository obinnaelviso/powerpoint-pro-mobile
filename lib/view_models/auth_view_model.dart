import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:powerpoint_pro/helpers/api_status.dart';
import 'package:powerpoint_pro/models/user.dart';
import 'package:powerpoint_pro/view_models/base_view_model.dart';

class AuthViewModel extends BaseViewModel {
  User? _user;
  User? get user => _user;

  Future<void> login(Map<String, dynamic> credentials) async {
    setLoading(true);
    setMessage("");
    setErrors({});
    credentials["device_name"] = await _getDeviceInfo();
    var response = await api.post("/login", credentials);
    if (response is Success) {
      if (response.data != null) {
        setUser(response.data!["user"] as Map<String, dynamic>);
        setToken(response.data!["token"]);
      }
    }
    if (response is Failure) {
      setErrors(response.data);
    }
    setLoading(false);
    setMessage(response.message ?? "");
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

  void setUser(Map<String, dynamic> userJson) {
    _user = User.fromMap(userJson);
    notifyListeners();
  }
}
