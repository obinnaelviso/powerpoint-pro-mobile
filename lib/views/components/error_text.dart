import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  const ErrorText({
    Key? key,
    required this.error,
  }) : super(key: key);

  final dynamic error;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: (error != null),
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Text(
          (error != null) ? error[0] : "",
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
