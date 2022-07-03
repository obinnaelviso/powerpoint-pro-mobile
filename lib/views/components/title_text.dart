import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  const TitleText(this.title, {Key? key}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w700,
        fontSize: 26.0,
      ),
    );
  }
}
