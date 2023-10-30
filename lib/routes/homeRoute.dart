import 'package:flutter/material.dart';
import 'package:sensors_app/helpers.dart';

class Home extends StatefulWidget {
  final List<HomePageButton> homePageButtons;
  const Home(this.homePageButtons, {super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.homePageButtons
              .map((e) => HomePageButtonTemplate(
                    buttonText: e.text,
                    buttonIcon: e.icon,
                    route: e.route,
                  ))
              .toList(),
        ),
      )),
    );
  }
}

class HomePageButtonTemplate extends StatelessWidget {
  final String buttonText;
  final IconData buttonIcon;
  final String route;
  const HomePageButtonTemplate({
    super.key,
    required this.buttonText,
    required this.buttonIcon,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          0, displayHeight(context) * 0.01, 0, displayHeight(context) * 0.01),
      child: ElevatedButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, route);
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber[800],
              minimumSize: Size(
                  displayWidth(context) * 0.50, displayHeight(context) * 0.05),
              elevation: 10),
          icon: Icon(buttonIcon, size: displayHeight(context) * 0.04),
          label: Text(
            buttonText,
            style: TextStyle(
                color: Colors.white, fontSize: displayHeight(context) * 0.02),
          )),
    );
  }
}

class HomePageButton {
  String text;
  IconData icon;
  String route;
  HomePageButton(this.text, this.icon, this.route);
}
