import 'package:flutter/material.dart';

class ConfirmBox {
  ConfirmBox._();

  static Future<void> displayDialog(BuildContext context,
      {bool loading = false,
      required String title,
      required String message,
      String confirmText = 'Yes',
      String cancelText = 'No',
      required Function() confirmAction}) async {
    await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(cancelText)),
                TextButton(
                  onPressed: confirmAction,
                  child: loading
                      ? const SizedBox(
                          child: CircularProgressIndicator(),
                          height: 20,
                          width: 20,
                        )
                      : Text(confirmText),
                )
              ],
            ));
  }
}
