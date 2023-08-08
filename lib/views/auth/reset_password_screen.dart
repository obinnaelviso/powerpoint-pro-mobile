import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:project_ppt_pro/helpers/constants.dart';
import 'package:project_ppt_pro/view_models/auth_view_model.dart';
import 'package:project_ppt_pro/views/auth/login_screen.dart';
import 'package:project_ppt_pro/views/auth/panels/change_password_panel.dart';
import 'package:project_ppt_pro/views/auth/panels/email_otp_panel.dart';
import 'package:project_ppt_pro/views/auth/panels/reset_password_panel.dart';
import 'package:project_ppt_pro/views/components/title_text.dart';
import 'package:provider/provider.dart';

final GlobalKey<ScaffoldState> rpKey = GlobalKey<ScaffoldState>();

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  static const route = "/reset-password";

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  ResetPasswordSteps resetPasswordStep = ResetPasswordSteps.email;

  Widget currentPanel() {
    if (resetPasswordStep == ResetPasswordSteps.otp) {
      return EmailOtpPanel(onSuccess: () {
        setState(() {
          resetPasswordStep = ResetPasswordSteps.password;
        });
      });
    } else if (resetPasswordStep == ResetPasswordSteps.password) {
      return ChangePasswordPanel(onSuccess: () {
        Navigator.pushReplacementNamed(context, LoginScreen.route);
      });
    } else {
      return ResetPasswordPanel(onSuccess: () {
        setState(() {
          resetPasswordStep = ResetPasswordSteps.otp;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: rpKey,
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
                          width: 100,
                          image: AssetImage('assets/images/password.png'),
                        ),
                        SizedBox(height: 20),
                        TitleText('Reset Password'),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                  currentPanel(),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Go back to",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.route);
                        },
                        child: const Text(
                          'Login',
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
