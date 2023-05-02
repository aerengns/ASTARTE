import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
import 'dart:io';

import 'package:astarte/utils/parameters.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'calendar_utils.dart';

class Worker {
  final String name;
  final String surname;
  final String email;
  Event? event;
  String? about;
  Image? profilePhoto;

  Worker({required this.name,
    required this.surname,
    required this.email,
    this.event,
    this.about,
    this.profilePhoto});
}

Future<List<Worker>> getWorkerData() async {
  try {
    var headers = {
      'Authorization': 'Bearer ' "token",
    };
    // your endpoint and request method
    var request = http.MultipartRequest(
        'POST', Uri.parse('${GENERAL_URL}app/workers_data'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String newMessage = await response.stream.bytesToString();
      dynamic data = jsonDecode(newMessage);
      List<Worker> source = [];
      bool once = true;
      for (dynamic worker in data) {
        // Get the base64 encoded image data from the JSON response
        final String encodedImage = worker['profile_photo'];


        // Decode the base64 encoded image data
        final Uint8List decodedImage = base64.decode(encodedImage);

        Event? event;
        if (worker['event'] != null) {
          event = Event.fromMap(worker['event']);
        }
        Worker temp = Worker(
            name: worker['name'],
            surname: worker['surname'],
            email: worker['email'],
            about: worker['about'],
            event: event,
            //TODO: profilePhoto: Image.memory(decodedImage),
          profilePhoto: Image.network(
            'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
            fit: BoxFit.cover,
          ),
        );
        source.add(temp);
      }
      return source;
    } else {
      print(response.reasonPhrase);
      return [];
    }
  } catch (e) {
    print(e);
    return [];
  }
}
