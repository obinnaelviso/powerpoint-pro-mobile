import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:powerpoint_pro/views/components/title_text.dart';

class PaymentModal extends StatefulWidget {
  const PaymentModal({Key? key}) : super(key: key);

  @override
  State<PaymentModal> createState() => _PaymentModalState();
}

class _PaymentModalState extends State<PaymentModal> {
  String selectedFilePath = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 30,
        right: 10,
        left: 30,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        children: [
          const TitleText("Upload proof of Payment"),
          const SizedBox(height: 20),
          const Text("Click the button below to upload proof of payment"),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['jpg', 'png', 'pdf'],
              );
              if (result != null) {
                File file = File(result.files.single.path!);
                if (kDebugMode) {
                  print(file.path);
                }
                setState(() {
                  selectedFilePath = basename(file.path);
                });
              } else {}
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  (selectedFilePath != "")
                      ? "Change File..."
                      : "Select File...",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(Icons.attach_file_outlined)
              ],
            ),
            style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                primary: Colors.black87),
          ),
          Text(
            selectedFilePath,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 50),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black38,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Row(
                      children: [Text("Upload"), Icon(Icons.cloud_upload)],
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              )
            ],
          )
        ],
      ),
    );
  }
}
