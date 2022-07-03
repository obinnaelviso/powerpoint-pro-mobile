import 'package:flutter/material.dart';

class StatusLabel extends StatelessWidget {
  const StatusLabel(this.status, {Key? key}) : super(key: key);
  final String status;
  @override
  Widget build(BuildContext context) {
    switch (status) {
      case "pending":
        {
          return StatusBadge(
            "Awaiting Payment",
            backgroundColor: Colors.yellow.shade300,
            foregroundColor: Colors.yellow.shade900,
          );
        }
      case "active":
        {
          return StatusBadge(
            "Job in-progress",
            backgroundColor: Colors.blue.shade100,
            foregroundColor: Colors.blue.shade700,
          );
        }
      case "cancelled":
        {
          return StatusBadge(
            "Order cancelled",
            backgroundColor: Colors.grey.shade600,
            foregroundColor: Colors.white,
          );
        }
      case "completed":
        {
          return StatusBadge(
            "Completed",
            backgroundColor: Colors.green.shade100,
            foregroundColor: Colors.green.shade900,
          );
        }
      default:
        {
          return const Text('Invalid status');
        }
    }
  }
}

class StatusBadge extends StatelessWidget {
  const StatusBadge(this.text,
      {Key? key, required this.backgroundColor, required this.foregroundColor})
      : super(key: key);
  final String text;
  final Color backgroundColor;
  final Color foregroundColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(30)),
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              color: foregroundColor,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
