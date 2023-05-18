import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

String GENERAL_URL = 'http://127.0.0.1:8000/';
String TOKEN = '';
Map<String, dynamic> currentUser = {};
late Uint8List defaultImageBytes;

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
      ByteData byteData = await rootBundle.load('assets/images/worker_default.png');
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

Map<String, dynamic> getCurrentUser() => currentUser;

void setCurrentUser(Map<String, dynamic> newUser) {
  currentUser = newUser;
}

String getCurrentUserName() {
  if (currentUser.isNotEmpty) {
    return '${currentUser['name']} ${currentUser['surname']}';
  }
  return '';
}

String getCurrentUserEmail() {
  if (currentUser.isNotEmpty) {
    return currentUser['email'];
  }
  return '';
}

String getCurrentUserAbout() {
  if (currentUser.isNotEmpty) {
    return currentUser['about'];
  }
  return '';
}

String getCurrentUserType() {
  if (currentUser.isNotEmpty) {
    final userTypes = {
      'W': 'Worker',
      'F': 'Farm Owner',
      'A': 'Agronomist',
    };
    return userTypes[currentUser['user_type']] ?? '';
  }
  return '';
}

Image getCurrentUserImage() {
  if (currentUser.isNotEmpty) {
    return Image.memory(
      currentUser['profile_photo'],
      fit: BoxFit.cover,
    );
  }
  return Image.asset(
    'assets/images/worker_default.png',
    fit: BoxFit.cover,
  );
}

Uint8List getCurrentUserImageBytes() {
  if (currentUser.isNotEmpty) {
    return currentUser['profile_photo'];
  }
  return defaultImageBytes;

}
