import 'package:flutter/material.dart';
import 'package:project_ppt_pro/helpers/constants.dart';
import 'package:project_ppt_pro/view_models/auth_view_model.dart';
import 'package:project_ppt_pro/view_models/request_form_view_model.dart';
import 'package:project_ppt_pro/views/auth/login_screen.dart';
import 'package:project_ppt_pro/views/user/user_create_form_screen.dart';
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

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      _updatePositionList(
        _PositionItemType.log,
        _kLocationServicesDisabledMessage,
      );

      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        _updatePositionList(
          _PositionItemType.log,
          _kPermissionDeniedMessage,
        );

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      _updatePositionList(
        _PositionItemType.log,
        _kPermissionDeniedForeverMessage,
      );

      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    _updatePositionList(
      _PositionItemType.log,
      _kPermissionGrantedMessage,
    );
    return true;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadRequestFormsData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("${kUserPanels[_selectedIndex]["title"]}"),
          leadingWidth: 75.0,
          leading: const Padding(
            padding: EdgeInsets.all(5.0),
            child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Image(image: AssetImage("assets/images/logo64.png"))),
          ),
          actions: [
            PopupMenuButton<int>(
                onSelected: (int item) async {
                  if (item == 4) {
                    await showDialog<String>(
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
                                    await context
                                        .read<AuthViewModel>()
                                        .logout();
                                    if (context.read<AuthViewModel>().success) {
                                      Navigator.popUntil(
                                          context, (route) => route.isFirst);
                                      Navigator.pushReplacementNamed(
                                          context, LoginScreen.route);
                                    }
                                  },
                                  child: Provider.of<AuthViewModel>(context)
                                          .loading
                                      ? const SizedBox(
                                          child: CircularProgressIndicator(),
                                          height: 20,
                                          width: 20,
                                        )
                                      : const Text("Yes"),
                                )
                              ],
                            ));
                  } else {
                    setState(() {
                      _selectedIndex = item;
                    });
                  }
                },
                itemBuilder: (context) => <PopupMenuEntry<int>>[
                      PopupMenuItem(
                          child: Text("${kUserPanels[0]["title"]}"), value: 0),
                      PopupMenuItem(
                          child: Text("${kUserPanels[1]["title"]}"), value: 1),
                      PopupMenuItem(
                          child: Text("${kUserPanels[2]["title"]}"), value: 2),
                      const PopupMenuItem(child: Text("Logout"), value: 4),
                    ])
          ]),
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
    );
  }
}
