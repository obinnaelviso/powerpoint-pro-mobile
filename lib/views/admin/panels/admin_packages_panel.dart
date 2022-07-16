import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:powerpoint_pro/helpers/constants.dart';
import 'package:powerpoint_pro/models/package.dart';
import 'package:powerpoint_pro/view_models/packages_view_model.dart';
import 'package:powerpoint_pro/views/components/alert_snack.dart';
import 'package:powerpoint_pro/views/components/bottom_form_modal.dart';
import 'package:powerpoint_pro/views/components/empty_screen.dart';
import 'package:powerpoint_pro/views/components/form_input.dart';
import 'package:provider/provider.dart';

class AdminPackagesPanel extends StatefulWidget {
  const AdminPackagesPanel({Key? key}) : super(key: key);
  static const String title = "Packages";

  @override
  State<AdminPackagesPanel> createState() => _AdminPackagesPanelState();
}

class _AdminPackagesPanelState extends State<AdminPackagesPanel> {
  dynamic _packages = [];

  List<PopupMenuEntry<FormOptions>> getMenuItems(BuildContext context) {
    List<PopupMenuEntry<FormOptions>> menuItems = [];
    menuItems.addAll([
      const PopupMenuItem<FormOptions>(
        value: FormOptions.edit,
        child: Text("Edit"),
      ),
    ]);
    return menuItems;
  }

  void setPackages() async {
    await context.read<PackagesViewModel>().getAll();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      setPackages();
    });
  }

  @override
  Widget build(BuildContext context) {
    _packages = Provider.of<PackagesViewModel>(context).packages;

    if (_packages.isEmpty) {
      return ModalProgressHUD(
          inAsyncCall: Provider.of<PackagesViewModel>(context).loading,
          child: const EmptyScreen("There are no packages"));
    } else {
      return ModalProgressHUD(
        inAsyncCall: Provider.of<PackagesViewModel>(context).loading,
        child: RefreshIndicator(
          onRefresh: () => context.read<PackagesViewModel>().getAll(),
          child: ListView.builder(
            itemCount: _packages.length,
            itemBuilder: (lvContext, index) {
              final Package _package = _packages[index];
              final String? _title = _package.title;
              final String? _durationRange =
                  "${_package.minDuration} - ${_package.maxDuration}";
              final String? _slidesRange =
                  "${_package.minSlides} - ${_package.maxSlides}";
              final String? _amount = _package.amount;
              final String? _amountString = _package.amountString;
              final _amountController = TextEditingController();
              return Card(
                child: ListTile(
                  title: Row(children: [
                    Text(_title ?? ""),
                    const Text(" - "),
                    Text(
                      _amountString ?? "",
                      style: const TextStyle(color: Colors.red),
                    ),
                  ]),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Text("Slides: "),
                        Text(_slidesRange ?? "")
                      ]),
                      Row(children: [
                        const Text("Duration: "),
                        Text(_durationRange ?? "")
                      ]),
                    ],
                  ),
                  trailing: PopupMenuButton<FormOptions>(
                    onSelected: (FormOptions item) async {
                      final packagesVm = context.read<PackagesViewModel>();
                      if (item == FormOptions.edit) {
                        _amountController.text = _amount ?? "";
                        await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => SingleChildScrollView(
                            child: BottomFormModal(
                              loading: Provider.of<PackagesViewModel>(context)
                                  .loading,
                              action: () async {
                                await packagesVm.update(
                                  _package.id,
                                  {
                                    "amount": _amountController.text,
                                  },
                                );
                                AlertSnack.showAlert(context,
                                    text: packagesVm.message!,
                                    type: packagesVm.success
                                        ? AlertSnackTypes.success
                                        : AlertSnackTypes.error);
                                Navigator.pop(context);
                              },
                              actionText: "Update",
                              children: [
                                FormInput(
                                  label: "Amount",
                                  autofocus: true,
                                  required: true,
                                  controller: _amountController,
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
