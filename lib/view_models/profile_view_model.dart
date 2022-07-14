import 'package:powerpoint_pro/helpers/api_status.dart';
import 'package:powerpoint_pro/models/user.dart';
import 'package:powerpoint_pro/view_models/base_view_model.dart';

class ProfileViewModel extends BaseViewModel {
  User? _user;
  User? get user => _user;

  Future<void> me() async {
    setLoading(true);
    setMessage("");
    setErrors({});
    var response = await api.get("/me");
    if (response is Success) {
      if (response.data != null) {
        setUser(response.data as Map<String, dynamic>);
      }
    }
    if (response is Failure) {
      setErrors(response.data);
    }
    setLoading(false);
    setMessage(response.message ?? "");
  }

  void setUser(Map<String, dynamic> userJson) {
    _user = User.fromMap(userJson);
    notifyListeners();
  }
}
