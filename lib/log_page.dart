import 'package:astarte/network_manager/services/sensor_data_service.dart';
import 'package:astarte/theme/colors.dart';
import 'package:astarte/utils/parameters.dart';
import 'package:astarte/utils/reports_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:astarte/sidebar.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:provider/provider.dart';

class Logs extends StatefulWidget {
  Logs({Key? key}) : super(key: key);
  @override
  State<Logs> createState() => _LogsState();
}

class _LogsState extends State<Logs> {
  List<dynamic> logs = [
    // Log data
  ];
  List<bool> _isExpandedList = [];
  List<Farm> farms = [];
  String selectedFarm = "";

  @override
  void initState() {
    super.initState();
    fillFarms().whenComplete(() => _addDropdown());
  }

  final List<Widget> _widgets = [
    Image.asset(
      'assets/images/astarte.jpg',
      width: 100,
      height: 100,
      fit: BoxFit.contain,
    ),
    const Text("Select a Farm"),
  ];

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

  void _addDropdown() {
    setState(() {
      _widgets.add(
        Center(
          child: DropdownButton<String>(
            value: selectedFarm,
            icon: const Icon(
              Icons.arrow_drop_down_circle,
              color: CustomColors.astarteRed,
            ),
            onChanged: (value) {
              setState(() {
                selectedFarm = value!;
              });
              getLogData(selectedFarm).whenComplete(() => _addLogContainer());
            },
            items: farms.map((farm) {
              return DropdownMenuItem<String>(
                value: farm.id,
                child: Text(farm.name),
              );
            }).toList(),
          ),
        ),
      );
    });
  }

  void _addLogContainer() {
    setState(() {
      _widgets.removeWhere((widget) => widget is Expanded);
      _widgets.add(
        Expanded(
          child: ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              return _buildLogContainer(log, index);
            },
          ),
        ),
      );
    });
  }

  Widget _buildLogContainerOld(dynamic log) {
    final date = DateTime.parse(log['date_collected']);
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    return Container(
      // Customize the container's appearance as needed
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Farm Name: ${log['farm__name']}'),
          Text('Parcel: ${log['parcel']}'),
          Text('Moisture: ${log['moisture']}'),
          Text('Phosphorus: ${log['phosphorus']}'),
          Text('Potassium: ${log['potassium']}'),
          Text('Nitrogen: ${log['nitrogen']}'),
          Text('Temperature: ${log['temperature']}'),
          Text('pH: ${log['ph']}'),
          Text('Latitude: ${log['latitude']}'),
          Text('Longitude: ${log['longitude']}'),
          Text('Date Collected: ${formattedDate}'),
          // Add more Text widgets or other widgets to display the log data
        ],
      ),
    );
  }

  Widget _buildLogContainer(Map<String, dynamic> log, int index) {
    final date = DateTime.parse(log['date_collected']);
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);

    return Container(
      // Customize the container's appearance as needed
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ExpansionPanelList(
        elevation: 1,
        expandedHeaderPadding: EdgeInsets.zero,
        expansionCallback: (int panelIndex, bool isExpanded) {
          setState(() {
            _isExpandedList[index] = !isExpanded;
          });
        },
        children: [
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                    'Farm Name: ${log['farm__name']}, Parcel: ${log['parcel']}'),
              );
            },
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Moisture: ${log['moisture']}'),
                Text('Phosphorus: ${log['phosphorus']}'),
                Text('Potassium: ${log['potassium']}'),
                Text('Nitrogen: ${log['nitrogen']}'),
                Text('Temperature: ${log['temperature']}'),
                Text('pH: ${log['ph']}'),
                Text('Latitude: ${log['latitude']}'),
                Text('Longitude: ${log['longitude']}'),
                Text('Date Collected: $formattedDate'),
                // Add more Text widgets or other widgets to display the log data
              ],
            ),
            isExpanded: _isExpandedList[index],
          ),
        ],
      ),
    );
  }

  Future<void> getLogData(String selectedFarm) async {
    final Uri $url =
        Uri.parse('${GENERAL_URL}app/reports/get_logs/${selectedFarm}');
    final response = await http.get($url);

    if (response.statusCode == 200) {
      setState(() {
        logs = json.decode(response.body);
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
      for (dynamic n in data) {
        farms.add(Farm(name: n[0], id: n[1].toString()));
      }
      selectedFarm = farms[0].id;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Temperature report failed to load. Please try again.'),
        ),
      );
    }
  }
}
