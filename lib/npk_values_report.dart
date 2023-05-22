import 'package:astarte/network_manager/services/sensor_data_service.dart';
import 'package:astarte/utils/date_filter.dart';
import 'package:astarte/utils/farm_selection_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:astarte/sidebar.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'dart:convert';
import 'package:astarte/utils/reports_util.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

class NPKReport extends StatefulWidget {
  NPKReport({Key? key}) : super(key: key);
  @override
  State<NPKReport> createState() => _NPKReportsState();
}

class _NPKReportsState extends State<NPKReport> {
  List<double> data_n = [];
  List<double> data_p = [];
  List<double> data_k = [];
  String data_x = "";
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
        title: 'NPK Report',
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
              getNData(selectedFarm).whenComplete(() => _addNValueContainer());
            }
          });
        },
        onEndDateSelected: (date) {
          setState(() {
            selectedEndDate = date;
            if (selectedFarm != "") {
              getNData(selectedFarm).whenComplete(() => _addNValueContainer());
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
            getNData(selectedFarm).whenComplete(() => _addNValueContainer());
          });
        },
      ));
    });
  }

  void _addNValueContainer() {
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
                  text: 'Past NPK Values',
                },
                xAxis: {
                  type: 'category',
                  data: $data_x,
                },
                yAxis: [{
                  type: 'value',
                },
                {
                  type: 'value',
                },
                {
                  type: 'value',
                }],
                legend: {
                  show: true,
                  padding: 30,
                },
                tooltip: {
                  trigger: 'axis',
                  formatter: function(params) {
                    var tooltip = '';
                    for (var i = 0; i < params.length; i++) {
                      var param = params[i];
                      tooltip += param.seriesName + ': ' + param.value + '<br>';
                    }
                    return tooltip;
                  }
                },
                series: [						
                  {
                    name: 'n',
                    type:'line',
                    itemStyle: {
                      normal: {
                        color: 'rgb(125, 10, 10)'
                      }
                    },
                    data: $data_n,
                  },	
                  {
                    name: 'p',
                    type:'line',
                    itemStyle: {
                      normal: {
                        color: 'rgb(125, 125, 10)'
                      }
                    },
                    data: $data_p,
                  },
                  {
                    name: 'k',
                    type:'line',
                    itemStyle: {
                      normal: {
                        color: 'rgb(125, 125, 125)'
                      }
                    },
                    data: $data_k,
                  },	
                ],
              }
            ''',
          ),
        ),
      );
    });
  }

  Future<void> getNData(String selectedFarm) async {
    final startDate = selectedStartDate != null
        ? DateFormat('yyyy-MM-dd').format(selectedStartDate!)
        : '';
    final endDate = selectedEndDate != null
        ? DateFormat('yyyy-MM-dd').format(selectedEndDate!)
        : '';
    final response =
        await Provider.of<SensorDataService>(context, listen: false)
            .getNpkReport(selectedFarm, startDate, endDate);

    if (response.isSuccessful) {
      String new_message = await response.bodyString;
      dynamic data = jsonDecode(new_message);
      data_n.clear();
      data_p.clear();
      data_k.clear();
      data_x = jsonEncode(data['days']);
      for (dynamic n in data['n_values']) {
        data_n.add(n as double);
      }
      for (dynamic n in data['p_values']) {
        data_p.add(n as double);
      }
      for (dynamic n in data['k_values']) {
        data_k.add(n as double);
      }
    } else {
      /*ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('NPK report failed to load. Please try again.'),
        ),
      );*/
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
          content: Text('Farm filling failed to load. Please try again.'),
        ),
      );
    }
  }
}
