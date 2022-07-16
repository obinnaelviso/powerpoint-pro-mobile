import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:powerpoint_pro/helpers/constants.dart';
import 'package:powerpoint_pro/view_models/categories_view_model.dart';
import 'package:powerpoint_pro/view_models/packages_view_model.dart';
import 'package:powerpoint_pro/views/components/alert_snack.dart';
import 'package:powerpoint_pro/views/components/request_form_summary_modal.dart';
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
  final List<String> _packages = [
    "1 - 30",
    "31 - 50",
    "51 - 75",
    "76 - 100",
    "> 100"
  ];
  String _slides = "";

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

  @override
  void initState() {
    super.initState();
    _slides = _packages[0];
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      loadCategories(context);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                          child: (_packages.isEmpty)
                              ? const SizedBox(
                                  height: 5,
                                  width: 5,
                                  child: CircularProgressIndicator())
                              : DropdownButton<String>(
                                  isExpanded: true,
                                  value: _slides,
                                  items:
                                      _packages.map<DropdownMenuItem<String>>(
                                    (String slide) {
                                      return DropdownMenuItem<String>(
                                        value: slide,
                                        child: Text(slide),
                                      );
                                    },
                                  ).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _slides =
                                          (newValue == null) ? "" : newValue;
                                    });
                                  }),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: (_slides == "> 100"),
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
                            value: "1",
                            groupValue: _duration,
                            onChanged: (String? value) {
                              setState(() {
                                _duration = (value == null) ? "" : value;
                              });
                            },
                            title: const Text('Within 24 hours'),
                          ),
                          RadioListTile(
                            value: "2",
                            groupValue: _duration,
                            onChanged: (String? value) {
                              setState(() {
                                _duration = (value == null) ? "" : value;
                              });
                            },
                            title: const Text('Within 1-3 days'),
                          ),
                          RadioListTile(
                            value: "4",
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
                        final slidesValue = (_slides.split(" ")[0] == '>')
                            ? "101"
                            : _slides.split(" ")[0];
                        final packageVm = context.read<PackagesViewModel>();
                        var credentials = {
                          "name": nameController.text,
                          "category": _category,
                          "sub_category": subCategoryController.text,
                          "topic": topicController.text,
                          "slides": (specialReqController.text == "")
                              ? slidesValue
                              : specialReqController.text,
                          "duration": _duration,
                          "phone": phoneController.text,
                          "email": emailController.text,
                          "location": locationController.text
                        };
                        await packageVm.searchPackage(
                          duration: _duration,
                          slides: (slidesValue),
                        );
                        var package = packageVm.package;
                        if (package != null) {
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
                                      package: package,
                                      credentials: credentials),
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
