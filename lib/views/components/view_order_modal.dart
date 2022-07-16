import 'package:flutter/material.dart';
import 'package:powerpoint_pro/helpers/constants.dart';
import 'package:powerpoint_pro/models/request_form.dart';
import 'package:powerpoint_pro/views/components/title_text.dart';

class ViewOrderModal extends StatelessWidget {
  final RequestForm requestForm;

  const ViewOrderModal(this.requestForm, {Key? key}) : super(key: key);

  // Future<void> downloadFile(String path, String name) async {
  //   final appStorage = await getApplicationDocumentsDirectory();
  //   final file = File('${appStorage.path}/$name');
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          TitleText("${requestForm.user.name}'s Order"),
          const SizedBox(height: 10),
          Text(
            requestForm.amountString,
            style: const TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold, fontSize: 26.0),
          ),
          const SizedBox(height: 20.0),
          Expanded(
            child: ListView(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: ListTile(
                          title: const Text(
                            "Name",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            requestForm.name,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        child: ListTile(
                          title: const Text(
                            "Category",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            requestForm.category,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: ListTile(
                          title: const Text(
                            "Sub-Category",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            requestForm.subCategory ?? "N/A",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        child: ListTile(
                          title: const Text(
                            "Topic",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            requestForm.topic,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: ListTile(
                          title: const Text(
                            "Number of Slides",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            requestForm.slides,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        child: ListTile(
                          title: const Text(
                            "Duration (Days) ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            requestForm.duration,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: ListTile(
                          title: const Text(
                            "Payment Receipt",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: (requestForm.receiptUrl == "")
                              ? const Text(
                                  "N/A",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    // await downloadFile(requestForm.receiptUrl);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.download),
                                      Text('Download'),
                                    ],
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 0),
                                  )),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        child: ListTile(
                          title: const Text(
                            "Date ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            dateTimeFormat.format(requestForm.createdAt),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
