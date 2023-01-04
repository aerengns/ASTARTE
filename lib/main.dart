import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:astarte/homepage.dart';
import 'package:astarte/reports.dart';
import 'package:astarte/workers.dart';
import 'package:astarte/farms.dart';
import 'package:astarte/photo_upload.dart';
import 'package:astarte/sign_in.dart';
import 'package:astarte/sign_up.dart';
import 'package:astarte/farm_data_form.dart';

import 'heatmap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Astarte());
}

class Astarte extends StatelessWidget {
  const Astarte({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ASTARTE',
      initialRoute: '/sign_in',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const HomePage(),
        '/sign_in': (context) => const MyApp(),
        '/sign_up': (context) => const SignUp(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/reports': (context) => const Reports(),
        '/workers': (context) => const Workers(),
        '/farms': (context) => const Farms(),
        '/farm_data_form': (context) => const FarmDataForm(),
        '/heatmap': (context) => const Heatmap(),
        '/photo-upload': (context) => PhotoUpload(),
      },
    );
  }
}
