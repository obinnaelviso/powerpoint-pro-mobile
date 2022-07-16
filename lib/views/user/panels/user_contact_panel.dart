import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UserContactPanel extends StatelessWidget {
  const UserContactPanel({Key? key}) : super(key: key);
  static const String title = "Contact Us";

  Future<void> _launchUrl(String path) async {
    final uri = Uri.parse(path);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Expanded(
                    child: Text(
                  'PHONE NUMBER: ',
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                )),
                Expanded(
                    child: TextButton(
                  onPressed: () {
                    _launchUrl("tel:07030885803");
                  },
                  child: const Text(
                    '0703 088 5803',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                  ),
                )),
              ],
            ),
            const Divider(height: 20.0),
            Row(
              children: [
                const Expanded(
                    child: Text(
                  'EMAIL ADDRESS: ',
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                )),
                Expanded(
                    flex: 2,
                    child: TextButton(
                      onPressed: () {
                        _launchUrl("mailto:usaguwa@gmail.com");
                      },
                      child: const Text(
                        'usaguwa@gmail.com',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                    )),
              ],
            ),
            const Divider(height: 20.0),
            Row(
              children: [
                const Expanded(
                    child: Text(
                  'ADLINE: ',
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                )),
                Expanded(
                    child: TextButton(
                  onPressed: () {
                    _launchUrl("tel:0901873147");
                  },
                  child: const Text(
                    '0901 187 3147',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                  ),
                )),
              ],
            ),
          ],
        ),
      );
}
