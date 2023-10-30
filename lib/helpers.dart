import 'package:flutter/material.dart';

Size displaySize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double displayHeight(BuildContext context) {
  return displaySize(context).height;
}

double displayWidth(BuildContext context) {
  return displaySize(context).width;
}

/*import 'dart:async';

import 'package:flutter/material.dart';

class Thermometer extends StatefulWidget {
  const Thermometer({super.key});

  @override
  State<Thermometer> createState() => _ThermometerState();
}

class _ThermometerState extends State<Thermometer> {

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  String x = "", y = "", z = "";

  @override
  void initState() {

    _streamSubscriptions.add();

    super.initState();
  }

  @override
  void dispose() {
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text("Magnetometar"),
        backgroundColor: Colors.amber[800],
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: []),
      ),
    );
    ;
  }
}
*/
