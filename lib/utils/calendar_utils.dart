// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

/// Example event class.
class Event {
  final String title;
  Image? img;

  Event(this.title, [this.img]);

  get() => ListTile(
        title: Text(title),
        trailing: img,
      );
}

final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource = {
  kToday: [
    Event('You should do some watering',
        Image.asset('assets/icons/watering.png')),
    Event('Water please I am dying here',
        Image.asset('assets/icons/watering.png')),
    Event('Lorem Ipsum'),
    Event('Lorem Ipsum'),
    Event('Lorem Ipsum'),
    Event('Lorem Ipsum'),
  ],
  kToday.add(const Duration(days: 1)): [
    Event("FROST INCOMING!!", Image.asset('assets/icons/frost.png')),
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

Color eventMarkerColor(DateTime date, Object? event) {
  if (date.day == kToday.day) {
    return const Color(0xFF08BCDC);
  } else {
    return const Color(0xffff0000);
  }
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year - 1, kToday.month, 1);
// Subtract 1 day from the first day of next month to get the last day of this month
final kLastDay = DateTime(kToday.year, kToday.month + 3, 1)
    .subtract(const Duration(days: 1));
