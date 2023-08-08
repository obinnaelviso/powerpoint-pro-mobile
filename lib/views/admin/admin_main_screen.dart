import 'package:flutter/material.dart';
import 'package:project_ppt_pro/helpers/constants.dart';
import 'package:project_ppt_pro/view_models/admin_app_bar_view_model.dart';
import 'package:project_ppt_pro/view_models/auth_view_model.dart';
import 'package:project_ppt_pro/view_models/bank_accounts_view_model.dart';
import 'package:project_ppt_pro/view_models/categories_view_model.dart';
import 'package:project_ppt_pro/view_models/profile_view_model.dart';
import 'package:project_ppt_pro/views/admin/admin_transaction_history_screen.dart';
import 'package:project_ppt_pro/views/auth/login_screen.dart';
import 'package:project_ppt_pro/views/components/alert_snack.dart';
import 'package:project_ppt_pro/views/components/bottom_form_modal.dart';
import 'package:project_ppt_pro/views/components/error_text.dart';
import 'package:project_ppt_pro/views/components/form_input.dart';
import 'package:provider/provider.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({Key? key}) : super(key: key);
  static const String route = "/admin/home";

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _selectedIndex = 0;
  String _name = "";
  final categoryTitleController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _accountNameController = TextEditingController();
  final _accountNumberController = TextEditingController();

  void setAppBarActions(BuildContext context, {List<Widget>? appbarActions}) {
    List<Widget> actions = [];

    if (appbarActions != null) {
      actions.addAll(appbarActions);
    }

    actions.add(
      IconButton(
        onPressed: () => showDialog<String>(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text("Confirm Logout"),
                  content: const Text(
                      "Are you sure you want to log out of this application?"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("No")),
                    TextButton(
                      onPressed: () async {
                        await context.read<AuthViewModel>().logout();
                        if (context.read<AuthViewModel>().success) {
                          Navigator.popUntil(context, (route) => route.isFirst);
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.route);
                        }
                      },
                      child: Provider.of<AuthViewModel>(context).loading
                          ? const SizedBox(
                              child: CircularProgressIndicator(),
                              height: 20,
                              width: 20,
                            )
                          : const Text("Yes"),
                    )
                  ],
                )),
        icon: const Icon(Icons.logout),
        tooltip: "Logout",
      ),
    );
    context.read<AdminAppBarViewModel>().set(actions);
  }

  void loadProfile(BuildContext context) async {
    final profileVm = context.read<ProfileViewModel>();
    await profileVm.me();
    setState(() {
      _name = profileVm.user!.firstName;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      loadProfile(context);
      setAppBarActions(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget addCategoryAction = IconButton(
      onPressed: () async {
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => SingleChildScrollView(
            child: BottomFormModal(
              loading: Provider.of<CategoriesViewModel>(context).loading,
              action: () async {
                await context
                    .read<CategoriesViewModel>()
                    .create({"title": categoryTitleController.text});
                AlertSnack.showAlert(context,
                    text: context.read<CategoriesViewModel>().message!,
                    type: context.read<CategoriesViewModel>().success
                        ? AlertSnackTypes.success
                        : AlertSnackTypes.error);
                Navigator.pop(context);
              },
              children: [
                FormInput(
                  label: "Category Title",
                  autofocus: true,
                  required: true,
                  controller: categoryTitleController,
                ),
                ErrorText(
                  error:
                      Provider.of<CategoriesViewModel>(context).errors["title"],
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
      },
      icon: const Icon(Icons.add_circle_outline),
      tooltip: "Add new Category",
    );
    final Widget transactionHistoryAction = IconButton(
      onPressed: () {
        Navigator.pushNamed(context, AdminTransactionHistoryScreen.route);
      },
      icon: const Icon(Icons.description),
      tooltip: "Transaction History",
    );
    final Widget addBankAccountAction = IconButton(
      onPressed: () async {
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => SingleChildScrollView(
            child: BottomFormModal(
              loading: Provider.of<BankAccountsViewModel>(context).loading,
              action: () async {
                await context.read<BankAccountsViewModel>().create(
                  {
                    "bank_name": _bankNameController.text,
                    "account_name": _accountNameController.text,
                    "account_number": _accountNumberController.text,
                  },
                );
                AlertSnack.showAlert(context,
                    text: context.read<BankAccountsViewModel>().message!,
                    type: context.read<BankAccountsViewModel>().success
                        ? AlertSnackTypes.success
                        : AlertSnackTypes.error);
                Navigator.pop(context);
              },
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
      },
      icon: const Icon(Icons.add_circle_outline),
      tooltip: "Add new Category",
    );

    void gotoPanel(BuildContext context, int index) {
      setState(() {
        _selectedIndex = index;
        Navigator.pop(context);
      });
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("${kAdminPanels[_selectedIndex]["title"]}"),
        actions: Provider.of<AdminAppBarViewModel>(context).actions,
      ),
      body: kAdminPanels[_selectedIndex]["panel"],
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.white70),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Welcome $_name",
                    style: const TextStyle(fontSize: 22),
                  ),
                ],
              ),
            ),
            //Dashboard
            ListTile(
                selectedColor: Colors.red,
                selected: _selectedIndex == 0,
                leading: const Icon(Icons.dashboard),
                title: Text(kAdminPanels[0]["title"]),
                onTap: () {
                  gotoPanel(context, 0);
                  setAppBarActions(context);
                }),
            // Orders
            ListTile(
                leading: const Icon(Icons.article),
                selected: _selectedIndex == 1,
                title: Text(kAdminPanels[1]["title"]),
                onTap: () {
                  gotoPanel(context, 1);
                  setAppBarActions(context,
                      appbarActions: [transactionHistoryAction]);
                }),
            // Packages
            ListTile(
                leading: const Icon(Icons.list),
                title: Text(kAdminPanels[2]["title"]),
                selected: _selectedIndex == 2,
                onTap: () {
                  gotoPanel(context, 2);
                  setAppBarActions(context);
                }),
            // Categories
            ListTile(
              leading: const Icon(Icons.account_tree),
              title: Text(kAdminPanels[3]["title"]),
              selected: _selectedIndex == 3,
              onTap: () {
                gotoPanel(context, 3);
                setAppBarActions(context, appbarActions: [addCategoryAction]);
              },
            ),
            // Bank Accounts
            ListTile(
              leading: const Icon(Icons.account_balance),
              title: Text(kAdminPanels[4]["title"]),
              selected: _selectedIndex == 4,
              onTap: () {
                gotoPanel(context, 4);
                setAppBarActions(context,
                    appbarActions: [addBankAccountAction]);
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.settings),
            //   title: const Text('Settings'),
            //   onTap: () {
            //     setState(() {});
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
