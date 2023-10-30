import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_app/helpers.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:sensors_app/uiElements/helpButton.dart';

class Gyroscope extends StatefulWidget {
  const Gyroscope({super.key});

  @override
  State<Gyroscope> createState() => _GyroscopeState();
}

class _GyroscopeState extends State<Gyroscope> {
  double x = 0, y = 0, z = 0;

  Color colorUp = Colors.grey,
      colorDown = Colors.grey,
      colorLeft = Colors.grey,
      colorRight = Colors.grey,
      colorLeftZ = Colors.grey,
      colorRightZ = Colors.grey;

  final streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    streamSubscriptions.add(gyroscopeEvents.listen(
      (GyroscopeEvent event) {
        x = event.x;
        y = event.y;
        z = event.z;

        print("$x $y $z");

        SetColors();
        setState(() {});
      },
      onError: (error) {
        //kod za obradu greške
      },
      cancelOnError: true,
    ));

    super.initState();
  }

  void SetColors() {
    if (x > 0) {
      colorDown = Colors.amber;
      colorUp = Colors.grey;
    } else if (x < 0) {
      colorDown = Colors.grey;
      colorUp = Colors.amber;
    } else {
      colorDown = Colors.grey;
      colorUp = Colors.grey;
    }

    if (y > 0) {
      colorLeft = Colors.grey;
      colorRight = Colors.amber;
    } else if (y < 0) {
      colorLeft = Colors.amber;
      colorRight = Colors.grey;
    } else {
      colorLeft = Colors.grey;
      colorRight = Colors.grey;
    }

    if (z > 0) {
      colorLeftZ = Colors.amber;
      colorRightZ = Colors.grey;
    } else if (z < 0) {
      colorLeftZ = Colors.grey;
      colorRightZ = Colors.amber;
    } else {
      colorLeftZ = Colors.grey;
      colorRightZ = Colors.grey;
    }
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text("Žiroskop"),
        backgroundColor: Colors.amber[800],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DirectionText(
                  text: "Lijevo (os z)",
                  color: colorLeftZ,
                  fontSizeProportion: 0.02),
              DirectionText(
                  text: "Desno (os z)",
                  color: colorRightZ,
                  fontSizeProportion: 0.02),
            ],
          ),
          DirectionText(text: "Gore", color: colorUp, fontSizeProportion: 0.04),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DirectionText(
                  text: "Lijevo", color: colorLeft, fontSizeProportion: 0.04),
              DirectionText(
                  text: "Desno", color: colorRight, fontSizeProportion: 0.04),
            ],
          ),
          DirectionText(
              text: "Dolje", color: colorDown, fontSizeProportion: 0.04),
          Align(
            alignment: FractionalOffset.bottomRight,
            child: Container(
              margin: const EdgeInsets.all(20),
              child: const HelpButton(
                  text:
                      "Okrećite vaš mobitel, a žiroskop će očitati promjene u orijentaciji.\n"
                      "Napomena: u odnosu na zaslon mobilnog uređaja, os x je horizontalna, os y vertikalna, a z os je okomita na zaslon."),
            ),
          ),
        ],
      ),
    );
  }
}

class DirectionText extends StatefulWidget {
  final Color color;
  final String text;
  final double fontSizeProportion;

  const DirectionText(
      {super.key,
      required this.text,
      required this.color,
      required this.fontSizeProportion});
  @override
  State<DirectionText> createState() => _DirectionTextState();
}

class _DirectionTextState extends State<DirectionText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(displayHeight(context) * 0.04),
      child: Text(widget.text,
          style: TextStyle(
              color: widget.color,
              fontSize: displayHeight(context) * widget.fontSizeProportion)),
    );
  }
}
