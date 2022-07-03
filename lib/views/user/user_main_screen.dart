import 'package:flutter/material.dart';
import 'package:powerpoint_pro/helpers/constants.dart';

class UserMainScreen extends StatefulWidget {
  const UserMainScreen({Key? key}) : super(key: key);
  static const String route = "/user/home";

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
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
      ),
      body: kUserPanels[_selectedIndex]["panel"],
      floatingActionButton: FloatingActionButton(
        tooltip: "Make a Request",
        child: const Icon(
          Icons.add,
        ),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
          BottomNavigationBarItem(
            icon: Icon(Icons.account_tree),
            label: "Packages",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
        ],
      ),
    );
  }
}
