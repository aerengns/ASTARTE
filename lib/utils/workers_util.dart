import 'dart:convert';
import 'dart:typed_data';

import 'package:astarte/utils/parameters.dart' as parameters;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'calendar_utils.dart';

class Worker {
  final String name;
  final String surname;
  final String email;
  final int permissionLevel;
  Event? event;
  String? about;
  Image? profilePhoto;

  Worker(
      {required this.name,
      required this.surname,
      required this.email,
      required this.permissionLevel,
      this.event,
      this.about,
      this.profilePhoto});

  Map<String, dynamic> toDict() {
    return {
      'name': name,
      'surname': surname,
      'email': email,
      'event': event?.toDict(),
      'about': about,
      'image': '',
      'permissionLevel': permissionLevel,
    };
  }

  @override
  String toString() {
    return '${name.toLowerCase()} ${surname.toLowerCase()} ${email.toLowerCase()}';
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is Worker &&
        other.name == name &&
        other.surname == surname &&
        other.email == email;
  }

  @override
  int get hashCode => Object.hash(name, surname, email);
}

Future<List<Worker>> getWorkerData() async {
  try {
    var headers = {
      'Authorization': parameters.TOKEN,
    };
    // your endpoint and request method
    var request = http.MultipartRequest(
        'POST', Uri.parse('${parameters.GENERAL_URL}app/workers_data'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String newMessage = await response.stream.bytesToString();
      dynamic data = jsonDecode(newMessage);
      List<Worker> source = [];
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
          profilePhoto: Image.memory(
            decodedImage,
            fit: BoxFit.cover,
          ),
          permissionLevel: worker['permission_level'],
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

Future<List<Event>> getAvailableJobs() async {
  try {
    var headers = {
      'Authorization': parameters.TOKEN,
    };
    // your endpoint and request method
    var request = http.MultipartRequest(
        'GET', Uri.parse('${parameters.GENERAL_URL}app/jobs_data'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String newMessage = await response.stream.bytesToString();
      dynamic data = jsonDecode(newMessage);
      List<Event> source = [];
      for (dynamic event in data) {
        DateTime date = DateTime.parse(event['date']);
        Event temp = Event(
            title: event['title'],
            eventType: event['type'] as int,
            date: date,
            importance: event['importance'] as int);
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

Future<bool> assignJob(Worker worker, Event event) async {
  try {
    var headers = {
      'Authorization': parameters.TOKEN,
    };
    // your endpoint and request method
    var request = http.MultipartRequest(
        'POST', Uri.parse('${parameters.GENERAL_URL}app/jobs_data'))
      ..headers.addAll(headers)
      ..fields['worker'] = jsonEncode(worker.toDict())
      ..fields['event'] = jsonEncode(event.toDict());

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      print(response.reasonPhrase);
      return false;
    }
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> finishJob() async {
  try {
    var headers = {
      'Authorization': parameters.TOKEN,
    };
    // your endpoint and request method
    var request = http.MultipartRequest(
        'POST', Uri.parse('${parameters.GENERAL_URL}app/job_finish'))
      ..headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      print(response.reasonPhrase);
      return false;
    }
  } catch (e) {
    print(e);
    return false;
  }
}
