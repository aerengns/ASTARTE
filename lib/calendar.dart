import 'dart:math';

import 'package:astarte/network_manager/models/custom_event.dart';
import 'package:astarte/network_manager/services/calendar_events_service.dart';
import 'package:astarte/sidebar.dart';
import 'package:astarte/theme/colors.dart';
import 'package:astarte/utils/calendar_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:built_collection/built_collection.dart';

class Calendar extends StatefulWidget {
  Calendar({Key? key, required this.farmId}) : super(key: key);

  int farmId;

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
    // TODO: instead of print it should refresh the calendar
    getCalendarData(widget.farmId).whenComplete(() => print('Done'));
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

  Future<BuiltList<CustomEvent>> getCustomEvents() async {
    var date = _selectedDay!.toIso8601String().split('T')[0];
    final response = await CalendarEventsService.create().getCalendarData(date);
    if (response.isSuccessful) {
      return response.body!;
    } else {
      throw response.error!;
    }
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
                  color: CustomColors.astarteBrown, shape: BoxShape.circle),
              defaultTextStyle: TextStyle(color: Colors.black),
              weekendTextStyle: TextStyle(color: CustomColors.astarteRed),
              selectedDecoration: BoxDecoration(
                  color: CustomColors.astarteOrange, shape: BoxShape.circle),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (BuildContext context, date, events) {
                if (events.isEmpty) return const SizedBox();
                return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: events.length < 3 ? events.length : 3,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(top: 23),
                        padding: const EdgeInsets.all(1),
                        child: Container(
                          // height: 7, // for vertical axis
                          width: 8, // for horizontal axis
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: eventMarkerColor(events[index])),
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
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        // open a dialog to enter text with max length 255
                        // add the event to the database
                        // refresh the calendar
                        showDialog(
                            context: context,
                            builder: (context) {
                              final textController = TextEditingController();
                              return AlertDialog(
                                title: const Text('Add Event'),
                                content: TextField(
                                  controller: textController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Description',
                                  ),
                                  maxLength: 255,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      final response = await Provider.of<
                                                  CalendarEventsService>(
                                              context,
                                              listen: false)
                                          .createCustomEvent(CustomEvent((b) =>
                                              b
                                                ..description =
                                                    textController.text
                                                ..date = _selectedDay!
                                                    .toIso8601String()
                                                    .split('T')[0]));

                                      if (response.isSuccessful) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Event created'),
                                          ),
                                        );
                                        Navigator.pop(context);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text('Could not create event'),
                                          ),
                                        );
                                      }
                                    },
                                    child: const Text('Save'),
                                  ),
                                ],
                              );
                            });
                      },
                      icon: const Icon(Icons.add),
                    ),
                    const Text('Add Event', style: TextStyle(fontSize: 16.0)),
                  ],
                ),
              )),
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
                        borderRadius: BorderRadius.circular(12.0),
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
    );
  }
}
