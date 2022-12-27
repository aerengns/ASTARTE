import 'package:flutter/material.dart';
import 'package:astarte/sidebar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:astarte/notificationBadge.dart';
import 'package:overlay_support/overlay_support.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _totalNotifications;
  PushNotification? _notificationInfo;
  late final FirebaseMessaging _messaging;

  @override
  void initState() {
    _totalNotifications = 0;

    checkForInitialMessage();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
      );
      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    });
    super.initState();
  }

  // For handling notification when the app is in terminated state
  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
        dataTitle: initialMessage.data['title'],
        dataBody: initialMessage.data['body'],
      );
      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    }
  }

  Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }

  void registerNotification() async {
    await Firebase.initializeApp();

    _messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {

        if (_notificationInfo != null) {
          showSimpleNotification(
            Text(_notificationInfo!.title!),
            leading: NotificationBadge(totalNotifications: _totalNotifications),
            subtitle: Text(_notificationInfo!.body!),
            background: Colors.cyan.shade700,
            duration: Duration(seconds: 2),
          );
        }
        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );

        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ASTARTE'),
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/astarte.jpg',
                height: 200,
                width: 200,
              ),
              const Text(
                'Welcome to the ASTARTE!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Here you can track your farm, from planting and harvesting crops to taking care of pests. Explore our site to discover all the different ways you can get help in farming and make a difference in the world.',
                style: TextStyle(
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 100,),
              Padding(
                padding: const EdgeInsets.only(right: 100.0, left: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed: (){}, icon:  const Icon(Icons.water_drop_rounded, size: 100, color: Colors.blueAccent)),
                    IconButton(onPressed: (){}, icon: const Icon(Icons.pest_control_rounded, size: 100, color: Colors.brown,)),
                  ],
                ),
              ),
              const SizedBox(height: 100,),
              Padding(
                padding: const EdgeInsets.only(right: 100.0, left: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NotificationBadge(totalNotifications: _totalNotifications),
                  ],
                ),
              ),
            ],
          ),
        ),
        drawer: sideBar(context));
  }
}

class PushNotification {
  PushNotification({
    this.title,
    this.body,
    this.dataTitle,
    this.dataBody,
  });
  String? title;
  String? body;
  String? dataTitle;
  String? dataBody;
}


