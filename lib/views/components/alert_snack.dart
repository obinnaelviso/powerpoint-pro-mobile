import 'package:flutter/material.dart';

enum AlertSnackTypes { success, error, warning, info }

class AlertSnack {
  const AlertSnack._();

  static ColorSwatch<int> _getAlertColor(AlertSnackTypes status) {
    if (status == AlertSnackTypes.success) {
      return Colors.green;
    } else if (status == AlertSnackTypes.warning) {
      return Colors.yellowAccent;
    } else if (status == AlertSnackTypes.info) {
      return Colors.lightBlueAccent;
    } else {
      return Colors.redAccent;
    }
  }

  static void showAlert(BuildContext context,
      {AlertSnackTypes type = AlertSnackTypes.success, required String text}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _getAlertColor(type),
        content: Text(
          text,
        ),
      ),
    );
  }
}
