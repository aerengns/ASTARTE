import 'package:astarte/network_manager/services/sensor_data_service.dart';
import 'package:astarte/utils/reports_util.dart';
import 'package:astarte/utils/date_filter.dart';
import 'package:astarte/utils/farm_selection_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:astarte/sidebar.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:provider/provider.dart';

class TemperatureReport extends StatefulWidget {
  const TemperatureReport({Key? key}) : super(key: key);
  @override
  State<TemperatureReport> createState() => _TemperatureReportsState();
}

class _TemperatureReportsState extends State<TemperatureReport> {
  List<double> data_y = [];
  String data_x = "";
  List<Farm> farms = [];
  String selectedFarm = "";
  DateTime selectedStartDate = DateTime.now().subtract(Duration(days: 1));
  DateTime selectedEndDate = DateTime.now();
  DateTime? _startDate;
  DateTime? _endDate;

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
        title: 'Temperature Report',
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
            if (selectedFarm != "") {
              getTemperatureData(selectedFarm)
                  .whenComplete(() => _addTemperatureValueContainer());
            }
          });
        },
        onEndDateSelected: (date) {
          setState(() {
            selectedEndDate = date;
            if (selectedFarm != "") {
              getTemperatureData(selectedFarm)
                  .whenComplete(() => _addTemperatureValueContainer());
            }
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
            getTemperatureData(selectedFarm)
                .whenComplete(() => _addTemperatureValueContainer());
          });
        },
      ));
    });
  }

  void _addTemperatureValueContainer() {
    setState(() {
      // Remove the old report container if it exists
      _widgets.removeWhere((widget) =>
          widget is SizedBox && widget.width == 450 && widget.height == 300);
      _widgets.add(
        SizedBox(
          width: 450,
          height: 300,
          child: Echarts(
            option: '''
              {
                height: 200,
                width: 300,
                title: {
                  text: 'Past Temperature Values',
                  left: 'left',
                  top: 'top'
                },
                xAxis: {
                  type: 'category',
                  data: ${data_x},
                },
                yAxis: {
                  type: 'value',
                },
                tooltip: {
                  trigger: 'axis', // Show tooltip when the user touches data points
                  formatter: '{b}: {c}', // Display the name and value of the data point
                },
                series: [{
                  data:  ${data_y},
                  type: 'line'
                }]
              }
            ''',
          ),
        ),
      );
    });
  }

  Future<void> getTemperatureData(String selectedFarm) async {
    final startDate = selectedStartDate != null
        ? DateFormat('yyyy-MM-dd').format(selectedStartDate!)
        : '';
    final endDate = selectedEndDate != null
        ? DateFormat('yyyy-MM-dd').format(selectedEndDate!)
        : '';
    final response =
        await Provider.of<SensorDataService>(context, listen: false)
            .getTemperatureReport(selectedFarm, startDate, endDate);

    if (response.isSuccessful) {
      String new_message = await response.bodyString;
      dynamic data = jsonDecode(new_message);

      data_x = jsonEncode(data['days']);
      data_y.clear();
      for (dynamic temperature in data['temperatures']) {
        data_y.add(temperature as double);
      }
    } else {}
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
          content: Text('Farm filling failed to load. Please try again.'),
        ),
      );
    }
  }
}
