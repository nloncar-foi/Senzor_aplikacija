import 'package:flutter/material.dart';

class CustomDialog {
  static void showMyDialog(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.grey[700],
          actions: <Widget>[
            TextButton(
              child: Text(
                'U redu',
                style: TextStyle(color: Colors.amber[800]),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
