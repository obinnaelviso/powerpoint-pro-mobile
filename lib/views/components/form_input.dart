import 'package:flutter/material.dart';

class FormInput extends StatefulWidget {
  const FormInput(
      {Key? key,
      this.label = '',
      this.controller,
      this.autofocus = false,
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
  final bool autofocus;
  final TextEditingController? controller;

  @override
  State<FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  bool _isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: widget.autofocus,
      obscureText: (widget.hideText && _isPasswordHidden),
      keyboardType: widget.type,
      cursorColor: Colors.black,
      controller: widget.controller,
      decoration: InputDecoration(
        suffixIcon: widget.hideText
            ? IconButton(
                icon: Icon(_isPasswordHidden
                    ? Icons.visibility_off
                    : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _isPasswordHidden = !_isPasswordHidden;
                  });
                },
              )
            : null,
        label: widget.label.isEmpty
            ? null
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.label),
                  SizedBox(width: widget.required ? 5 : 0),
                  Text(widget.required ? "*" : "",
                      style: const TextStyle(color: Colors.redAccent))
                ],
              ),
      ),
      onChanged: widget.onInput,
    );
  }
}
