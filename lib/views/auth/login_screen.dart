import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:powerpoint_pro/helpers/constants.dart';
import 'package:powerpoint_pro/view_models/auth_view_model.dart';
import 'package:powerpoint_pro/views/auth/registration_screen.dart';
import 'package:powerpoint_pro/views/components/title_text.dart';
import 'package:powerpoint_pro/views/user/user_main_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/api_client.dart';
import '../components/error_text.dart';
import '../components/form_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const route = "/login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailTC = TextEditingController();

  final _passwordTC = TextEditingController();

  final authVMProvider = Provider.of<AuthViewModel>;
  String? token;

  void setToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    if (token != null) {
      ApiClient().setToken(token!);
      Navigator.pushReplacementNamed(context, UserMainScreen.route);
    }
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
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<AuthViewModel>(context).loading,
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 50.0, horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: const [
                            Image(
                              image:
                                  AssetImage('assets/images/waving-hand.png'),
                            ),
                            SizedBox(height: 20),
                            TitleText('Welcome'),
                            SizedBox(height: 30),
                          ],
                        ),
                      ),
                      FormInput(
                        controller: _emailTC,
                        label: 'Email',
                        type: TextInputType.emailAddress,
                      ),
                      ErrorText(error: authVMProvider(context).errors["email"]),
                      const SizedBox(height: 20),
                      FormInput(
                        controller: _passwordTC,
                        label: 'Password',
                        hideText: true,
                      ),
                      ErrorText(
                          error: authVMProvider(context).errors["password"]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Forgot Password',
                              style: TextStyle(color: Colors.grey),
                            ),
                            style: TextButton.styleFrom(
                              minimumSize: const Size(20, 20),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              await context.read<AuthViewModel>().login({
                                "email": _emailTC.text,
                                "password": _passwordTC.text
                              });

                              if (context
                                  .read<AuthViewModel>()
                                  .errors
                                  .isNotEmpty) {
                                _passwordTC.clear();
                              } else {
                                Navigator.pushReplacementNamed(
                                    context, UserMainScreen.route);
                              }
                            },
                            child: const Text('SIGN IN'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account ?",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, RegistrationScreen.route);
                            },
                            child: const Text(
                              'Sign Up',
                            ),
                            style: kTextButtonStyle,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
