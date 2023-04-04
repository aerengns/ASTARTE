// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';
import 'dart:convert';

import 'package:astarte/utils/parameters.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';

// Event Images
const int wateringEvent = 0;
const int frostEvent = 1;

Map<int, Image> cEventImages = {
  wateringEvent: Image.asset('assets/icons/watering.png'),
  frostEvent: Image.asset('assets/icons/frost.png'),
};

// Event Importance Levels
const int criticalEvent = 0;
const int moderateEvent = 1;
const int safeEvent = 2;

/// Event class.
class Event {
  final String title;
  final int eventType;
  final DateTime date;
  int? importance;

  Event(
      {required this.title,
      required this.eventType,
      required this.date,
      this.importance});

  get() => ListTile(
        title: Text(title),
        trailing: cEventImages[eventType],
      );
}

final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource = {
  kToday: [
    Event(
        title: 'You should do some watering',
        eventType: wateringEvent,
        date: kToday),
    Event(
        title: 'Water please I am dying here',
        eventType: wateringEvent,
        date: kToday),
  ],
  kToday.add(const Duration(days: 1)): [
    Event(
        title: "FROST INCOMING!!",
        eventType: frostEvent,
        date: kToday.add(const Duration(days: 1)),
        importance: criticalEvent),
  ]
};

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

Future<void> getCalendarData() async {
  try {
    var headers = {
      'Authorization': 'Bearer ' "token",
    };
    // your endpoint and request method
    var request = http.MultipartRequest(
        'POST', Uri.parse('${GENERAL_URL}app/calendar_data'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String newMessage = await response.stream.bytesToString();
      dynamic data = jsonDecode(newMessage);
      Map<DateTime, List<Event>> source = {};
      for (dynamic event in data['events']) {
        DateTime date = DateTime.parse(event['date']);
        Event temp = Event(
            title: event['title'],
            eventType: event['event_type'] as int,
            date: date,
            importance: event['importance'] as int);
        source[date] != null?source[date]?.add(temp): source[date] = [temp];
      }
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
