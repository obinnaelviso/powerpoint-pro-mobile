import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:project_ppt_pro/helpers/constants.dart';
import 'package:project_ppt_pro/models/request_form.dart';
import 'package:project_ppt_pro/view_models/bank_accounts_view_model.dart';
import 'package:project_ppt_pro/view_models/profile_view_model.dart';
import 'package:project_ppt_pro/view_models/request_form_view_model.dart';
import 'package:project_ppt_pro/views/components/empty_screen.dart';
import 'package:project_ppt_pro/views/components/order_details.dart';
import 'package:project_ppt_pro/views/components/payment_modal.dart';
import 'package:project_ppt_pro/views/components/status_label.dart';
import 'package:project_ppt_pro/views/components/title_text.dart';
import 'package:provider/provider.dart';

class UserHomePanel extends StatefulWidget {
  const UserHomePanel({Key? key}) : super(key: key);
  static const String title = "Dashboard";

  @override
  State<UserHomePanel> createState() => _UserHomePanelState();
}

class _UserHomePanelState extends State<UserHomePanel> {
  List<dynamic> requestForms = [];
  String _name = "N/A";

  void setRequestForms(BuildContext context) async {
    await context.read<RequestFormViewModel>().getActive(isUser: true);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      setRequestForms(context);
      loadProfile(context);
    });
  }

  void loadProfile(BuildContext context) async {
    final profileVm = context.read<ProfileViewModel>();
    await profileVm.me();
    setState(() {
      _name = profileVm.user!.firstName;
    });
  }

  @override
  Widget build(BuildContext context) {
    int selectedListItem = 1;
    requestForms = Provider.of<RequestFormViewModel>(context).requestForms;

    Widget displayPaymentButton(bool isLoading, int currentIndex) {
      if (isLoading && (currentIndex == selectedListItem)) {
        return const CircularProgressIndicator();
      } else {
        return TextButton(
          child: const Text(
            'Make Payment',
            style: TextStyle(fontSize: kFS16),
          ),
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

    return ModalProgressHUD(
      inAsyncCall: Provider.of<RequestFormViewModel>(context).loading,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Text("Welcome ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: kFS18)),
                Text(_name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: kFS18,
                        color: Colors.redAccent)),
                const Text(" to your dashboard,",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: kFS18)),
              ],
            ),
            const Divider(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const TitleText("Active Orders"),
                Text(
                  requestForms.length.toString(),
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700),
                )
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
                child: requestForms.isEmpty
                    ? const EmptyScreen(
                        "You currently have no active orders. \n Click the '+' button to make an order")
                    : RefreshIndicator(
                        onRefresh: () => context
                            .read<RequestFormViewModel>()
                            .getActive(isUser: true),
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              RequestForm requestForm = requestForms[index];
                              return Card(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      OrderDetails(
                                          title: "Name: ",
                                          description: requestForm.name),
                                      const Divider(),
                                      OrderDetails(
                                          title: "Phone Number: ",
                                          description: requestForm.phone),
                                      OrderDetails(
                                          title: "Email Address: ",
                                          description: requestForm.email),
                                      OrderDetails(
                                          title: "Request No.: ",
                                          description: requestForm.requestNo),
                                      const SizedBox(height: 10.0),
                                      StatusLabel(requestForm.status.title),
                                    ],
                                  ),
                                  subtitle: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(dateTimeFormat
                                          .format(requestForm.createdAt)),
                                      Visibility(
                                        visible: (requestForm.status.title ==
                                            "pending"),
                                        child: displayPaymentButton(
                                            Provider.of<BankAccountsViewModel>(
                                                    context)
                                                .loading,
                                            index),
                                      )
                                    ],
                                  ),
                                ),
                              ));
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10.0),
                            itemCount: requestForms.length),
                      ))
          ],
        ),
      ),
    );
  }
}
