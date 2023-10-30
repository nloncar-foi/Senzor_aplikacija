import 'dart:async';

import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;
import 'package:sensors_app/helpers.dart';
import 'package:geocoding/geocoding.dart' as geocoder;
import 'package:sensors_app/uiElements/dialog.dart';

import '../uiElements/helpButton.dart';

class LocationRoute extends StatefulWidget {
  const LocationRoute({super.key});

  @override
  State<LocationRoute> createState() => _LocationRouteState();
}

class _LocationRouteState extends State<LocationRoute> {
  LocationData? _locationData;
  Location location = Location();
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  String? locationCountry = "Nepoznato", locationLocality = "Nepoznato";

  @override
  void initState() {
    requestLocationPermission();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  Future<void> requestLocationPermission() async {
    permission_handler.PermissionStatus status =
        await permission_handler.Permission.location.status;

    bool isLocationServiceEnabled = await location.serviceEnabled();

    if (status.isGranted) {
      if (isLocationServiceEnabled) {
        setSubscription();
      } else {
        CustomDialog.showMyDialog(context,
            'Za korištenje ovog djela aplikacije morate imati uključenu lokaciju.');
      }
    } else if (status.isDenied) {
      status = await permission_handler.Permission.location.request();
    } else if (status.isPermanentlyDenied) {
      permission_handler.openAppSettings();
    }
  }

  void setSubscription() {
    _streamSubscriptions
        .add(location.onLocationChanged.listen((LocationData currentLocation) {
      getCountry(currentLocation.latitude, currentLocation.longitude);
      setState(() {
        _locationData = currentLocation;
      });
    }));
  }

  Future<void> getCountry(double? latitude, double? longitude) async {
    try {
      List<geocoder.Placemark> placemarks =
          await geocoder.placemarkFromCoordinates(
              latitude!.toDouble(), longitude!.toDouble());
      if (placemarks.isNotEmpty) {
        setState(() {
          locationCountry = placemarks.first.country ?? "Nepoznato";
          locationLocality = placemarks.first.locality ?? "Nepoznato";
        });
      }
    } catch (e) {
      setState(() {
        locationCountry = "Nepoznato";
        locationLocality = "Nepoznato";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle myTextStyle = TextStyle(
        color: Colors.white, fontSize: displayHeight(context) * 0.025);

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Lokacija'),
        backgroundColor: Colors.amber[800],
      ),
      body: Center(
        child: Column(
          children: [
            _locationData != null
                ? Container(
                    margin: EdgeInsets.only(top: displayHeight(context) * 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Latitude: ${_locationData!.latitude}',
                          style: myTextStyle,
                        ),
                        Text(
                          'Longitude: ${_locationData!.longitude}',
                          style: myTextStyle,
                        ),
                        Text(
                          "Zemlja: $locationCountry",
                          style: myTextStyle,
                        ),
                        Text(
                          "Naselje: $locationLocality",
                          style: myTextStyle,
                        )
                      ],
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(top: displayHeight(context) * 0.1),
                    child:
                        const CircularProgressIndicator(color: Colors.white)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, displayHeight(context) * 0.1,
                      displayWidth(context) * 0.2, 0),
                  child: const HelpButton(
                      text:
                          "Za ovaj je dio aplikacije potrebno da lokacija bude uključena. Također je potrebna i dozvola za korištenje lokacije. Ako vas aplikacija za dozvolu automatski ne pita, a niste ju dali, potrebno je dozvolu dati u postavkama uređaja. "),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
