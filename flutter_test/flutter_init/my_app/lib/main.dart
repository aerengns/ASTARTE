// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/validator.dart';
import 'firebase_options.dart';
import 'package:my_app/homepage.dart';
import 'package:my_app/reports.dart';
import 'package:my_app/workers.dart';
import 'package:my_app/farms.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Astarte());
}

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
