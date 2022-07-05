import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:powerpoint_pro/helpers/constants.dart';
import 'package:powerpoint_pro/view_models/auth_view_model.dart';
import 'package:powerpoint_pro/views/components/error_text.dart';
import 'package:powerpoint_pro/views/components/title_text.dart';
import 'package:powerpoint_pro/views/user/user_main_screen.dart';
import 'package:provider/provider.dart';

import '../components/form_input.dart';

class RegistrationScreen extends StatelessWidget {
  RegistrationScreen({Key? key}) : super(key: key);

  static const route = "/register";

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  final authVMProvider = Provider.of<AuthViewModel>;

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
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            TitleText('Create New Account'),
                          ],
                        ),
                        const SizedBox(height: 30),
                        FormInput(
                            label: 'First Name',
                            controller: firstNameController),
                        ErrorText(
                            error:
                                authVMProvider(context).errors["first_name"]),
                        const SizedBox(height: 20),
                        FormInput(
                            label: 'Last Name', controller: lastNameController),
                        ErrorText(
                            error: authVMProvider(context).errors["last_name"]),
                        const SizedBox(height: 20),
                        FormInput(
                          label: 'Phone Number',
                          type: TextInputType.phone,
                          controller: phoneController,
                        ),
                        ErrorText(
                            error: authVMProvider(context).errors["phone"]),
                        const SizedBox(height: 20),
                        FormInput(
                            label: 'Email',
                            type: TextInputType.emailAddress,
                            controller: emailController),
                        ErrorText(
                            error: authVMProvider(context).errors["email"]),
                        const SizedBox(height: 20),
                        FormInput(
                          label: 'Password',
                          controller: passwordController,
                          hideText: true,
                        ),
                        ErrorText(
                            error: authVMProvider(context).errors["password"]),
                        const SizedBox(height: 20),
                        FormInput(
                          label: 'Confirm Password',
                          controller: passwordConfirmController,
                          hideText: true,
                        ),
                        const SizedBox(height: 30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                await context.read<AuthViewModel>().register({
                                  "first_name": firstNameController.text,
                                  "last_name": lastNameController.text,
                                  "phone": phoneController.text,
                                  "email": emailController.text,
                                  "password": passwordController.text,
                                  "password_confirmation":
                                      passwordConfirmController.text
                                });
                                if (context
                                    .read<AuthViewModel>()
                                    .errors
                                    .isNotEmpty) {
                                  passwordController.clear();
                                  passwordConfirmController.clear();
                                } else {
                                  Navigator.pushReplacementNamed(
                                      context, UserMainScreen.route);
                                }
                              },
                              child: const Text('SIGN UP'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account?",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Sign In',
                              ),
                              style: kTextButtonStyle,
                            ),
                          ],
                        )
                      ],
                    ),
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
