import 'package:flutter/material.dart';
import 'package:project_ppt_pro/helpers/api_client.dart';
import 'package:project_ppt_pro/helpers/constants.dart';
import 'package:project_ppt_pro/views/admin/admin_main_screen.dart';
import 'package:project_ppt_pro/views/auth/login_screen.dart';
import 'package:project_ppt_pro/views/user/user_main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const route = "/splash";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void setToken() async {
    await Future.delayed(const Duration(
      milliseconds: 3000,
    )).whenComplete(() async {
      String? token;
      String? role;
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString("token");
      role = prefs.getString("role");
      if ((token != null) && (token != "")) {
        ApiClient().setToken(token);
        if (role == "admin") {
          Navigator.pushReplacementNamed(context, AdminMainScreen.route);
        } else {
          Navigator.pushReplacementNamed(context, UserMainScreen.route);
        }
      } else {
        Navigator.pushReplacementNamed(context, LoginScreen.route);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/logo64.png",
            width: 100,
            height: 100,
          ),
          const SizedBox(height: 20.0),
          Center(
              child: Text(
            kAppTitle.toUpperCase(),
            style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.black87,
                fontSize: kFS18),
          ))
        ],
      ),
    );
  }
}
