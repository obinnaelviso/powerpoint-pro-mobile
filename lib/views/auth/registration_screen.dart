import 'package:flutter/material.dart';
import 'package:powerpoint_pro/helpers/constants.dart';
import 'package:powerpoint_pro/views/components/title_text.dart';

import '../components/form_input.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  static const route = "/register";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      TitleText('Create New Account'),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const FormInput(label: 'First Name'),
                  const SizedBox(height: 20),
                  const FormInput(label: 'Last Name'),
                  const SizedBox(height: 20),
                  const FormInput(
                    label: 'Phone Number',
                    type: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  const FormInput(
                    label: 'Email',
                    type: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  const FormInput(label: 'Password'),
                  const SizedBox(height: 20),
                  const FormInput(label: 'Confirm Password'),
                  const SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
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
                        onPressed: () {},
                        child: const Text(
                          'Sign In',
                        ),
                        style: kTextButtonStyle,
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
