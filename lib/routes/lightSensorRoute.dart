import 'dart:async';

import 'package:environment_sensors/environment_sensors.dart';
import 'package:flutter/material.dart';
import 'package:sensors_app/helpers.dart';
import 'package:screen_brightness/screen_brightness.dart';

import '../uiElements/helpButton.dart';

class LightSensor extends StatefulWidget {
  const LightSensor({super.key});

  @override
  State<LightSensor> createState() => _LightSensorState();
}

class _LightSensorState extends State<LightSensor> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  final environmentSensors = EnvironmentSensors();
  double light = 0;
  @override
  void initState() {
    _streamSubscriptions.add(environmentSensors.light.listen((event) {
      print(event);
      light = event;

      SetLight(light);

      setState(() {});
    }));

    super.initState();
  }

  void SetLight(double light) {
    if (light < 50) {
      setBrightness(0);
    } else if (light < 100) {
      setBrightness(0.4);
    } else if (light < 200) {
      setBrightness(0.8);
    } else {
      setBrightness(1);
    }
  }

  @override
  void dispose() {
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    resetBrightness();
    super.dispose();
  }

  Future<void> setBrightness(double brightness) async {
    try {
      await ScreenBrightness().setScreenBrightness(brightness);
    } catch (e) {
      print(e);
      throw 'Failed to set brightness';
    }
  }

  Future<void> resetBrightness() async {
    try {
      await ScreenBrightness().resetScreenBrightness();
    } catch (e) {
      print(e);
      throw 'Failed to reset brightness';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text("Senzor svjetla"),
        backgroundColor: Colors.amber[800],
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            margin: EdgeInsets.all(displayHeight(context) * 0.1),
            child: Text(
              "${light} lx",
              style: TextStyle(
                fontSize: displayHeight(context) * 0.025,
                color: Colors.white,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin:
                    EdgeInsets.fromLTRB(0, 0, displayWidth(context) * 0.2, 0),
                child: HelpButton(
                    text:
                        "Na zaslonu se ispisuje podatak koji očitava vaš uređaj pomoću senzora za svjetlost. Na temelju tog podatka, uređaj će mijenjati svjetlinu zaslona."),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
