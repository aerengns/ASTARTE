import 'package:astarte/network_manager/services/calendar_events_service.dart';
import 'package:astarte/network_manager/services/sensor_data_service.dart';
import 'package:astarte/theme/colors.dart';
import 'package:astarte/utils/calendar_utils.dart';
import 'package:astarte/utils/parameters.dart';
import 'package:astarte/utils/reports_util.dart';
import 'package:astarte/utils/date_filter.dart';
import 'package:astarte/utils/farm_selection_dropdown.dart';
import 'package:chopper/chopper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:astarte/sidebar.dart';
import 'package:async/async.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:provider/provider.dart';

class ActivityLogs extends StatefulWidget {
  ActivityLogs({Key? key}) : super(key: key);
  @override
  State<ActivityLogs> createState() => _ActivityLogsState();
}

class _ActivityLogsState extends State<ActivityLogs> {
  List<dynamic> logs = [
    // Log data
  ];
  List<bool> _isExpandedList = [];
  List<Farm> farms = [];
  String selectedFarm = "";
  DateTime selectedStartDate = DateTime.now().subtract(Duration(days: 1));
  DateTime selectedEndDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    addRangeFilter();
    fillFarms().whenComplete(() => _addDropdown());
  }

  final List<Widget> _widgets = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AstarteAppBar(
        title: 'Logs',
      ),
      body: Column(
        children: _widgets,
      ),
      drawer: NavBar(context),
    );
  }

  void addRangeFilter() {
    setState(() {
      _widgets.add(DateFilter(
        onStartDateSelected: (date) {
          setState(() {
            selectedStartDate = date;
            getActivityLogData(selectedFarm)
                .whenComplete(() => _addActivityLogContainer());
          });
        },
        onEndDateSelected: (date) {
          setState(() {
            selectedEndDate = date;
            getActivityLogData(selectedFarm)
                .whenComplete(() => _addActivityLogContainer());
          });
        },
      ));
    });
  }

  void _addDropdown() {
    setState(() {
      _widgets.add(DropDown(
        farms: farms,
        onFarmSelected: (farm) {
          setState(() {
            selectedFarm = farm;
            getActivityLogData(farm)
                .whenComplete(() => _addActivityLogContainer());
          });
        },
      ));
    });
  }

  void _addActivityLogContainer() {
    setState(() {
      _widgets.removeWhere((widget) => widget is Expanded);
      _widgets.add(
        Expanded(
          child: ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              return ActivityLogsPart(
                log: logs[index],
                index: index,
                onLogSelected: (isExpanded) {
                  setState(() {
                    _isExpandedList[index] = isExpanded;
                  });
                },
              );
            },
          ),
        ),
      );
    });
  }

  Future<void> getActivityLogData(String selectedFarm) async {
    final startDate = selectedStartDate != null
        ? DateFormat('yyyy-MM-dd').format(selectedStartDate!)
        : '';
    final endDate = selectedEndDate != null
        ? DateFormat('yyyy-MM-dd').format(selectedEndDate!)
        : '';
    final response =
        await Provider.of<CalendarEventsService>(context, listen: false)
            .getActivityLogData(selectedFarm, startDate, endDate);
    if (response.isSuccessful) {
      String new_message = await response.bodyString;
      setState(() {
        logs = jsonDecode(new_message);
        ;
        _isExpandedList = List<bool>.filled(logs.length, false);
      });
    } else {
      // Handle error response
    }
  }

  Future<void> fillFarms() async {
    final response =
        await Provider.of<SensorDataService>(context, listen: false)
            .getFarmList();

    if (response.isSuccessful) {
      String new_message = await response.bodyString;
      dynamic data = jsonDecode(new_message);
      farms.add(Farm(name: "----------", id: ""));
      for (dynamic n in data) {
        farms.add(Farm(name: n[0], id: n[1].toString()));
      }
      selectedFarm = farms[0].id;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logs failed to load. Please try again.'),
        ),
      );
    }
  }
}

class ActivityLogsPart extends StatefulWidget {
  const ActivityLogsPart(
      {Key? key,
      required this.log,
      required this.index,
      required this.onLogSelected})
      : super(key: key);

  final Map<String, dynamic> log;
  final int index;
  final Function(bool isExpanded) onLogSelected;
  @override
  State<ActivityLogsPart> createState() => _ActivityLogsPartState();
}

class _ActivityLogsPartState extends State<ActivityLogsPart> {
  String selectedFarm = "";
  late Map<String, dynamic> _log;
  late int _index;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _log = widget.log;
    _index = widget.index;
  }

  Widget build(BuildContext context) {
    return _buildLogContainer(_log, _index);
  }

  Widget _buildLogContainer(Map<String, dynamic> log, int index) {
    final date = DateTime.parse(log['date_finished']);
    final formattedFinishDate = DateFormat('yyyy-MM-dd').format(date);

    return Container(
      // Customize the container's appearance as needed
      padding: const EdgeInsets.all(4.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: CustomColors.astarteBrown,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ExpansionPanelList(
        elevation: 1,
        expandedHeaderPadding: EdgeInsets.zero,
        expansionCallback: (int panelIndex, bool isExpanded) {
          setState(() {
            _isExpanded = !isExpanded;
            widget.onLogSelected(_isExpanded);
          });
        },
        children: [
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  'Farm: ${log['farm__name']} - ${log['tittle']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDataItem('Worker',
                    '${log['worker__profile__name']} ${log['worker__profile__surname']}'),
                _buildDataItem('Type', '${eventTypes[int.parse(log['type'])]}'),
                _buildDataItem('Description', '${log['description']}'),
                _buildDataItem('Finish Date', '$formattedFinishDate'),
              ],
            ),
            isExpanded: _isExpanded,
          ),
        ],
      ),
    );
  }

  Widget _buildDataItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 20.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
