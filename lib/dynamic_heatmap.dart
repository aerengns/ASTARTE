import 'dart:math';

import 'package:fl_heatmap/fl_heatmap.dart';
import 'package:flutter/material.dart';
import 'package:astarte/utils/dynamic_heatmap_utils.dart';

import 'package:astarte/sidebar.dart';

const List<Color> colorPalettePH = [
  Color.fromRGBO(255, 109, 109, 1),
  Color.fromRGBO(255, 153, 154, 1),
  Color.fromRGBO(255, 197, 196, 1),
  Color.fromRGBO(200, 199, 255, 1),
  Color.fromRGBO(120, 119, 255, 1),
  Color.fromRGBO(41, 40, 255, 1),
];

bool isExist(List<List<int>> sensorLocations, List<int> currLocation) {
  for (int i = 0; i < sensorLocations.length; i++) {
    if (sensorLocations[i][0] == currLocation[0] &&
        sensorLocations[i][1] == currLocation[1]) return true;
  }
  return false;
}

class HeatmapPage extends StatefulWidget {
  HeatmapPage({Key? key, required this.farmId}) : super(key: key);

  int farmId;
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
    dynamic_heatmap = _initExampleData('moisture');
    super.initState();
  }

  Widget _initExampleData(String heatmapType) {
    HeatmapData heatmapDataPower;
    return FutureBuilder<DynamicHeatmap>(
      future: getHeatmapData(heatmapType, widget.farmId),
      builder: (context, snapshot) {
        List<String> rows;
        List<String> columns;
        List<double> values;
        List<List<int>> sensor_locations;

        String unit = heatmapType;
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
                  value:
                      values[(rows.length - 1 - row) * columns.length + col] /
                          10,
                  style: isExist(sensor_locations, current_location)
                      ? HeatmapItemStyle.hatched
                      : HeatmapItemStyle.filled,
                  unit: unit,
                  xAxisLabel: columns[col],
                  yAxisLabel: rows[row]));
            }
          }
        }
        List<Color> color = colorPaletteBlue;
        if (heatmapType == 'moisture')
          color = colorPaletteBlue;
        else if (heatmapType == 'n')
          color = colorPaletteGreen;
        else if (heatmapType == 'p')
          color = colorPaletteRed;
        else if (heatmapType == 'k')
          color = colorPaletteDeepOrange;
        else if (heatmapType == 'temperature')
          color = colorPaletteTemperature;
        else if (heatmapType == 'ph') color = colorPalettePH;

        heatmapDataPower = HeatmapData(
          rows: rows,
          columns: columns,
          radius: 1,
          items: items,
          colorPalette: color,
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
        ? '${(selectedItem!.value * 100).toStringAsFixed(2)} ${selectedItem!.unit}'
        : '---';
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Background color
                foregroundColor: Colors.white, // Text color
                padding: const EdgeInsets.symmetric(
                    horizontal: 5, vertical: 5), // Button padding
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10), // Button border radius
                ),
              ),
              child: const Text("Change View"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      dynamic_heatmap = _initExampleData('moisture');
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Background color
                    foregroundColor: Colors.blue, // Text color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10), // Button padding
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Button border radius
                    ),
                  ),
                  child: Text("moisture"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      dynamic_heatmap = _initExampleData('n');
                      isTrue = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Background color
                    foregroundColor: Colors.green, // Text color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10), // Button padding
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Button border radius
                    ),
                  ),
                  child: Text("n"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      dynamic_heatmap = _initExampleData('p');
                      isTrue = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Background color
                    foregroundColor: Colors.red, // Text color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10), // Button padding
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Button border radius
                    ),
                  ),
                  child: Text("p"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      dynamic_heatmap = _initExampleData('k');
                      isTrue = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Background color
                    foregroundColor: Colors.orange, // Text color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10), // Button padding
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Button border radius
                    ),
                  ),
                  child: Text("k"),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      dynamic_heatmap = _initExampleData('temperature');
                      isTrue = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Background color
                    foregroundColor:
                        Color.fromARGB(255, 75, 21, 2), // Text color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10), // Button padding
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Button border radius
                    ),
                  ),
                  child: Text("temperature"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      dynamic_heatmap = _initExampleData('ph');
                      isTrue = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Background color
                    foregroundColor: Colors.purple, // Text color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10), // Button padding
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Button border radius
                    ),
                  ),
                  child: Text("ph"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
