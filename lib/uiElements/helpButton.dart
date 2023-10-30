import 'package:flutter/material.dart';

class HelpButton extends StatelessWidget {
  final String text;
  const HelpButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Ink(
        decoration: ShapeDecoration(shape: CircleBorder(), color: Colors.grey),
        child: IconButton(
          onPressed: () {
            final snackBar = SnackBar(
                duration: Duration(minutes: 1),
                content: Text(text),
                action: SnackBarAction(label: 'Zatvori', onPressed: () {}));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          icon: Icon(Icons.question_mark),
          color: Colors.white,
        ));
  }
}
