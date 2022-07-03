import 'package:powerpoint_pro/helpers/api_client.dart';

class AuthService {
  bool loading = false;
  ApiClient api = ApiClient();
  login(Map<String, dynamic> body) async {
    loading = true;
    var response = await api.post("/login", body);
  }
}
