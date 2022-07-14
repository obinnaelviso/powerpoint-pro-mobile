import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:powerpoint_pro/views/components/empty_screen.dart';

class AdminHomePanel extends StatefulWidget {
  const AdminHomePanel({Key? key}) : super(key: key);
  static const String title = "Dashboard";

  @override
  State<AdminHomePanel> createState() => _AdminHomePanelState();
}

class _AdminHomePanelState extends State<AdminHomePanel> {
  // dynamic requestForms = [];
  //
  // void setRequestForms(BuildContext context) async {
  //   await context.read<RequestFormViewModel>().getAll();
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      // setRequestForms(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // int selectedListItem = 1;
    // requestForms = Provider.of<RequestFormViewModel>(context).requestForms;
    return ModalProgressHUD(
        inAsyncCall: false,
        child: const EmptyScreen("There is nothing to display"));
  }
}
