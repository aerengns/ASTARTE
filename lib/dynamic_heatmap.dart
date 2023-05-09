import 'dart:math';

import 'package:fl_heatmap/fl_heatmap.dart';
import 'package:flutter/material.dart';
import 'package:astarte/utils/dynamic_heatmap_utils.dart';

import 'package:astarte/sidebar.dart';

bool isExist(List<List<int>> sensorLocations, List<int> currLocation) {
  for (int i = 0; i < sensorLocations.length; i++) {
    if (sensorLocations[i][0] == currLocation[0] &&
        sensorLocations[i][1] == currLocation[1]) return true;
  }
  return false;
}

class HeatmapPage extends StatefulWidget {
  const HeatmapPage({Key? key}) : super(key: key);

  @override
  State<HeatmapPage> createState() => _DynamicHeatmapState();
}

class _DynamicHeatmapState extends State<HeatmapPage> {
  HeatmapItem? selectedItem;
  bool isTrue = true;

  late Widget dynamic_heatmap;
  late Image heatmap_image;

  @override
  void initState() {
    dynamic_heatmap = _initExampleData();
    super.initState();
  }

  Widget _initExampleData() {
    HeatmapData heatmapDataPower;
    return FutureBuilder<DynamicHeatmap>(
      future: getHeatmapData(),
      builder: (context, snapshot) {
        List<String> rows;
        List<String> columns;
        List<double> values;
        List<List<int>> sensor_locations;

        const String unit = 'moisture';
        List<int> current_location;
        final List<HeatmapItem> items = [];

        DynamicHeatmap? hmap = snapshot.data;

        if (snapshot.hasData) {
          rows = hmap!.rows;
          columns = hmap.columns;
          values = hmap.items;
          sensor_locations = hmap.sensor_locations;
          heatmap_image = hmap.heatmap_image;
        } else {
          heatmap_image = Image.asset(
            'assets/icons/launcher_icon.png',
            fit: BoxFit.cover,
          );
          return Placeholder();
        }

        for (int row = 0; row < rows.length; row++) {
          for (int col = 0; col < columns.length; col++) {
            current_location = [col, (rows.length - 1 - row)];
            if (!(values[(rows.length - 1 - row) * columns.length + col] ==
                0)) {
              items.add(HeatmapItem(
                  value: values[(rows.length - 1 - row) * columns.length + col],
                  style: isExist(sensor_locations, current_location)
                      ? HeatmapItemStyle.hatched
                      : HeatmapItemStyle.filled,
                  unit: unit,
                  xAxisLabel: columns[col],
                  yAxisLabel: rows[row]));
            }
          }
        }

        heatmapDataPower = HeatmapData(
          rows: rows,
          columns: columns,
          radius: 1,
          items: items,
          colorPalette: colorPaletteBlue,
        );

        return Heatmap(
            onItemSelectedListener: (HeatmapItem? selectedItem) {
              debugPrint(
                  'Item ${selectedItem?.yAxisLabel}/${selectedItem?.xAxisLabel} with value ${selectedItem?.value} selected');
              setState(() {
                this.selectedItem = selectedItem;
              });
            },
            heatmapData: heatmapDataPower);
      },
    );
  }

  void _switchImage() {
    setState(() {
      isTrue = !isTrue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = selectedItem != null
        ? '${(selectedItem!.value * (100 / 9)).toStringAsFixed(2)} ${selectedItem!.unit}'
        : '--- moisture';
    final subtitle = selectedItem != null
        ? '${selectedItem!.xAxisLabel} ${selectedItem!.yAxisLabel}'
        : '---';
    return Scaffold(
      appBar: const AstarteAppBar(title: 'Dynamic Heatmap'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(title, textScaleFactor: 1.4),
            Text(subtitle),
            const SizedBox(height: 8),
            isTrue ? dynamic_heatmap : heatmap_image,
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _switchImage,
              child: Text("Switch"),
            ),
          ],
        ),
      ),
      drawer: NavBar(context),
    );
  }
}
