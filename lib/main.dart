import 'package:astarte/network_manager/services/sensor_data_service.dart';
import 'package:astarte/theme/astarte_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:astarte/homepage.dart';
import 'package:astarte/humidity_report.dart';
import 'package:astarte/npk_values_report.dart';
import 'package:astarte/temperature_report.dart';
import 'package:astarte/workers.dart';
import 'package:astarte/farms.dart';
import 'package:astarte/photo_upload.dart';
import 'package:astarte/sign_in.dart';
import 'package:astarte/sign_up.dart';
import 'package:astarte/farm_data_form.dart';
import 'package:astarte/calendar.dart';
import 'package:astarte/pests_and_diseases.dart';
import 'heatmap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // get user permission for sending notifications on iOS
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      print('notification: ${message.notification}');
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  _setupLogging();
  runApp(const Astarte());
}

class Astarte extends StatelessWidget {
  const Astarte({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      Provider(
        create: (_) => SensorDataService.create(),
        dispose: (_, SensorDataService service) => service.client.dispose(),
      ),
    ],
      child: MaterialApp(
        title: 'ASTARTE',
        theme: AstarteTheme.lightTheme,
        initialRoute: '/',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => const HomePage(),
          '/sign_in': (context) => const MyApp(),
          '/sign_up': (context) => const SignUp(),
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/humidity_report': (context) => HumidityReport(),
          '/npk_report': (context) => NPKReport(),
          '/temperature_report': (context) => TemperatureReport(),
          '/workers': (context) => const Workers(),
          '/farms': (context) => const Farms(),
          '/farm_data_form': (context) => const FarmData(),
          '/heatmap': (context) => const Heatmap(),
          '/photo-upload': (context) => PhotoUpload(),
          '/calendar': (context) => const Calendar(),
          '/pests-and-diseases': (context) => const PestsAndDiseases(),
        },
      ),
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}