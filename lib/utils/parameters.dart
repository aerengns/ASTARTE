import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

String GENERAL_URL = 'https://pythoneverywhere.com/astarte/';
String WEATHER_API_URL = 'https://api.open-meteo.com/v1/forecast';
String GEOLOCATOR_API_URL =
    "https://api.bigdatacloud.net/data/reverse-geocode-client";
String TOKEN = '';
String NOTIFICATION_VAPID_KEY =
    'BBn-BM4feM6Pqx4ECRoBirHpHGlv2U20wohQ4tVFkAoni97gDBw3_4HxxPJbbZNvBpbgx32hBcQKLQ8tI15IASY';
late Uint8List defaultImageBytes;
String? deviceToken;

Future<Map<String, dynamic>> requestCurrentUser(String token) async {
  try {
    var headers = {
      'Authorization': token,
    };
    // your endpoint and request method
    var request = http.MultipartRequest(
        'POST', Uri.parse('${GENERAL_URL}api/v1/firebase/get_user'))
      ..headers.addAll(headers)
      ..fields['token'] = token;

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String newMessage = await response.stream.bytesToString();
      Map<String, dynamic> data = jsonDecode(newMessage);
      // Get the base64 encoded image data from the JSON response
      final String encodedImage = data['profile_photo'];

      // Decode the base64 encoded image data
      final Uint8List decodedImage = base64.decode(encodedImage);
      data['profile_photo'] = decodedImage;

      // Retrieve the bytes from the image asset
      ByteData byteData =
          await rootBundle.load('assets/images/worker_default.png');
      defaultImageBytes = byteData.buffer.asUint8List();

      return data;
    } else {
      print(response.reasonPhrase);
      return {};
    }
  } catch (e) {
    print(e);
    return {};
  }
}

class CurrentUser extends ChangeNotifier {
  String _name = '';
  String _surname = '';
  String _email = '';
  String _about = '';
  String _userType = 'W';
  Uint8List _profilePhoto = Uint8List(0);

  String get username => '$_name $_surname';
  String get name => _name;
  String get surname => _surname;
  String get email => _email;
  String get about => _about;
  Uint8List get profilePhotoBytes => _profilePhoto;
  String get userType {
    final userTypes = {
      'W': 'Worker',
      'F': 'Farm Owner',
      'A': 'Agronomist',
    };
    return userTypes[_userType] ?? 'Worker';
  }

  Image get profilePhoto {
    return Image.memory(
      _profilePhoto,
      fit: BoxFit.cover,
    );
  }

  void setUser(Map<String, dynamic> newUser) {
    _name = newUser['name'];
    _surname = newUser['surname'];
    _email = newUser['email'];
    _about = newUser['about'];
    _userType = newUser['user_type'];
    _profilePhoto = newUser['profile_photo'];
    notifyListeners();
  }

  void resetUser() {
    _name = '';
    _surname = '';
    _email = '';
    _about = '';
    _userType = 'W';
    _profilePhoto = defaultImageBytes;
    notifyListeners();
  }

  Map<String, dynamic> toDict() {
    return {
      'name': name,
      'surname': surname,
      'email': email,
      'about': about,
      'user_type': userType,
      'profile_photo': profilePhotoBytes,
    };
  }
}

void sendTokenToServer(BuildContext context) async {
  final currentUser = Provider.of<CurrentUser>(context, listen: false);
  var request =
      http.MultipartRequest('POST', Uri.parse('${GENERAL_URL}app/send_token'));
  final body = <String, String>{
    'device_token': deviceToken as String,
    'user': jsonEncode(currentUser.toDict()),
  };
  request.fields.addAll(body);

  http.StreamedResponse response = await request.send();
  if (response.statusCode == 200) {
    print('Token sent successfully!');
  } else {
    print('Failed to send token!');
  }
}
