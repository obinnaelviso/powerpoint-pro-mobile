import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:powerpoint_pro/helpers/constants.dart';
import 'package:powerpoint_pro/view_models/categories_view_model.dart';
import 'package:powerpoint_pro/view_models/packages_view_model.dart';
import 'package:powerpoint_pro/views/components/request_form_summary_modal.dart';
import 'package:provider/provider.dart';

import '../components/form_input.dart';
import '../components/title_text.dart';

class UserCreateFormScreen extends StatefulWidget {
  const UserCreateFormScreen({Key? key}) : super(key: key);

  static const route = "/user/form-create";

  @override
  State<UserCreateFormScreen> createState() => _UserCreateFormScreenState();
}

class _UserCreateFormScreenState extends State<UserCreateFormScreen> {
  int _duration = 1;
  int _slides = 30;
  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final subCategoryController = TextEditingController();
  final topicController = TextEditingController();
  final specialReqController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final locationController = TextEditingController();
  String _category = "";
  List<String> categories = [];

  void setCategories(BuildContext context) async {
    await context.read<CategoriesViewModel>().getAll();
    setState(() {
      categories = context
          .read<CategoriesViewModel>()
          .categories
          .map((category) => category.title as String)
          .toList();
      _category = categories[0];
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      setCategories(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TitleText("Make a Powerpoint Request"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.red,
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
                              items: categories.map<DropdownMenuItem<String>>(
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
                          child: DropdownButton<int>(
                              isExpanded: true,
                              value: _slides,
                              items: <int>[30, 50, 75, 100, 101]
                                  .map<DropdownMenuItem<int>>(
                                (int value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Text(value.toString()),
                                  );
                                },
                              ).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _slides = (newValue == null) ? 0 : newValue;
                                });
                              }),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: true,
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
                            value: 1,
                            groupValue: _duration,
                            onChanged: (int? value) {
                              setState(() {
                                _duration = (value == null) ? 0 : value;
                              });
                            },
                            title: const Text('Within 24 hours'),
                          ),
                          RadioListTile(
                            value: 3,
                            groupValue: _duration,
                            onChanged: (int? value) {
                              setState(() {
                                _duration = (value == null) ? 0 : value;
                              });
                            },
                            title: const Text('Within 1-3 days'),
                          ),
                          RadioListTile(
                            value: 4,
                            groupValue: _duration,
                            onChanged: (int? value) {
                              setState(() {
                                _duration = (value == null) ? 0 : value;
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
                        var credentials = {
                          "name": nameController.text,
                          "category": _category,
                          "sub_category": subCategoryController.text,
                          "topic": topicController.text,
                          "slides": _slides.toString(),
                          "duration": _duration.toString(),
                          "phone": phoneController.text,
                          "email": emailController.text,
                          "location": locationController.text
                        };
                        await context.read<PackagesViewModel>().searchPackage(
                              duration: _duration,
                              slides: _slides,
                            );
                        var package = context.read<PackagesViewModel>().package;
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
