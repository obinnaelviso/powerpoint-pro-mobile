import 'package:flutter/material.dart';
import 'package:powerpoint_pro/view_models/auth_view_model.dart';
import 'package:powerpoint_pro/views/auth/reset_password_screen.dart';
import 'package:powerpoint_pro/views/components/alert_snack.dart';
import 'package:powerpoint_pro/views/components/form_input.dart';
import 'package:provider/provider.dart';

class EmailOtpPanel extends StatelessWidget {
  EmailOtpPanel({Key? key, required this.onSuccess}) : super(key: key);

  final _otpTC = TextEditingController();
  final void Function() onSuccess;

  final authVMProvider = Provider.of<AuthViewModel>;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormInput(
          controller: _otpTC,
          label: 'OTP Code',
          type: TextInputType.number,
          hideText: true,
        ),
        const SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () async {
                final authVm = context.read<AuthViewModel>();
                await authVm.verifyOtp({
                  "email": authVm.currentEmail,
                  "otp": _otpTC.text,
                });
                if (authVm.success) {
                  AlertSnack.showAlert(rpKey.currentContext!,
                      text: authVm.message!);
                  onSuccess();
                } else {
                  AlertSnack.showAlert(rpKey.currentContext!,
                      text: authVm.message!, type: AlertSnackTypes.error);
                }
              },
              child: const Text('SUBMIT'),
            ),
          ],
        ),
      ],
    );
  }
}
