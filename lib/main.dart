import 'package:flutter/material.dart';
import 'package:powerpoint_pro/view_models/auth_view_model.dart';
import 'package:powerpoint_pro/views/auth/login_screen.dart';
import 'package:powerpoint_pro/views/auth/registration_screen.dart';
import 'package:powerpoint_pro/views/user/user_create_form_screen.dart';
import 'package:powerpoint_pro/views/user/user_main_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? token;

  void setToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
  }

  @override
  void initState() {
    super.initState();
    setToken();
  } // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Powerpoint pro',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.red,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(
                fontSize: 16,
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),
        initialRoute:
            (token == null) ? LoginScreen.route : UserMainScreen.route,
        routes: {
          LoginScreen.route: (context) => LoginScreen(),
          RegistrationScreen.route: (context) => RegistrationScreen(),
          UserMainScreen.route: (context) => UserMainScreen(),
          UserCreateFormScreen.route: (context) => UserCreateFormScreen(),
        });
  }
}
