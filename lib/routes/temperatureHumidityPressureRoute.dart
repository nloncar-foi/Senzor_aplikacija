import 'dart:async';

import 'package:environment_sensors/environment_sensors.dart';
import 'package:flutter/material.dart';
import 'package:sensors_app/helpers.dart';
import 'package:sensors_app/uiElements/helpButton.dart';

class TemperatureHumidityPressure extends StatefulWidget {
  const TemperatureHumidityPressure({super.key});

  @override
  State<TemperatureHumidityPressure> createState() =>
      _TemperatureHumidityPressureState();
}

class _TemperatureHumidityPressureState
    extends State<TemperatureHumidityPressure> {
  final streamSubscriptions = <StreamSubscription<dynamic>>[];
  final environmentSensors = EnvironmentSensors();

  double temperature = 0, humidity = 0, pressure = 0;

  IconData tempIcon = Icons.question_mark;
  Color tempColor = Colors.white, tempIconColor = Colors.white;

  Color humidityColor = Colors.white;

  bool termometerAvailable = false;
  bool humiditySensorAvailable = false;
  bool barometerAvailable = false;

  @override
  void initState() {
    streamSubscriptions.add(environmentSensors.temperature.listen(
      (event) {
        temperature = event;
        SetTemperature();
        setState(() {});
      },
    ));

    streamSubscriptions.add(environmentSensors.humidity.listen((event) {
      humidity = event;
      SetHumidity();
      setState(() {});
    }));

    streamSubscriptions.add(environmentSensors.pressure.listen((event) {
      pressure = event;
      setState(() {});
    }));

    CheckAvailability();

    super.initState();
  }

  void SetTemperature() {
    if (temperature <= 0) {
      tempIcon = Icons.ac_unit;
      tempColor = Colors.lightBlueAccent;
      tempIconColor = Colors.lightBlueAccent;
    } else if (temperature > 0 && temperature < 18) {
      tempIcon = Icons.cloud;
      tempColor = Colors.white;
      tempIconColor = Colors.white;
    } else if (temperature >= 18 && temperature < 28) {
      tempIcon = Icons.sunny;
      tempColor = Colors.white;
      tempIconColor = Colors.yellow;
    } else {
      tempIcon = Icons.local_fire_department_sharp;
      tempColor = Colors.red;
      tempIconColor = Colors.orange;
    }
  }

  void SetHumidity() {
    if (humidity < 30) {
      humidityColor = Colors.red;
    } else if (humidity >= 30 && humidity <= 50) {
      humidityColor = Colors.white;
    } else {
      humidityColor = Colors.blue;
    }
  }

  Future<void> CheckAvailability() async {
    bool _termometerAvailable;
    bool _humiditySensorAvailable;
    bool _barometerAvailable;

    _termometerAvailable = await environmentSensors
        .getSensorAvailable(SensorType.AmbientTemperature);

    _humiditySensorAvailable =
        await environmentSensors.getSensorAvailable(SensorType.Humidity);

    _barometerAvailable =
        await environmentSensors.getSensorAvailable(SensorType.Pressure);

    setState(() {
      termometerAvailable = _termometerAvailable;
      barometerAvailable = _barometerAvailable;
      humiditySensorAvailable = _humiditySensorAvailable;
    });
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
        title: const Text("Okolišni senzori"),
        backgroundColor: Colors.amber[800],
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          if (termometerAvailable)
            Container(
              margin:
                  EdgeInsets.fromLTRB(0, displayHeight(context) * 0.1, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$temperature °C ",
                    style: TextStyle(
                        color: tempColor,
                        fontSize: displayHeight(context) * 0.03),
                  ),
                  Icon(
                    tempIcon,
                    color: tempIconColor,
                  )
                ],
              ),
            )
          else
            Container(
              margin:
                  EdgeInsets.fromLTRB(0, displayHeight(context) * 0.1, 0, 0),
              child: Text(
                "Senzor za mjerenje temperature\nnije dostupan!",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: displayHeight(context) * 0.025),
              ),
            ),
          if (humiditySensorAvailable)
            Container(
              margin: EdgeInsets.fromLTRB(0, displayHeight(context) * 0.05, 0,
                  displayHeight(context) * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$humidity% ",
                    style: TextStyle(
                        color: humidityColor,
                        fontSize: displayHeight(context) * 0.03),
                  ),
                  Icon(
                    Icons.water_drop,
                    color: humidityColor,
                  )
                ],
              ),
            )
          else
            Container(
              margin: EdgeInsets.fromLTRB(0, displayHeight(context) * 0.05, 0,
                  displayHeight(context) * 0.05),
              child: Text(
                "Senzor za mjerenje vlažnosti\nnije dostupan.",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: displayHeight(context) * 0.025),
              ),
            ),
          if (barometerAvailable)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$pressure hPa ",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: displayHeight(context) * 0.03),
                ),
                const Icon(
                  Icons.speed,
                  color: Colors.white,
                )
              ],
            )
          else
            Text(
              "Barometar nije dostupan.",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: displayHeight(context) * 0.025),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, displayHeight(context) * 0.1,
                    displayWidth(context) * 0.2, 0),
                child: const HelpButton(
                    text:
                        "Ako vaš uređaj posjeduje odgovarajuće senzore, na zaslone će se ispisivati podaci koje oni očitavaju."),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
