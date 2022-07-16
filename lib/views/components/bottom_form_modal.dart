import 'package:flutter/material.dart';

class BottomFormModal extends StatelessWidget {
  final void Function() action;
  final List<Widget> children;
  final String actionText;
  final bool loading;

  const BottomFormModal({
    Key? key,
    required this.action,
    this.actionText = 'Submit',
    required this.children,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 30,
        right: 10,
        left: 30,
        bottom: MediaQuery.of(context).viewInsets.bottom + 30,
      ),
      child: Column(
          children: children +
              <Widget>[
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: action,
                  child: loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        )
                      : Text(actionText),
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(20)),
                )
              ]),
    );
  }
}
