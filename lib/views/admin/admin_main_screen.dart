import 'package:flutter/material.dart';
import 'package:powerpoint_pro/helpers/constants.dart';
import 'package:powerpoint_pro/view_models/auth_view_model.dart';
import 'package:powerpoint_pro/view_models/profile_view_model.dart';
import 'package:powerpoint_pro/views/auth/login_screen.dart';
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
    });
  }

  @override
  Widget build(BuildContext context) {
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
        actions: [
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
          )
        ],
      ),
      body: kAdminPanels[_selectedIndex]["panel"],
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.lightBlue.shade300),
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
            ListTile(
                selectedColor: Colors.red,
                selected: _selectedIndex == 0,
                leading: const Icon(Icons.dashboard),
                title: const Text('Dashboard'),
                onTap: () {
                  gotoPanel(context, 0);
                }),
            ListTile(
                leading: const Icon(Icons.article),
                selected: _selectedIndex == 1,
                title: const Text('Orders'),
                onTap: () {
                  gotoPanel(context, 1);
                }),
            ListTile(
                leading: const Icon(Icons.list),
                title: const Text('Packages'),
                onTap: () {
                  setState(() {});
                }),
            ListTile(
              leading: const Icon(Icons.account_tree),
              title: const Text('Categories'),
              onTap: () {
                setState(() {});
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance),
              title: const Text('Bank Account'),
              onTap: () {
                setState(() {});
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
