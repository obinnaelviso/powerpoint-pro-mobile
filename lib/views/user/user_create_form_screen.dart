import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:project_ppt_pro/helpers/constants.dart';
import 'package:project_ppt_pro/models/package.dart';
import 'package:project_ppt_pro/view_models/categories_view_model.dart';
import 'package:project_ppt_pro/view_models/packages_view_model.dart';
import 'package:project_ppt_pro/views/components/alert_snack.dart';
import 'package:project_ppt_pro/views/components/request_form_summary_modal.dart';
import 'package:provider/provider.dart';

import '../components/form_input.dart';

class UserCreateFormScreen extends StatefulWidget {
  const UserCreateFormScreen({Key? key}) : super(key: key);

  static const route = "/user/form-create";

  @override
  State<UserCreateFormScreen> createState() => _UserCreateFormScreenState();
}

class _UserCreateFormScreenState extends State<UserCreateFormScreen> {
  String _duration = "1";
  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final subCategoryController = TextEditingController();
  final topicController = TextEditingController();
  final specialReqController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final locationController = TextEditingController();
  String _category = "";
  List<String> _categories = [];
  List<dynamic> _packages = [];
  Package? _currentPackage;

  void loadCategories(BuildContext context) async {
    await context.read<CategoriesViewModel>().getAll();
    setState(() {
      _categories = context
          .read<CategoriesViewModel>()
          .categories
          .map((category) => category.title as String)
          .toList();
      _category = _categories[0];
    });
  }

  String _getDurationText(String duration) {
    if (duration == "2") {
      return "1 - 2 days";
    } else {
      return "Beyond 3 days";
    }
  }

  String _getAmount(String amount, String duration) {
    if (duration == "2") {
      return (int.parse(amount) + 1000).toString();
    } else {
      return amount;
    }
  }

  void loadPackages(BuildContext context) async {
    await context.read<PackagesViewModel>().getAll();
    _currentPackage = context.read<PackagesViewModel>().packages[0];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadCategories(context);
      loadPackages(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    _packages = Provider.of<PackagesViewModel>(context).packages;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Make a Powerpoint Request"),
      ),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<PackagesViewModel>(context).loading,
        child: Column(
          children: [
            Expanded(
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowIndicator();
                  return true;
                },
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  children: [
                    FormInput(
                      label: "Name",
                      required: true,
                      controller: nameController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const Text("Categories: ",
                            style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButton<String>(
                              isExpanded: true,
                              value: _category,
                              items: _categories.map<DropdownMenuItem<String>>(
                                (String category) {
                                  return DropdownMenuItem<String>(
                                    value: category,
                                    child: Text(category),
                                  );
                                },
                              ).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _category = newValue!;
                                });
                              }),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FormInput(
                      label: "Sub-Category (Optional)",
                      controller: subCategoryController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FormInput(
                      label: "Topic",
                      required: true,
                      controller: topicController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text("Number of Slides: ",
                            style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButton<Package>(
                              isExpanded: true,
                              value: _currentPackage,
                              items: _packages.map<DropdownMenuItem<Package>>(
                                (package) {
                                  return DropdownMenuItem<Package>(
                                    value: package,
                                    child: Text(package.title),
                                  );
                                },
                              ).toList(),
                              onChanged: (Package? newValue) {
                                setState(() {
                                  _currentPackage = newValue;
                                });
                              }),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: (_currentPackage?.title == "Above 100"),
                      child: FormInput(
                        label: "Special Request",
                        type: TextInputType.number,
                        controller: specialReqController,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FormInput(
                      label: "Phone Number",
                      controller: phoneController,
                      type: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FormInput(
                      label: "Email",
                      controller: emailController,
                      type: TextInputType.emailAddress,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FormInput(
                      label: "Location",
                      controller: locationController,
                      type: TextInputType.streetAddress,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('How urgently do you need it',
                        style: TextStyle(fontSize: kFS16)),
                    const Text('(The more urgent the higher the price)',
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontStyle: FontStyle.italic)),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 2.0, color: Colors.black12)),
                      child: Column(
                        children: [
                          RadioListTile(
                            value: "2",
                            groupValue: _duration,
                            onChanged: (String? value) {
                              setState(() {
                                _duration = (value == null) ? "" : value;
                              });
                            },
                            title: const Text('Within 1-2 days'),
                          ),
                          RadioListTile(
                            value: "3",
                            groupValue: _duration,
                            onChanged: (String? value) {
                              setState(() {
                                _duration = (value == null) ? "" : value;
                              });
                            },
                            title: const Text('Beyond 3 days'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final amount =
                            _getAmount(_currentPackage?.amount, _duration);
                        final packageVm = context.read<PackagesViewModel>();
                        var credentials = {
                          "name": nameController.text,
                          "category": _category,
                          "sub_category": subCategoryController.text,
                          "topic": topicController.text,
                          "slides": _currentPackage?.title,
                          "duration": _getDurationText(_duration),
                          "phone": phoneController.text,
                          "email": emailController.text,
                          "location": locationController.text,
                          "amount": amount
                        };
                        if (_currentPackage != null) {
                          showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (context) {
                                return SingleChildScrollView(
                                  child: RequestFormSummaryModal(
                                      amount: amount, credentials: credentials),
                                );
                              });
                        }
                        if (packageVm.failure) {
                          AlertSnack.showAlert(context,
                              text: packageVm.message!,
                              type: AlertSnackTypes.error);
                        }
                      },
                      child: const Text("Submit"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
