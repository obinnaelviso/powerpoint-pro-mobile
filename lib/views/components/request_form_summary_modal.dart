import 'package:flutter/material.dart';
import 'package:powerpoint_pro/models/package.dart';
import 'package:powerpoint_pro/view_models/request_form_view_model.dart';
import 'package:powerpoint_pro/views/components/title_text.dart';
import 'package:powerpoint_pro/views/user/user_main_screen.dart';
import 'package:provider/provider.dart';

class RequestFormSummaryModal extends StatelessWidget {
  final Map<String, dynamic> credentials;

  final Category package;
  const RequestFormSummaryModal({
    Key? key,
    required this.credentials,
    required this.package,
  }) : super(key: key);

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
          const TitleText("Below is the cost of your order:"),
          const SizedBox(height: 20),
          Text(
            package.amountString!,
            style: const TextStyle(
                color: Colors.red, fontSize: 28.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Visibility(
            visible: Provider.of<RequestFormViewModel>(context).loading,
            child: const CircularProgressIndicator(),
          ),
          Visibility(
            visible: !Provider.of<RequestFormViewModel>(context).loading,
            child: ElevatedButton(
              onPressed: () async {
                await context.read<RequestFormViewModel>().create(credentials);
                if (context.read<RequestFormViewModel>().failure) {
                  Navigator.pop(context);
                } else if (context.read<RequestFormViewModel>().success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content:
                          Text(context.read<RequestFormViewModel>().message!),
                    ),
                  );
                  Navigator.pushReplacementNamed(context, UserMainScreen.route);
                }
              },
              child: const Text(
                "Continue",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
