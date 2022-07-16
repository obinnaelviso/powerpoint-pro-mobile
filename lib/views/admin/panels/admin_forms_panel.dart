import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:powerpoint_pro/helpers/constants.dart';
import 'package:powerpoint_pro/models/request_form.dart';
import 'package:powerpoint_pro/view_models/request_form_view_model.dart';
import 'package:powerpoint_pro/views/components/alert_snack.dart';
import 'package:powerpoint_pro/views/components/confirm_box.dart';
import 'package:powerpoint_pro/views/components/empty_screen.dart';
import 'package:powerpoint_pro/views/components/status_label.dart';
import 'package:powerpoint_pro/views/components/view_order_modal.dart';
import 'package:provider/provider.dart';

class AdminFormsPanel extends StatefulWidget {
  const AdminFormsPanel({Key? key}) : super(key: key);
  static const String title = "Orders";

  @override
  State<AdminFormsPanel> createState() => _AdminFormsPanelState();
}

class _AdminFormsPanelState extends State<AdminFormsPanel> {
  dynamic requestForms = [];

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

  void setRequestForms() async {
    await context.read<RequestFormViewModel>().getAll(isUser: false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      setRequestForms();
    });
  }

  @override
  Widget build(BuildContext context) {
    requestForms = Provider.of<RequestFormViewModel>(context).requestForms;

    if (requestForms.isEmpty) {
      return ModalProgressHUD(
          inAsyncCall: Provider.of<RequestFormViewModel>(context).loading,
          child: const EmptyScreen("There are no new orders"));
    } else {
      return ModalProgressHUD(
        inAsyncCall: Provider.of<RequestFormViewModel>(context).loading,
        child: ListView.builder(
          itemCount: requestForms.length,
          itemBuilder: (lvContext, index) {
            final RequestForm requestForm = requestForms[index];
            final String topic = requestForm.name;
            final slidesCount = requestForm.slides;
            final duration = requestForm.duration;
            final String date = requestForm.createdAt.toString();
            final String status = requestForm.status.title;
            return Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: ListTile(
                  // View Order
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
                  trailing: PopupMenuButton<FormOptions>(
                    onSelected: (FormOptions item) async {
                      final requestFormVm =
                          context.read<RequestFormViewModel>();
                      if (item == FormOptions.approve) {
                        await requestFormVm.approve(requestForm.id);
                      } else if (item == FormOptions.cancel) {
                        await requestFormVm.cancel(requestForm.id);
                      } else if (item == FormOptions.complete) {
                        await requestFormVm.complete(requestForm.id);
                      } else if (item == FormOptions.delete) {
                        return await ConfirmBox.displayDialog(
                          context,
                          title: "Confirm Delete",
                          message: "Are you sure you want to delete this form?",
                          confirmAction: () async {
                            await requestFormVm.delete(requestForm.id);
                            Navigator.pop(context);
                            AlertSnack.showAlert(context,
                                text: requestFormVm.message!);
                          },
                        );
                      } else if (item == FormOptions.revert) {
                        await requestFormVm.pending(requestForm.id);
                      }
                      AlertSnack.showAlert(context,
                          text: requestFormVm.message!,
                          type: requestFormVm.success
                              ? AlertSnackTypes.success
                              : AlertSnackTypes.error);
                    },
                    itemBuilder: (context) => getFormMenuItems(
                        context, requestForm.status.title, requestForm.id),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
