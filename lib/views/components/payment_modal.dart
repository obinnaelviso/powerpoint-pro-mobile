import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:powerpoint_pro/view_models/request_form_view_model.dart';
import 'package:powerpoint_pro/views/components/title_text.dart';
import 'package:provider/provider.dart';

class PaymentModal extends StatefulWidget {
  final int id;

  const PaymentModal(this.id, {Key? key}) : super(key: key);

  @override
  State<PaymentModal> createState() => _PaymentModalState();
}

class _PaymentModalState extends State<PaymentModal> {
  String selectedFilePath = "";
  File? selectedFile;
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
                selectedFile = File(result.files.single.path!);
                setState(() {
                  selectedFilePath = basename(selectedFile!.path);
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
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.attach_file_outlined)
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
                    child: const Text("Cancel"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black38,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Visibility(
                      visible:
                          Provider.of<RequestFormViewModel>(context).loading,
                      child: const CircularProgressIndicator()),
                  Visibility(
                    visible:
                        !Provider.of<RequestFormViewModel>(context).loading,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (selectedFile != null) {
                          await context
                              .read<RequestFormViewModel>()
                              .uploadReceipt(widget.id, selectedFile!);
                          if (context.read<RequestFormViewModel>().success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(
                                  context.read<RequestFormViewModel>().message!,
                                ),
                              ),
                            );
                            Navigator.pop(context);
                          } else if (context
                              .read<RequestFormViewModel>()
                              .failure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                  context.read<RequestFormViewModel>().message!,
                                ),
                              ),
                            );
                          }
                        }
                      },
                      child: Row(
                        children: const [
                          Text("Upload"),
                          Icon(Icons.cloud_upload)
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10)
            ],
          )
        ],
      ),
    );
  }
}
