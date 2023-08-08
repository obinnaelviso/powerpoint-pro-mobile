import 'package:flutter/material.dart';
import 'package:project_ppt_pro/helpers/constants.dart';

class OrderDetails extends StatelessWidget {
  const OrderDetails({
    Key? key,
    required this.title,
    this.description,
  }) : super(key: key);

  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: kFS16),
        ),
        Text(
          description ?? "",
          style: const TextStyle(fontSize: kFS18),
        ),
      ],
    );
  }
}
