import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:powerpoint_pro/helpers/constants.dart';
import 'package:powerpoint_pro/models/request_form.dart';
import 'package:powerpoint_pro/view_models/request_form_view_model.dart';
import 'package:powerpoint_pro/views/components/alert_snack.dart';
import 'package:powerpoint_pro/views/components/confirm_box.dart';
import 'package:powerpoint_pro/views/components/order_details.dart';
import 'package:powerpoint_pro/views/components/status_label.dart';
import 'package:powerpoint_pro/views/components/title_text.dart';
import 'package:provider/provider.dart';

class AdminHomePanel extends StatefulWidget {
  const AdminHomePanel({Key? key}) : super(key: key);
  static const String title = "Dashboard";

  @override
  State<AdminHomePanel> createState() => _AdminHomePanelState();
}

class _AdminHomePanelState extends State<AdminHomePanel> {
  List<dynamic> requestForms = [];
  List<PopupMenuEntry<FormOptions>> getFormMenuItems(
      BuildContext context, String status, int requestFormId) {
    List<PopupMenuEntry<FormOptions>> menuItems = [];
    switch (status) {
      case "processing":
      case "pending":
        {
          menuItems.addAll([
            const PopupMenuItem<FormOptions>(
              value: FormOptions.approve,
              child: Text("Approve Payment"),
            ),
            const PopupMenuItem<FormOptions>(
              value: FormOptions.cancel,
              child: Text("Cancel Order"),
            ),
          ]);
        }
        break;
      case "active":
        {
          menuItems.addAll([
            const PopupMenuItem<FormOptions>(
              value: FormOptions.complete,
              child: Text("Mark as Completed"),
            ),
            const PopupMenuItem<FormOptions>(
              value: FormOptions.cancel,
              child: Text("Cancel Order"),
            ),
          ]);
        }
        break;
    }
    menuItems.addAll([
      const PopupMenuItem<FormOptions>(
        value: FormOptions.revert,
        child: Text("Revert"),
      ),
      const PopupMenuItem<FormOptions>(
        value: FormOptions.delete,
        child: Text("Delete"),
      ),
    ]);
    return menuItems;
  }

  void setRequestForms(BuildContext context) async {
    await context.read<RequestFormViewModel>().getAll(isUser: false);
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
    final totalOrders = requestForms.length;
    return ModalProgressHUD(
        inAsyncCall: Provider.of<RequestFormViewModel>(context).loading,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Total Orders: 16
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TitleText("Total Orders: "),
                  Text(
                    totalOrders.toString(),
                    style: const TextStyle(
                        color: Colors.red,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700),
                  )
                ],
              ),
              const Divider(height: 30.0),
              const TitleText("Last 5 Orders"),
              const SizedBox(height: 20),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => context
                      .read<RequestFormViewModel>()
                      .getAll(isUser: false),
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10.0),
                    itemBuilder: (context, index) {
                      RequestForm requestForm = requestForms[index];
                      return Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 10.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // User
                              ListTile(
                                title: Text(
                                  requestForm.user.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: kFS18),
                                ),
                                subtitle: Text(
                                  dateTimeFormat.format(requestForm.createdAt),
                                ),
                                trailing: PopupMenuButton<FormOptions>(
                                  onSelected: (FormOptions item) async {
                                    final requestFormVm =
                                        context.read<RequestFormViewModel>();
                                    if (item == FormOptions.approve) {
                                      await requestFormVm
                                          .approve(requestForm.id);
                                    } else if (item == FormOptions.cancel) {
                                      await requestFormVm
                                          .cancel(requestForm.id);
                                    } else if (item == FormOptions.complete) {
                                      await requestFormVm
                                          .complete(requestForm.id);
                                    } else if (item == FormOptions.delete) {
                                      return await ConfirmBox.displayDialog(
                                        context,
                                        title: "Confirm Delete",
                                        message:
                                            "Are you sure you want to delete this form?",
                                        confirmAction: () async {
                                          await requestFormVm
                                              .delete(requestForm.id);
                                          Navigator.pop(context);
                                          AlertSnack.showAlert(context,
                                              text: requestFormVm.message!);
                                        },
                                      );
                                    } else if (item == FormOptions.revert) {
                                      await requestFormVm
                                          .pending(requestForm.id);
                                    }
                                    AlertSnack.showAlert(context,
                                        text: requestFormVm.message!,
                                        type: requestFormVm.success
                                            ? AlertSnackTypes.success
                                            : AlertSnackTypes.error);
                                  },
                                  itemBuilder: (context) => getFormMenuItems(
                                      context,
                                      requestForm.status.title,
                                      requestForm.id),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text("Order Information",
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  )),
                              const Divider(height: 10.0),
                              OrderDetails(
                                  title: "Name: ",
                                  description: requestForm.name),
                              OrderDetails(
                                  title: "Category: ",
                                  description: requestForm.category),
                              OrderDetails(
                                  title: "Topic: ",
                                  description: requestForm.topic),
                              OrderDetails(
                                  title: "Duration (days): ",
                                  description: requestForm.duration),
                              OrderDetails(
                                  title: "No. of Slides: ",
                                  description: requestForm.slides),
                              OrderDetails(
                                  title: "Phone Number: ",
                                  description: requestForm.phone),
                              OrderDetails(
                                  title: "Email Address: ",
                                  description: requestForm.email),
                              const SizedBox(height: 10.0),
                              StatusLabel(requestForm.status.title)
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: requestForms.length,
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
