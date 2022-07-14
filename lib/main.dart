import 'package:flutter/material.dart';
import 'package:powerpoint_pro/view_models/auth_view_model.dart';
import 'package:powerpoint_pro/view_models/bank_account_view_model.dart';
import 'package:powerpoint_pro/view_models/categories_view_model.dart';
import 'package:powerpoint_pro/view_models/packages_view_model.dart';
import 'package:powerpoint_pro/view_models/profile_view_model.dart';
import 'package:powerpoint_pro/view_models/request_form_view_model.dart';
import 'package:powerpoint_pro/views/admin/admin_main_screen.dart';
import 'package:powerpoint_pro/views/auth/login_screen.dart';
import 'package:powerpoint_pro/views/auth/registration_screen.dart';
import 'package:powerpoint_pro/views/user/user_create_form_screen.dart';
import 'package:powerpoint_pro/views/user/user_main_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => RequestFormViewModel()),
        ChangeNotifierProvider(create: (context) => PackagesViewModel()),
        ChangeNotifierProvider(create: (context) => CategoriesViewModel()),
        ChangeNotifierProvider(create: (context) => BankAccountViewModel()),
        ChangeNotifierProvider(create: (context) => ProfileViewModel()),
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Powerpoint pro',
        theme: ThemeData(
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
        initialRoute: LoginScreen.route,
        routes: {
          LoginScreen.route: (context) => const LoginScreen(),
          RegistrationScreen.route: (context) => RegistrationScreen(),
          UserMainScreen.route: (context) => const UserMainScreen(),
          UserCreateFormScreen.route: (context) => const UserCreateFormScreen(),
          AdminMainScreen.route: (context) => const AdminMainScreen(),
        });
  }
}
