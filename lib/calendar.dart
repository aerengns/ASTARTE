import 'dart:convert';
import 'dart:math';

import 'package:astarte/network_manager/models/custom_event.dart';
import 'package:astarte/network_manager/services/calendar_events_service.dart';
import 'package:astarte/sidebar.dart';
import 'package:astarte/theme/colors.dart';
import 'package:astarte/utils/calendar_utils.dart';
import 'package:astarte/utils/workers_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:built_collection/built_collection.dart';
import 'package:http/http.dart' as http;
import 'package:astarte/utils/parameters.dart' as parameters;

import 'farm_detail.dart';

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
            rowHeight: 42,
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
              child: AddEventButton(_selectedDay),
            ),
          ),
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
                      child: InkWell(
                        child: value[index].get(),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EventEditPage(
                                event: value[index],
                              ),
                            ),
                          );
                        },
                      ),
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

class AddEventButton extends StatefulWidget {
  AddEventButton(this.selectedDay, {Key? key}) : super(key: key);
  DateTime? selectedDay;

  @override
  State<AddEventButton> createState() => _AddEventButtonState();
}

class _AddEventButtonState extends State<AddEventButton> {
  late DateTime date = widget.selectedDay!;
  final titleController = TextEditingController();
  final farmController = TextEditingController();
  final eventTypeController = TextEditingController();
  final importanceController = TextEditingController();
  final descriptionController = TextEditingController();

  late Map<int, String> farmDisplayDict = {};

