import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen(this.caption,
      {Key? key,
      this.image = const Image(
        image: AssetImage('assets/images/checklist.png'),
        width: 100,
      )})
      : super(key: key);
  final String caption;
  final Image image;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: image),
              const SizedBox(height: 10.0),
              Text(
                caption,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            ],
          ),
        )
      ],
    );
  }
}
