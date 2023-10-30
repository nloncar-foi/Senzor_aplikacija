import 'package:flutter/material.dart';
import 'package:sensors_app/routes/accelerometerRoute.dart';
import 'package:sensors_app/routes/fingerprintRoute.dart';
import 'package:sensors_app/routes/homeRoute.dart';
import 'package:sensors_app/routes/gyroscopeRoute.dart';
import 'package:sensors_app/routes/locationRoute.dart';
import 'package:sensors_app/routes/magnetometerRoute.dart';
import 'package:sensors_app/routes/lightSensorRoute.dart';
import 'package:sensors_app/routes/proximitySensorRoute.dart';
import 'package:sensors_app/routes/temperatureHumidityPressureRoute.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  List<HomePageButton> homePageButtons = [
    HomePageButton("Žiroskop", Icons.screen_rotation, "/gyroscope"),
    HomePageButton("Akcelerometar", Icons.speed, "/accelerometer"),
    HomePageButton("Magnetometar", Icons.adjust_sharp, "/magnetometer"),
    HomePageButton(
        "Okolišni senzori", Icons.thermostat, "/temperatureHumidityPressure"),
    HomePageButton("Senzor svjetla", Icons.light_mode_outlined, "/lightSensor"),
    HomePageButton(
        "Senzor blizine", Icons.close_fullscreen, "/proximitySensor"),
    HomePageButton("Lokacija", Icons.location_on, "/location"),
    HomePageButton("Otisak prsta", Icons.fingerprint, "/fingerprint")
  ];

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(MaterialApp(routes: {
    "/": (context) => Home(homePageButtons),
    "/gyroscope": (context) => Gyroscope(),
    "/accelerometer": (context) => Accelerometer(),
    "/magnetometer": (context) => Magnetometer(),
    "/temperatureHumidityPressure": (context) => TemperatureHumidityPressure(),
    "/lightSensor": (context) => LightSensor(),
    "/proximitySensor": (context) => MyProximitySensor(),
    "/location": (context) => LocationRoute(),
    "/fingerprint": (context) => FingerPrint()
  }));
}
