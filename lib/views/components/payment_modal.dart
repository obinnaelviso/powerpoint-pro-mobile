import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:powerpoint_pro/view_models/bank_accounts_view_model.dart';
import 'package:powerpoint_pro/view_models/request_form_view_model.dart';
import 'package:powerpoint_pro/views/components/alert_snack.dart';
import 'package:powerpoint_pro/views/components/title_text.dart';
import 'package:provider/provider.dart';

class PaymentModal extends StatefulWidget {
  final int id;
  final String amount;

  const PaymentModal(this.id, {Key? key, required this.amount})
      : super(key: key);

  @override
  State<PaymentModal> createState() => _PaymentModalState();
}

class _PaymentModalState extends State<PaymentModal> {
  String selectedFilePath = "";
  File? selectedFile;

  List<Widget> getBankAccounts(List<dynamic> bankAccounts) {
    if (bankAccounts.isNotEmpty) {
      return bankAccounts
          .map((bankAccount) => Column(
                children: [
                  Row(children: [
                    const Text("Account Number: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    Text("${bankAccount.accountNumber}",
                        style: const TextStyle(fontSize: 18)),
                  ]),
                  Row(children: [
                    const Text("Bank: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    Text("${bankAccount.bankName}",
                        style: const TextStyle(fontSize: 18)),
                  ]),
                  Row(children: [
                    const Text("Account Name: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    Text("${bankAccount.accountName}",
                        style: const TextStyle(fontSize: 18)),
                  ]),
                  Visibility(
                    visible: ((bankAccounts.indexOf(bankAccount)) !=
                        (bankAccounts.length - 1)),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Text("- OR -",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                ],
              ))
          .toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> bankAccounts =
        Provider.of<BankAccountsViewModel>(context).bankAccounts;
    return Container(
      padding: EdgeInsets.only(
        top: 30,
        right: 10,
        left: 30,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        children: [
          const TitleText("Make Payment"),
          const SizedBox(height: 20),
          Text(
              "You are to make the total amount of ${widget.amount} to the following account details",
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Column(children: getBankAccounts(bankAccounts)),
          const SizedBox(height: 20),
          const Text("Click button below to upload proof of payment"),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['jpg', 'png', 'webp', 'bmp', 'pdf'],
              );
              if (result != null) {
                selectedFile = File(result.files.single.path!);
                setState(() {
                  selectedFilePath = basename(selectedFile!.path);
                });
              }
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
          const SizedBox(height: 10),
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
                            AlertSnack.showAlert(context,
                                text: context
                                    .read<RequestFormViewModel>()
                                    .message!,
                                type: AlertSnackTypes.error);
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
