import 'dart:ffi';
import 'dart:math';

import 'package:fl_heatmap/fl_heatmap.dart';
import 'package:flutter/material.dart';
import 'package:astarte/utils/dynamic_heatmap_utils.dart';

import 'package:astarte/sidebar.dart';

const List<Color> colorPalettePH = [
  // Color(0xff0000ff),
  // Color(0xFF3300FF),
  Color(0xFF6600FF),
  Color(0xFFCC00FF),
  Color(0xCCFF00FF),
  Color(0x66FF00FF),
  Color(0x33FF00FF),
  Color(0x00FF33FF),
];

bool isPlaceholderWidget(Widget widget) {
  return widget.runtimeType == Placeholder;
}

bool isExist(List<List<int>> sensorLocations, List<int> currLocation) {
  for (int i = 0; i < sensorLocations.length; i++) {
    if (sensorLocations[i][1] == currLocation[0] &&
        sensorLocations[i][0] == currLocation[1]) return true;
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
  List<Widget> allHeatmaps = [];
  int currentIndex = 0;
  late Image heatmap_image;
  Widget? dynHmap;
  double multCoefficient = 100;
  double sumValue = 0;
  List<String> heatmapTypes = ['moisture', 'n', 'p', 'k', 'temperature', 'ph'];
  String? heatmapType;

  @override
  void initState() {
    for (heatmapType in heatmapTypes) {
      dynHmap = _initExampleData(heatmapType!);
      allHeatmaps.add(dynHmap!);
    }
    dynamic_heatmap = allHeatmaps[currentIndex];
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
          return const Placeholder();
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
        List<Color>? color = colorPaletteBlue;
        if (heatmapType == 'moisture') {
          color = colorPaletteBlue;
          multCoefficient = 100;
          sumValue = 0;
        } else if (heatmapType == 'n') {
          color = colorPaletteGreen;
          multCoefficient = 2000;
          sumValue = 0;
        } else if (heatmapType == 'p') {
          color = colorPaletteRed;
          multCoefficient = 2000;
          sumValue = 0;
        } else if (heatmapType == 'k') {
          color = colorPaletteDeepOrange;
          multCoefficient = 2000;
          sumValue = 0;
        } else if (heatmapType == 'temperature') {
          color = colorPaletteRed;
          multCoefficient = 120;
          sumValue = -40;
        } else if (heatmapType == 'ph') {
          color = colorPalettePH;
          multCoefficient = 6;
          sumValue = 3;
        }

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
        ? '${(selectedItem!.value * multCoefficient + sumValue).toStringAsFixed(2)} ${selectedItem!.unit}'
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
              onPressed: () {
                setState(() {
                  isTrue = !isTrue;
                });
                dynamic_heatmap = allHeatmaps[currentIndex];
              },
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
                    currentIndex = 0;
                    dynamic_heatmap = allHeatmaps[currentIndex];
                    setState(() {
                      isTrue = true;
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
                    currentIndex = 1;
                    dynamic_heatmap = allHeatmaps[currentIndex];
                    setState(() {
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
                    currentIndex = 2;
                    dynamic_heatmap = allHeatmaps[currentIndex];
                    setState(() {
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
                    currentIndex = 3;
                    dynamic_heatmap = allHeatmaps[currentIndex];
                    setState(() {
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
                    currentIndex = 4;
                    dynamic_heatmap = allHeatmaps[currentIndex];
                    setState(() {
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
                    currentIndex = 5;
                    dynamic_heatmap = allHeatmaps[currentIndex];
                    setState(() {
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
