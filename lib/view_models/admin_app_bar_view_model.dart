import 'dart:collection';

import 'package:flutter/material.dart';

class AdminAppBarViewModel extends ChangeNotifier {
  List<Widget> _actions = [];
  UnmodifiableListView<Widget> get actions => UnmodifiableListView(_actions);

  void set(List<Widget> widgets) {
    _actions = widgets;
    notifyListeners();
  }
}
