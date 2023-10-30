import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_app/helpers.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:sensors_app/uiElements/helpButton.dart';

class Magnetometer extends StatefulWidget {
  const Magnetometer({super.key});

  @override
  State<Magnetometer> createState() => _MagnetometerState();
}

class _MagnetometerState extends State<Magnetometer> {
  final streamSubscriptions = <StreamSubscription<dynamic>>[];
  String x = "", y = "", z = "";

  @override
  void initState() {
    streamSubscriptions.add(magnetometerEvents.listen(
      (MagnetometerEvent event) {
        x = event.x.toStringAsFixed(5);
        y = event.y.toStringAsFixed(5);
        z = event.z.toStringAsFixed(5);
        setState(() {});
      },
      onError: (error) {
        //kod za obradu greške
      },
      cancelOnError: true,
    ));

    super.initState();
  }

  @override
  void dispose() {
    for (final subscription in streamSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text("Magnetometar"),
        backgroundColor: Colors.amber[800],
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, displayHeight(context) * 0.1, 0,
                displayHeight(context) * 0.03),
            child: Text(
              "x: $x",
              style: TextStyle(
                  color: Colors.white, fontSize: displayHeight(context) * 0.03),
            ),
          ),
          Container(
            margin: EdgeInsets.all(displayHeight(context) * 0.03),
            child: Text(
              "y: $y",
              style: TextStyle(
                  color: Colors.white, fontSize: displayHeight(context) * 0.03),
            ),
          ),
          Container(
            margin: EdgeInsets.all(displayHeight(context) * 0.03),
            child: Text(
              "z: $z",
              style: TextStyle(
                  color: Colors.white, fontSize: displayHeight(context) * 0.03),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, displayHeight(context) * 0.05,
                    displayWidth(context) * 0.15, 0),
                child: const HelpButton(
                  text:
                      'Pomičite vaš mobilni uređaj, a magnetometar će očitati promjene magnetskom polju. ',
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
