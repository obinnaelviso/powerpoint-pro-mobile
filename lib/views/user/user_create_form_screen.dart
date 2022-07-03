import 'package:flutter/material.dart';
import 'package:powerpoint_pro/helpers/constants.dart';

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
      body: Column(
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
                  const FormInput(
                    label: "Name",
                    required: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const FormInput(
                    label: "Category",
                    required: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const FormInput(
                    label: "Sub-Category (Optional)",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const FormInput(
                    label: "Topic",
                    required: true,
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
                  const FormInput(
                    label: "Special Request",
                    type: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Visibility(
                    visible: true,
                    child: FormInput(
                      label: "Special Request",
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const FormInput(
                    label: "Phone Number",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const FormInput(
                    label: "Email",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const FormInput(
                    label: "Location",
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
                        border: Border.all(width: 2.0, color: Colors.black12)),
                    child: Column(
                      children: [
                        RadioListTile(
                          value: 1,
                          groupValue: _duration,
                          onChanged: (int? value) {
                            _duration = (value == null) ? 0 : value;
                          },
                          title: const Text('Within 24 hours'),
                        ),
                        RadioListTile(
                          value: 3,
                          groupValue: _duration,
                          onChanged: (int? value) {
                            _duration = (value == null) ? 0 : value;
                          },
                          title: const Text('Within 1-3 days'),
                        ),
                        RadioListTile(
                          value: 4,
                          groupValue: _duration,
                          onChanged: (int? value) {
                            _duration = (value == null) ? 0 : value;
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
                    onPressed: () {},
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
    );
  }
}
