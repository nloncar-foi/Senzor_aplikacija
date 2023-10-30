import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_app/helpers.dart';
import 'package:sensors_app/uiElements/helpButton.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Accelerometer extends StatefulWidget {
  const Accelerometer({super.key});

  @override
  State<Accelerometer> createState() => _AccelerometerState();
}

class _AccelerometerState extends State<Accelerometer> {
  String text = "Presporo";
  String reachedAcceleration = "0";

  Color containerColor = Colors.red;
  int accelerationGoal = 5;

  final streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    streamSubscriptions.add(userAccelerometerEvents.listen(
      (UserAccelerometerEvent event) {
        if (event.x > accelerationGoal) {
          print(event);
          text = "Odlično";
          containerColor = Colors.green;
        }
        if (event.x > 5) {
          reachedAcceleration = event.x.toStringAsFixed(2);
        }
        setState(() {});
      },
      onError: (error) {
        // Logic to handle error
        // Needed for Android in case sensor is not available
      },
      cancelOnError: true,
    ));
    super.initState();
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
        title: const Text("Akcelerometar"),
        backgroundColor: Colors.amber[800],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Ink(
                  decoration: const ShapeDecoration(
                      shape: CircleBorder(), color: Colors.grey),
                  child: IconButton(
                    onPressed: () {
                      if (accelerationGoal > 5) accelerationGoal--;
                    },
                    icon: const Icon(Icons.exposure_minus_1),
                  )),
              Container(
                margin: EdgeInsets.all(displayWidth(context) * 0.05),
                child: Text(
                  "$accelerationGoal m/s^2",
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              Ink(
                  decoration: const ShapeDecoration(
                      shape: CircleBorder(), color: Colors.grey),
                  child: IconButton(
                    onPressed: () {
                      accelerationGoal++;
                    },
                    icon: const Icon(Icons.exposure_plus_1),
                  ))
            ],
          ),
          Container(
            margin: EdgeInsets.all(displayWidth(context) * 0.04),
            width: displayWidth(context) * 0.5,
            height: displayHeight(context) * 0.08,
            color: containerColor,
            child: Center(
              child: Text(
                text,
                style: TextStyle(fontSize: displayHeight(context) * 0.03),
              ),
            ),
          ),
          Container(
              margin:
                  EdgeInsets.fromLTRB(0, 0, 0, displayHeight(context) * 0.05),
              child: Text("Postignuta akceleracija: $reachedAcceleration m/s^2",
                  style: TextStyle(
                      fontSize: displayHeight(context) * 0.025,
                      color: Colors.white))),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Ink(
                  decoration: ShapeDecoration(
                      shape: const CircleBorder(), color: Colors.amber[800]),
                  child: IconButton(
                    onPressed: () {
                      text = "Presporo";
                      containerColor = Colors.red;
                      reachedAcceleration = "0";
                    },
                    icon: const Icon(
                      Icons.restart_alt,
                    ),
                  )),
              const HelpButton(
                  text:
                      "Postavite željenu akceleraciju i probajte ju postići pomicanjem mobitela po x osi (horizontalna os u odnosu na zaslon).\n"
                      "Nakon uspjeha, resetirajte igru pomoću gumba za resetiranje.\n"
                      "Napomena: na zaslon se ispisuju samo brzine veće od 5 m/s^2")
            ],
          ),
        ],
      ),
    );
  }
}
