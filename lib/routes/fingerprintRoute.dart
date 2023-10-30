import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_app/helpers.dart';
import 'package:sensors_app/uiElements/dialog.dart';

import '../uiElements/helpButton.dart';

class FingerPrint extends StatefulWidget {
  const FingerPrint({super.key});

  @override
  State<FingerPrint> createState() => _FingerPrintState();
}

class _FingerPrintState extends State<FingerPrint> {
  LocalAuthentication localAuthentication = LocalAuthentication();
  IconData lockIcon = Icons.lock_outline;

  Future<void> CheckFingerprint() async {
    try {
      final bool canAuthenticateWithBiometrics =
          await localAuthentication.canCheckBiometrics;

      if (canAuthenticateWithBiometrics) {
        bool isFingeprint = await localAuthentication.authenticate(
            localizedReason: "Prislonite prst",
            options:
                AuthenticationOptions(useErrorDialogs: true, stickyAuth: true));
        if (isFingeprint) {
          print("uspjesno");
          setState(() {
            lockIcon = Icons.lock_open;
          });
        } else {
          print("Neuspjesno");
          setState(() {
            lockIcon = Icons.lock_outline;
          });
        }
      } else {
        CustomDialog.showMyDialog(context, "Uređaj nema senzor otiska prsta");
      }
    } catch (e) {
      CustomDialog.showMyDialog(context, "Nešto je pošlo u krivu");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Otisak prsta'),
        backgroundColor: Colors.amber[800],
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.fromLTRB(0, displayHeight(context) * 0.2, 0, 0),
          child: Column(
            children: [
              Icon(lockIcon,
                  color: Colors.white, size: displayWidth(context) / 2),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[800]),
                  onPressed: CheckFingerprint,
                  child: Text(
                    "Otključaj",
                    style: TextStyle(fontSize: displayHeight(context) * 0.025),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, displayHeight(context) * 0.1,
                        displayWidth(context) * 0.2, 0),
                    child: HelpButton(
                        text:
                            "Stisnite na gum otključaj, nakon čega će vas mobitel pitati za autorizaciju."),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
