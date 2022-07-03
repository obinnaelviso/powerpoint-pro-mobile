import 'package:flutter/material.dart';
import 'package:powerpoint_pro/views/user/panels/user_forms_panel.dart';
import 'package:powerpoint_pro/views/user/panels/user_home_panel.dart';
import 'package:powerpoint_pro/views/user/panels/user_packages_panel.dart';

final kTextButtonStyle = TextButton.styleFrom(
  textStyle: const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  ),
  minimumSize: const Size(20, 20),
  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
);
final List<Map<String, dynamic>> kUserPanels = <Map<String, dynamic>>[
  {
    "title": UserHomePanel.title,
    "panel": UserHomePanel(),
  },
  {
    "title": UserFormsPanel.title,
    "panel": const UserFormsPanel(),
  },
  {"title": UserPackagesPanel.title, "panel": const UserPackagesPanel()}
];

const kAppTitle = "Powerpoint Pro";
const double kFS16 = 16.0;
