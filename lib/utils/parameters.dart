import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String GENERAL_URL = 'https://pythoneverywhere.com/astarte/';
String TOKEN = '';
Map<String, dynamic> currentUser = {};

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
      data['profile_photo'] = Image.memory(
        decodedImage,
        fit: BoxFit.cover,
      );
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

Image getCurrentUserImage() {
  if (currentUser.isNotEmpty) {
    return currentUser['profile_photo'];
  }
  return Image.network(
    'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
    fit: BoxFit.cover,
    width: 90,
    height: 90,
  );
}
