import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:powerpoint_pro/helpers/constants.dart';
import 'package:powerpoint_pro/models/bank_account.dart';
import 'package:powerpoint_pro/view_models/bank_accounts_view_model.dart';
import 'package:powerpoint_pro/views/components/alert_snack.dart';
import 'package:powerpoint_pro/views/components/bottom_form_modal.dart';
import 'package:powerpoint_pro/views/components/confirm_box.dart';
import 'package:powerpoint_pro/views/components/empty_screen.dart';
import 'package:powerpoint_pro/views/components/form_input.dart';
import 'package:provider/provider.dart';

class AdminBankAccountsPanel extends StatefulWidget {
  const AdminBankAccountsPanel({Key? key}) : super(key: key);
  static const String title = "Bank Accounts";

  @override
  State<AdminBankAccountsPanel> createState() => _AdminBankAccountsPanelState();
}

class _AdminBankAccountsPanelState extends State<AdminBankAccountsPanel> {
  dynamic _bankAccounts = [];

  List<PopupMenuEntry<FormOptions>> getMenuItems(BuildContext context) {
    List<PopupMenuEntry<FormOptions>> menuItems = [];
    menuItems.addAll([
      const PopupMenuItem<FormOptions>(
        value: FormOptions.edit,
        child: Text("Edit"),
      ),
      const PopupMenuItem<FormOptions>(
        value: FormOptions.delete,
        child: Text("Delete"),
      ),
    ]);
    return menuItems;
  }

  void setBankAccounts() async {
    await context.read<BankAccountsViewModel>().getAll();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      setBankAccounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    _bankAccounts = Provider.of<BankAccountsViewModel>(context).bankAccounts;

    if (_bankAccounts.isEmpty) {
      return ModalProgressHUD(
          inAsyncCall: Provider.of<BankAccountsViewModel>(context).loading,
          child: const EmptyScreen("There are no bank accounts"));
    } else {
      return ModalProgressHUD(
        inAsyncCall: Provider.of<BankAccountsViewModel>(context).loading,
        child: RefreshIndicator(
          onRefresh: () => context.read<BankAccountsViewModel>().getAll(),
          child: ListView.builder(
            itemCount: _bankAccounts.length,
            itemBuilder: (lvContext, index) {
              final BankAccount _bankAccount = _bankAccounts[index];
              final String? _bankName = _bankAccount.bankName;
              final String? _accountName = _bankAccount.accountName;
              final String? _accountNumber = _bankAccount.accountNumber;
              final _bankNameController = TextEditingController();
              final _accountNameController = TextEditingController();
              final _accountNumberController = TextEditingController();
              return Card(
                child: ListTile(
                  title: Text(_bankName ?? ""),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_accountName ?? ""),
                      Text(_accountNumber ?? ""),
                    ],
                  ),
                  trailing: PopupMenuButton<FormOptions>(
                    onSelected: (FormOptions item) async {
                      final bankAccountsVm =
                          context.read<BankAccountsViewModel>();
                      if (item == FormOptions.edit) {
                        _bankNameController.text = _bankName ?? "";
                        _accountNameController.text = _accountName ?? "";
                        _accountNumberController.text = _accountNumber ?? "";
                        await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => SingleChildScrollView(
                            child: BottomFormModal(
                              loading:
                                  Provider.of<BankAccountsViewModel>(context)
                                      .loading,
                              action: () async {
                                await bankAccountsVm.update(
                                  _bankAccount.id,
                                  {
                                    "bank_name": _bankNameController.text,
                                    "account_name": _accountNameController.text,
                                    "account_number":
                                        _accountNumberController.text,
                                  },
                                );
                                AlertSnack.showAlert(context,
                                    text: bankAccountsVm.message!,
                                    type: bankAccountsVm.success
                                        ? AlertSnackTypes.success
                                        : AlertSnackTypes.error);
                                Navigator.pop(context);
                              },
                              actionText: "Update",
                              children: [
                                FormInput(
                                  label: "Bank Name",
                                  autofocus: true,
                                  required: true,
                                  controller: _bankNameController,
                                ),
                                const SizedBox(height: 20.0),
                                FormInput(
                                  label: "Account Name",
                                  autofocus: true,
                                  required: true,
                                  controller: _accountNameController,
                                ),
                                const SizedBox(height: 20.0),
                                FormInput(
                                  label: "Account Number",
                                  autofocus: true,
                                  required: true,
                                  controller: _accountNumberController,
                                ),
                              ],
                            ),
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                        );
                      } else if (item == FormOptions.delete) {
                        await ConfirmBox.displayDialog(
                          context,
                          title: "Confirm Delete",
                          message: "Are you sure you want to delete this form?",
                          confirmAction: () async {
                            context
                                .read<BankAccountsViewModel>()
                                .delete(_bankAccount.id)
                                .then((value) => AlertSnack.showAlert(context,
                                    text: bankAccountsVm.message!,
                                    type: bankAccountsVm.success
                                        ? AlertSnackTypes.success
                                        : AlertSnackTypes.error));
                            Navigator.pop(context);
                          },
                        );
                      }
                    },
                    itemBuilder: (context) => getMenuItems(context),
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
