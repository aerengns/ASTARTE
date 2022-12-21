import 'package:flutter/material.dart';
import 'package:astarte/homepage.dart';
import 'package:astarte/reports.dart';
import 'package:astarte/workers.dart';
import 'package:astarte/farms.dart';

void main() => runApp(const Astarte());

class Astarte extends StatelessWidget {
  const Astarte({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ASTARTE',
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const HomePage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/reports': (context) => const Reports(),
        '/workers': (context) => const Workers(),
        '/farms': (context) => const Farms(),
      },
    );
  }
}