import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_app/helpers.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:screen_brightness/screen_brightness.dart';

import '../uiElements/helpButton.dart';

class MyProximitySensor extends StatefulWidget {
  const MyProximitySensor({super.key});

  @override
  State<MyProximitySensor> createState() => _MyProximitySensorState();
}

class _MyProximitySensorState extends State<MyProximitySensor> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  int proximity = 0;
  IconData icon = Icons.lightbulb;
  Color color = Colors.yellow;

  @override
  void initState() {
    _streamSubscriptions.add(ProximitySensor.events.listen((event) {
      proximity = event;

      if (proximity == 0) {
        icon = Icons.lightbulb;
        color = Colors.yellow;
        setBrightness(1);
      } else {
        icon = Icons.lightbulb_outline;
        color = Colors.grey;
        setBrightness(0);
      }

      setState(() {});
    }));

    super.initState();
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
      throw 'Failed to set brightness';
    }
  }

  Future<void> resetBrightness() async {
    try {
      await ScreenBrightness().resetScreenBrightness();
    } catch (e) {
      throw 'Failed to reset brightness';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text("Senzor blizine"),
        backgroundColor: Colors.amber[800],
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: color, size: 120),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, displayHeight(context) * 0.1,
                    displayWidth(context) * 0.2, 0),
                child: const HelpButton(
                    text:
                        "Pomoću senzora blizine, na zaslonu će se mijenjati ikona te će se mijenjati svjetlina vašeg uređaja. Senzor blizine se uobičajeno nalazi kod gornjeg ruba mobilnog uređaja. "),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
