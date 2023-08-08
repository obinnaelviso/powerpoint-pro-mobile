import 'package:flutter/material.dart';
import 'package:project_ppt_pro/view_models/auth_view_model.dart';
import 'package:project_ppt_pro/views/auth/reset_password_screen.dart';
import 'package:project_ppt_pro/views/components/alert_snack.dart';
import 'package:project_ppt_pro/views/components/form_input.dart';
import 'package:provider/provider.dart';

class ChangePasswordPanel extends StatelessWidget {
  ChangePasswordPanel({Key? key, required this.onSuccess}) : super(key: key);

  final void Function() onSuccess;
  final _newPassTC = TextEditingController();
  final _confirmNewPassTC = TextEditingController();

  final authVMProvider = Provider.of<AuthViewModel>;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormInput(
          controller: _newPassTC,
          label: 'New Password',
          hideText: true,
        ),
        const SizedBox(height: 20.0),
        FormInput(
          controller: _confirmNewPassTC,
          label: 'Confirm New Password',
          hideText: true,
        ),
        const SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () async {
                final authVm = context.read<AuthViewModel>();
                await authVm.changePassword({
                  "email": authVm.currentEmail,
                  "password": _newPassTC.text,
                  "password_confirmation": _confirmNewPassTC.text,
                });
                if (authVm.success) {
                  AlertSnack.showAlert(
                    rpKey.currentContext!,
                    text: authVm.message!,
                  );
                  onSuccess();
                } else {
                  AlertSnack.showAlert(
                    rpKey.currentContext!,
                    text: authVm.message!,
                    type: AlertSnackTypes.error,
                  );
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
