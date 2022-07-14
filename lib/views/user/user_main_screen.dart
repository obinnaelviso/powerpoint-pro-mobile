import 'package:flutter/material.dart';
import 'package:powerpoint_pro/helpers/constants.dart';
import 'package:powerpoint_pro/view_models/auth_view_model.dart';
import 'package:powerpoint_pro/view_models/request_form_view_model.dart';
import 'package:powerpoint_pro/views/auth/login_screen.dart';
import 'package:powerpoint_pro/views/user/user_create_form_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserMainScreen extends StatefulWidget {
  const UserMainScreen({Key? key}) : super(key: key);
  static const String route = "/user/home";

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  int _selectedIndex = 0;
  List<dynamic> _requestForms = [];

  void loadRequestFormsData(BuildContext context) async {
    if (_requestForms.isEmpty) {
      await context.read<RequestFormViewModel>().getAll();
      _requestForms = context.read<RequestFormViewModel>().requestForms;
      if (context.read<RequestFormViewModel>().failure) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("token", "");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      loadRequestFormsData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${kUserPanels[_selectedIndex]["title"]}"),
        leading: const Padding(
          padding: EdgeInsets.all(5.0),
          child: Image(image: AssetImage("assets/images/logo64.png")),
        ),
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
      body: kUserPanels[_selectedIndex]["panel"],
      floatingActionButton: FloatingActionButton(
        tooltip: "Make a Request",
        child: const Icon(
          Icons.add,
        ),
        onPressed: () {
          Navigator.pushNamed(context, UserCreateFormScreen.route);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          if (index < kUserPanels.length) {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Forms",
          ),
        ],
      ),
    );
  }
}