  Future<EventDropdownWidget> getFarmDropdownWidget() async {
    final relatedFarms = await getRelatedFarms();
    for (var element in relatedFarms) {
      farmDisplayDict.addAll({
        element[0]: element[1],
      });
    }

    return EventDropdownWidget(
      selectedOptionController: farmController,
      itemsList: farmDisplayDict.keys.toList(),
      itemDisplayDict: farmDisplayDict,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void controllerClear() {
    titleController.clear();
    farmController.clear();
    eventTypeController.clear();
    importanceController.clear();
    descriptionController.clear();
  }

  @override
  void dispose() {
    titleController.dispose();
    farmController.dispose();
    eventTypeController.dispose();
    importanceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 8,
                alignment: Alignment.topCenter,
                actionsAlignment: MainAxisAlignment.spaceAround,
                title: const Text(
                  'Add Event',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CustomColors.astarteBlack,
                  ),
                ),
                content: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.6,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: titleController,
                            autovalidateMode: AutovalidateMode.always,
                            validator: (value) {
                              if (value?.isEmpty == true) {
                                return 'Input can not be empty';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Title',
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: CustomColors.astarteGrey,
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: descriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: CustomColors.astarteGrey,
                              ),
                            ),
                          ),
                          EventDropdownWidget(
                            selectedOptionController: eventTypeController,
                            itemsList: eventTypes.keys.toList(),
                            itemDisplayDict: eventTypes,
                          ),
                          EventDropdownWidget(
                            selectedOptionController: importanceController,
                            itemsList: eventImportanceTypes.keys.toList(),
                            itemDisplayDict: eventImportanceTypes,
                          ),
                          FutureBuilder<EventDropdownWidget>(
                              future: getFarmDropdownWidget(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<EventDropdownWidget> snapshot) {
                                if (snapshot.hasData) {
                                  return snapshot.data!;
                                }
                                return const CircularProgressIndicator();
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.3, 0),
                      backgroundColor: CustomColors.astarteDarkGrey,
                    ),
                    onPressed: () {
                      controllerClear();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: CustomColors.astarteWhite,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.3, 0),
                      backgroundColor: CustomColors.astarteGreen,
                    ),
                    onPressed: () async {
                      if (await createEvent()) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Event created successfully'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Event creation failed. Please try again.'),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: CustomColors.astarteWhite,
                      ),
                    ),
                  ),
                ],
              );
            });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Icon(Icons.add),
          Text('Add Event', style: TextStyle(fontSize: 16.0)),
        ],
      ),
    );
  }

  Future<bool> createEvent() async {
    try {
      var headers = {
        'Authorization': parameters.TOKEN,
      };
      int eventType = 0;
      int importance = 0;
      int farm_id = 0;

      for (var elem in eventTypes.entries) {
        if (elem.value == eventTypeController.text) {
          eventType = elem.key;
        }
      }
      for (var elem in eventImportanceTypes.entries) {
        if (elem.value == importanceController.text) {
          importance = elem.key;
        }
      }

      for (var elem in farmDisplayDict.entries) {
        if (elem.value == farmController.text) {
          farm_id = elem.key;
        }
      }

      Event event = Event(
          id: -1,
          title: titleController.text,
          eventType: eventType,
          date: date,
          importance: importance,
          description: descriptionController.text);

      var request = http.MultipartRequest(
          'POST', Uri.parse('${parameters.GENERAL_URL}app/create_event'))
        ..headers.addAll(headers)
        ..fields['event'] = jsonEncode(event.toDict())
        ..fields['farm_id'] = farm_id.toString();

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
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
}

class EventEditPage extends StatefulWidget {
  const EventEditPage({Key? key, required this.event}) : super(key: key);
  final Event event;

  @override
  State<EventEditPage> createState() => _EventEditPageState();
}

class _EventEditPageState extends State<EventEditPage> {
  late final TextEditingController _titleController =
      TextEditingController(text: widget.event.title);
  late final TextEditingController _descriptionController =
      TextEditingController(text: widget.event.description ?? '');
  late final TextEditingController _importanceController =
      TextEditingController(
          text: eventImportanceTypes[widget.event.importance]);
  late final TextEditingController _eventTypeController =
      TextEditingController(text: eventTypes[widget.event.eventType]);

  @override
  void dispose() {
    // Dispose of the text controllers when the page is disposed
    _titleController.dispose();
    _descriptionController.dispose();
    _importanceController.dispose();
    super.dispose();
  }

  Future<bool> _saveChanges() async {
    try {
      // Update the properties of the event with the modified values
      var headers = {
        'Authorization': parameters.TOKEN,
      };

      String title = _titleController.text;
      String? description = _descriptionController.text;
      int eventType = 0;
      int importance = 0;

      for (var elem in eventTypes.entries) {
        if (elem.value == _eventTypeController.text) {
          eventType = elem.key;
        }
      }
      for (var elem in eventImportanceTypes.entries) {
        if (elem.value == _importanceController.text) {
          importance = elem.key;
        }
      }
      var request = http.MultipartRequest(
          'POST', Uri.parse('${parameters.GENERAL_URL}app/edit_event'))
        ..headers.addAll(headers)
        ..fields['title'] = title
        ..fields['description'] = description
        ..fields['type'] = eventType.toString()
        ..fields['importance'] = importance.toString()
        ..fields['event'] = jsonEncode(widget.event.toDict());

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

  Future<void> _deleteEvent() async {
    try {
      // Update the properties of the event with the modified values
      var headers = {
        'Authorization': parameters.TOKEN,
      };

      var request = http.MultipartRequest(
          'DELETE', Uri.parse('${parameters.GENERAL_URL}app/edit_event'))
        ..headers.addAll(headers)
        ..fields['event'] = jsonEncode(widget.event.toDict());

      http.StreamedResponse response = await request.send();

      void showSnackBar(String message) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }

      switch (response.statusCode) {
        case 204:
          showSnackBar('Event has been deleted.');
          Navigator.of(context).pop();
          break;
        default:
          showSnackBar('Unknown error. Farm could not have been deleted.');
          break;
      }
    } catch (e) {
      print(e);
    }
  }

  void showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteConfirmationDialog(
          onDeleteConfirmed: _deleteEvent,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AstarteAppBar(
        title: 'Edit Event',
        actions: <Widget>[
          IconButton(
            onPressed: () => showDeleteConfirmationDialog(context),
            icon: const Icon(Icons.delete_forever_rounded),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
            ),
            EventDropdownWidget(
              selectedOptionController: _eventTypeController,
              itemsList: eventTypes.keys.toList(),
              itemDisplayDict: eventTypes,
            ),
            EventDropdownWidget(
              selectedOptionController: _importanceController,
              itemsList: eventImportanceTypes.keys.toList(),
              itemDisplayDict: eventImportanceTypes,
            ),
            ElevatedButton(
              onPressed: () async {
                if (await _saveChanges()) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Event edited successfully'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Event edit failed. Please try again.'),
                    ),
                  );
                }
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}

class EventDropdownWidget extends StatefulWidget {
  EventDropdownWidget(
      {Key? key,
      required this.selectedOptionController,
      required this.itemsList,
      required this.itemDisplayDict})
      : super(key: key);
  TextEditingController selectedOptionController;
  List<int> itemsList;
  Map<int, String> itemDisplayDict;

  @override
  State<EventDropdownWidget> createState() => _EventDropdownWidgetState();
}

class _EventDropdownWidgetState extends State<EventDropdownWidget> {
  late String selectedOption = widget.selectedOptionController.text == ''
      ? widget.itemDisplayDict[widget.itemsList.first]!
      : widget.selectedOptionController.text;

  @override
  void initState() {
    super.initState();
    widget.selectedOptionController.text = selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      alignment: Alignment.centerLeft,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      value: selectedOption,
      onChanged: (String? newValue) {
        setState(() {
          selectedOption = newValue!;
        });
        widget.selectedOptionController.text = selectedOption;
      },
      items: widget.itemsList.map<DropdownMenuItem<String>>((int value) {
        return DropdownMenuItem<String>(
          value: widget.itemDisplayDict[value]!,
          child: Text(widget.itemDisplayDict[value]!),
        );
      }).toList(),
    );
  }
}
