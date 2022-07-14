import 'package:flutter/material.dart';
import 'package:powerpoint_pro/views/admin/panels/admin_forms_panel.dart';
import 'package:powerpoint_pro/views/admin/panels/admin_home_panel.dart';
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
    "panel": const UserHomePanel(),
  },
  {
    "title": UserFormsPanel.title,
    "panel": const UserFormsPanel(),
  },
  {"title": UserPackagesPanel.title, "panel": const UserPackagesPanel()}
];

const List<Map<String, dynamic>> kAdminPanels = <Map<String, dynamic>>[
  {
    "title": AdminHomePanel.title,
    "panel": AdminHomePanel(),
  },
  {
    "title": AdminFormsPanel.title,
    "panel": AdminFormsPanel(),
  },
  {"title": UserPackagesPanel.title, "panel": UserPackagesPanel()}
];

enum FormOptions { delete, approve, reject, cancel, complete, revert }

const kAppTitle = "Powerpoint Pro";
const double kFS16 = 16.0;
