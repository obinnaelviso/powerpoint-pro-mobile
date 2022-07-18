import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:powerpoint_pro/models/request_form.dart';
import 'package:powerpoint_pro/view_models/request_form_view_model.dart';
import 'package:powerpoint_pro/views/components/empty_screen.dart';
import 'package:provider/provider.dart';

class AdminTransactionHistoryScreen extends StatefulWidget {
  const AdminTransactionHistoryScreen({Key? key}) : super(key: key);

  static const route = "/admin/transaction-history";

  @override
  State<AdminTransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState
    extends State<AdminTransactionHistoryScreen> {
  List<dynamic> _requestForms = [];

  void loadOrders(BuildContext context) async {
    await context.read<RequestFormViewModel>().getAll(isUser: false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      loadOrders(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    _requestForms = Provider.of<RequestFormViewModel>(context).requestForms;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction History"),
      ),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
          inAsyncCall: Provider.of<RequestFormViewModel>(context).loading,
          child: _requestForms.isEmpty
              ? const EmptyScreen("There are no orders available.")
              : Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(
                            label: Text('User',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          DataColumn(
                            label: Text('Request ID',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          DataColumn(
                            label: Text('Amount',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          DataColumn(
                            label: Text('Status',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                        rows: _requestForms.map((requestForm) {
                          requestForm as RequestForm;
                          return DataRow(cells: [
                            DataCell(Text(requestForm.user.name)),
                            DataCell(Text(requestForm.requestNo ?? "")),
                            DataCell(Text(requestForm.amountString)),
                            DataCell(Text(requestForm.status.title)),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                )),
    );
  }
}
