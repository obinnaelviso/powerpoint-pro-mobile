import 'package:flutter/material.dart';
import 'package:powerpoint_pro/views/components/title_text.dart';

class UserPackagesPanel extends StatelessWidget {
  const UserPackagesPanel({Key? key}) : super(key: key);
  static const String title = "Packages";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TitleText("Our Packages & Price List"),
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(columns: const [
                DataColumn(label: Text("Name")),
                DataColumn(label: Text("Price")),
              ], rows: const [
                DataRow(cells: [
                  DataCell(Text("24 Hour")),
                  DataCell(Text("N5000")),
                ]),
                DataRow(cells: [
                  DataCell(Text("2 Days")),
                  DataCell(Text("N3000")),
                ]),
                DataRow(cells: [
                  DataCell(Text("3-4 Days")),
                  DataCell(Text("N5000")),
                ]),
              ]),
            ),
          )
        ],
      ),
    );
  }
}
