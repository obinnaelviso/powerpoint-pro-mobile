import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_ppt_pro/views/admin/panels/admin_bank_accounts_panel.dart';
import 'package:project_ppt_pro/views/admin/panels/admin_categories_panel.dart';
import 'package:project_ppt_pro/views/admin/panels/admin_forms_panel.dart';
import 'package:project_ppt_pro/views/admin/panels/admin_home_panel.dart';
import 'package:project_ppt_pro/views/admin/panels/admin_packages_panel.dart';
import 'package:project_ppt_pro/views/user/panels/user_contact_panel.dart';
import 'package:project_ppt_pro/views/user/panels/user_forms_panel.dart';
import 'package:project_ppt_pro/views/user/panels/user_home_panel.dart';

final kTextButtonStyle = TextButton.styleFrom(
  textStyle: const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  ),
  minimumSize: const Size(10, 10),
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
  {
    "title": UserContactPanel.title,
    "panel": const UserContactPanel(),
  },
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
  {"title": AdminPackagesPanel.title, "panel": AdminPackagesPanel()},
  {"title": AdminCategoriesPanel.title, "panel": AdminCategoriesPanel()},
  {"title": AdminBankAccountsPanel.title, "panel": AdminBankAccountsPanel()}
];

enum FormOptions { delete, approve, reject, cancel, complete, revert, edit }

final DateFormat dateTimeFormat = DateFormat('dd/MM/yyyy hh:mm a');
final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

const kAppTitle = "Project PPT Pro";
const double kFS16 = 16.0;
const double kFS18 = 18.0;

const String kCurrency = "₦";

enum ResetPasswordSteps { email, otp, password }
