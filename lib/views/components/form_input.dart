import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  const FormInput(
      {Key? key,
      this.label = '',
      this.controller,
      this.onInput,
      this.type,
      this.hideText = false,
      this.required = false})
      : super(key: key);
  final String label;
  final Function(String)? onInput;
  final TextInputType? type;
  final bool hideText;
  final bool required;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: hideText,
      keyboardType: type,
      cursorColor: Colors.black,
      controller: controller,
      decoration: InputDecoration(
        label: label.isEmpty
            ? null
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label),
                  SizedBox(width: required ? 5 : 0),
                  Text(required ? "*" : "",
                      style: const TextStyle(color: Colors.redAccent))
                ],
              ),
      ),
      onChanged: onInput,
    );
  }
}
