import 'package:flutter/material.dart';
import 'package:project_ppt_pro/view_models/auth_view_model.dart';
import 'package:project_ppt_pro/views/auth/reset_password_screen.dart';
import 'package:project_ppt_pro/views/components/alert_snack.dart';
import 'package:project_ppt_pro/views/components/form_input.dart';
import 'package:provider/provider.dart';

class ResetPasswordPanel extends StatelessWidget {
  ResetPasswordPanel({Key? key, required this.onSuccess}) : super(key: key);

  final _emailTC = TextEditingController();
  final void Function() onSuccess;

  final authVMProvider = Provider.of<AuthViewModel>;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormInput(
          controller: _emailTC,
          label: 'Email',
          type: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () async {
                final authVm = context.read<AuthViewModel>();
                await authVm.sendOtp({
                  "email": _emailTC.text,
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
