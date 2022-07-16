import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:powerpoint_pro/helpers/constants.dart';
import 'package:powerpoint_pro/models/request_form.dart';
import 'package:powerpoint_pro/view_models/bank_accounts_view_model.dart';
import 'package:powerpoint_pro/view_models/request_form_view_model.dart';
import 'package:powerpoint_pro/views/components/empty_screen.dart';
import 'package:powerpoint_pro/views/components/payment_modal.dart';
import 'package:powerpoint_pro/views/components/status_label.dart';
import 'package:powerpoint_pro/views/components/view_order_modal.dart';
import 'package:provider/provider.dart';

class UserFormsPanel extends StatefulWidget {
  const UserFormsPanel({Key? key}) : super(key: key);
  static const String title = "PPT Service Forms";

  @override
  State<UserFormsPanel> createState() => _UserFormsPanelState();
}

class _UserFormsPanelState extends State<UserFormsPanel> {
  dynamic requestForms = [];

  void setRequestForms(BuildContext context) async {
    await context.read<RequestFormViewModel>().getAll();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      setRequestForms(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    requestForms = Provider.of<RequestFormViewModel>(context).requestForms;
    int selectedListItem = 1;

    Widget displayPaymentButton(bool isLoading, int currentIndex) {
      if (isLoading && (currentIndex == selectedListItem)) {
        return const CircularProgressIndicator();
      } else {
        return ElevatedButton(
          child: const Text('Pay'),
          onPressed: () async {
            selectedListItem = currentIndex;
            await Provider.of<BankAccountsViewModel>(context, listen: false)
                .getAll();
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => SingleChildScrollView(
                  child: PaymentModal(
                requestForms[currentIndex].id,
                amount: requestForms[currentIndex].amountString,
              )),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
            );
          },
        );
      }
    }

    if (requestForms.isEmpty) {
      return ModalProgressHUD(
          inAsyncCall: Provider.of<RequestFormViewModel>(context).loading,
          child: const EmptyScreen("You have not made any new requests"));
    } else {
      return ModalProgressHUD(
        inAsyncCall: Provider.of<RequestFormViewModel>(context).loading,
        child: RefreshIndicator(
          onRefresh: () =>
              context.read<RequestFormViewModel>().getAll(isUser: true),
          child: ListView.builder(
            itemCount: requestForms.length,
            itemBuilder: (context, index) {
              final RequestForm requestForm = requestForms[index];
              final String topic = requestForm.name;
              final slidesCount = requestForm.slides;
              final duration = requestForm.duration;
              final String date = dateTimeFormat.format(requestForm.createdAt);
              final String status = requestForm.status.title;
              return Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: ListTile(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => ViewOrderModal(requestForm),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                      );
                    },
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
                        ? displayPaymentButton(
                            Provider.of<BankAccountsViewModel>(context).loading,
                            index)
                        : null,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
  }
}
