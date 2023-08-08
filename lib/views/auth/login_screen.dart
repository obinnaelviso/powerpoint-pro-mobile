import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:project_ppt_pro/helpers/constants.dart';
import 'package:project_ppt_pro/view_models/auth_view_model.dart';
import 'package:project_ppt_pro/views/admin/admin_main_screen.dart';
import 'package:project_ppt_pro/views/auth/registration_screen.dart';
import 'package:project_ppt_pro/views/auth/reset_password_screen.dart';
import 'package:project_ppt_pro/views/components/title_text.dart';
import 'package:project_ppt_pro/views/user/user_main_screen.dart';
import 'package:provider/provider.dart';

import '../components/error_text.dart';
import '../components/form_input.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  static const route = "/login";

  final _emailTC = TextEditingController();

  final _passwordTC = TextEditingController();

  final authVMProvider = Provider.of<AuthViewModel>;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<AuthViewModel>(context).loading,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 30.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Column(
                      children: const [
                        Image(
                          image: AssetImage('assets/images/waving-hand.png'),
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
                  ErrorText(error: authVMProvider(context).errors["password"]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, ResetPasswordScreen.route);
                        },
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
                          final authVm = context.read<AuthViewModel>();
                          await authVm.login({
                            "email": _emailTC.text,
                            "password": _passwordTC.text
                          });

                          if (authVm.failure) {
                            _passwordTC.clear();
                          } else {
                            if (authVm.user!.isAdmin()) {
                              Navigator.pushReplacementNamed(
                                  context, AdminMainScreen.route);
                            } else {
                              Navigator.pushReplacementNamed(
                                  context, UserMainScreen.route);
                            }
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
          ),
        ),
      ),
    );
  }
}
