import 'package:flutter/material.dart';
import 'package:powerpoint_pro/views/components/empty_screen.dart';
import 'package:powerpoint_pro/views/components/payment_modal.dart';

import '../../components/status_label.dart';

class UserHomePanel extends StatelessWidget {
  UserHomePanel({Key? key}) : super(key: key);
  static const String title = "Home";
  final List<Map<String, dynamic>> requestForms = <Map<String, dynamic>>[
    {
      "name": "Frank Charles",
      "category": "Agriculture",
      "sub_category": null,
      "topic": "Mechanizing Rural Farms",
      "description": null,
      "duration": 2,
      "slides": 5,
      "phone": "+2348026978647",
      "email": "dreamor47@gmail.com",
      "location": null,
      "need": null,
      "amount": 2000,
      "amount_string": "₦2000",
      "receipt_url": "",
      "created_at": "2022-06-25 14:02:36",
      "status": {"id": 3, "title": "pending"},
      "user": {
        "id": 2,
        "first_name": "John",
        "last_name": "Doe",
        "email": "johndoe@powerpoint-pro.com",
        "phone_verified": null,
        "email_verified": null,
        "role": "user",
        "status": {"id": 1, "title": "active"}
      }
    },
    {
      "name": "Frank Charles",
      "category": "Agriculture",
      "sub_category": null,
      "topic": "Mechanizing Rural Farms",
      "description": null,
      "duration": 2,
      "slides": 5,
      "phone": "+2348026978647",
      "email": "dreamor47@gmail.com",
      "location": null,
      "need": null,
      "amount": 2000,
      "amount_string": "₦2000",
      "receipt_url": "",
      "created_at": "2022-06-25 14:02:36",
      "status": {"id": 3, "title": "pending"},
      "user": {
        "id": 2,
        "first_name": "John",
        "last_name": "Doe",
        "email": "johndoe@powerpoint-pro.com",
        "phone_verified": null,
        "email_verified": null,
        "role": "user",
        "status": {"id": 1, "title": "active"}
      }
    },
  ];

  @override
  Widget build(BuildContext context) {
    if (requestForms.isEmpty) {
      return const EmptyScreen("There is nothing to display");
    } else {
      return ListView.builder(
        itemCount: requestForms.length,
        itemBuilder: (context, index) {
          final Map<String, dynamic> requestForm = requestForms[index];
          final String topic = requestForm["topic"];
          final int slidesCount = requestForm["slides"];
          final int duration = requestForm["duration"];
          final String date = requestForm["created_at"];
          final String status = requestForm["status"]["title"];
          return Card(
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: ListTile(
                  leading: const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Icon(
                      Icons.pie_chart,
                      size: 40,
                      color: Colors.red,
                    ),
                  ),
                  title: Text(topic),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "No. of Slides: $slidesCount, Duration: $duration days"),
                      Text("Date: $date"),
                      const SizedBox(
                        height: 5,
                      ),
                      StatusLabel(status)
                    ],
                  ),
                  trailing: (status == "pending")
                      ? ElevatedButton(
                          child: const Text('Pay'),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => const SingleChildScrollView(
                                  child: PaymentModal()),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                            );
                          },
                        )
                      : null,
                ),
              ),
            ),
          );
        },
      );
    }
  }
}
