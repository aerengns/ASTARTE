// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';
import 'dart:convert';

import 'package:astarte/utils/parameters.dart' as parameters;
import 'package:astarte/utils/workers_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';

// Event Types and Images
const int increaseIrrigationEvent = 0;
const int decreaseIrrigationEvent = 1;
const int frostEvent = 2;
const int heatStressEvent = 3;
const int customEvent = 4;

const Map<int, String> eventTypes = {
  increaseIrrigationEvent: 'Increase Irrigation Event',
  decreaseIrrigationEvent: 'Decrease Irrigation Event',
  frostEvent: 'Frost Event',
  heatStressEvent: 'Heat Stress Event',
  customEvent: 'Custom Event',
};

Map<int, Image> eventImages = {
  increaseIrrigationEvent: Image.asset('assets/icons/watering.png'),
  decreaseIrrigationEvent: Image.network(
      'https://www.crushpixel.com/big-static21/preview4/reduce-irrigation-farmland-rgb-color-5525462.jpg'),
  frostEvent: Image.asset('assets/icons/frost.png'),
  heatStressEvent: Image.network(
      'https://www.shutterstock.com/image-vector/fired-head-vector-icon-style-260nw-552786577.jpg'),
  customEvent: Image.network(
      'https://d1nhio0ox7pgb.cloudfront.net/_img/o_collection_png/green_dark_grey/512x512/plain/wrench.png'),
};

// Event Importance Levels
const int criticalEvent = 0;
const int moderateEvent = 1;
const int safeEvent = 2;

const Map<int, String> eventImportanceTypes = {
  criticalEvent: 'Critical Event',
  moderateEvent: 'Moderate Event',
  safeEvent: 'Safe Event',
};

/// Event class.
class Event {
  final int id;
  late final String title;
  late final String? description;
  final int eventType;
  final DateTime date;
  int? importance;

  Event({
    required this.id,
    required this.title,
    required this.eventType,
    required this.date,
    this.importance,
    this.description,
  });

  Map<String, dynamic> toDict() {
    return {
      'id': id,
      'title': title,
      'type': eventType,
      'date': date.toIso8601String().split('T')[0],
      'importance': importance,
      'description': description,
    };
  }

  get() => ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: eventImages.containsKey(eventType)
            ? eventImages[eventType]
            : const Icon(Icons.add_chart_rounded),
        subtitle: Text(
          description ?? "No description available",
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
      );

  getImage() => eventImages[eventType];

  Event.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        eventType = map['type'],
        date = DateTime.parse(map['date']),
        importance = map['importance'],
        description = map['description'];
}

/* Calendar Stuff */

final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
);

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

Color eventMarkerColor(Object? obj) {
  Event event = obj as Event;
  switch (event.importance) {
    case criticalEvent:
      return const Color(0xffff0000);
    case moderateEvent:
      return const Color(0xffff4d00);
    case safeEvent:
      return const Color(0xff22ff00);
    default:
      return const Color(0xff37ff00);
  }
}

Future<void> getCalendarData(int farmId) async {
  try {
    var headers = {
      'Authorization': parameters.TOKEN,
    };
    // your endpoint and request method
    var request = http.MultipartRequest(
        'POST', Uri.parse('${parameters.GENERAL_URL}app/calendar_data'));

    request.headers.addAll(headers);
    if (farmId != -1) {
      request.fields['farm_ids'] = jsonEncode([farmId]);
    } else {
      final relatedFarms = await getRelatedFarms();
      List<int> farmIds = [];
      for (var element in relatedFarms) {
        farmIds.add(element[0]);
      }
      request.fields['farm_ids'] = jsonEncode(farmIds);
    }

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String newMessage = await response.stream.bytesToString();
      dynamic data = jsonDecode(newMessage);
      Map<DateTime, List<Event>> source = {};
      for (dynamic event in data['events']) {
        DateTime date = DateTime.parse(event['date']);
        Event temp = Event(
          id: event['id'],
          title: event['title'],
          eventType: event['event_type'] as int,
          date: date,
          importance: event['importance'] as int,
          description: event['description'],
        );
        source[date] != null ? source[date]?.add(temp) : source[date] = [temp];
      }
      kEvents.clear();
      kEvents.addAll(source);
    } else {
      print(response.reasonPhrase);
    }
  } catch (e) {
    print(e);
  }
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year - 1, kToday.month, 1);
// Subtract 1 day from the first day of next month to get the last day of this month
final kLastDay = DateTime(kToday.year, kToday.month + 3, 1)
    .subtract(const Duration(days: 1));
