import 'dart:math';

import 'package:astarte/sidebar.dart';
import 'package:astarte/utils/calendar_utils.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late final ValueNotifier<List<Event>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AstarteAppBar(
        title: 'Calendar',
      ),
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1.0),
      body: Column(
        children: [
          TableCalendar(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronIcon: Icon(Icons.chevron_left_rounded),
                rightChevronIcon: Icon(Icons.chevron_right_rounded)),
            shouldFillViewport: false,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: true,
              outsideTextStyle: TextStyle(color: Color.fromRGBO(0, 7, 10, 0.2)),
              todayDecoration: BoxDecoration(
                  color: Color.fromRGBO(255, 128, 47, 0.5),
                  shape: BoxShape.circle),
              defaultTextStyle: TextStyle(color: Color.fromRGBO(0, 7, 10, 1.0)),
              weekendTextStyle:
                  TextStyle(color: Color.fromRGBO(222, 10, 10, 1.0)),
              selectedDecoration: BoxDecoration(
                  color: Color(0xFFFF802F), shape: BoxShape.circle),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (BuildContext context, date, events) {
                if (events.isEmpty) return SizedBox();
                return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: events.length < 3? events.length: 3,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(top: 23),
                        padding: const EdgeInsets.all(1),
                        child: Container(
                          // height: 7, // for vertical axis
                          width: 8, // for horizontal axis
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: eventMarkerColor(date, events[index])
                          ),
                        ),
                      );
                    });
              },
            ),
            onDaySelected: _onDaySelected,
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0), // TODO: Color the boxes according to event type
                      ),
                      child: value[index].get(),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      drawer: NavBar(context),
    );
  }
}
