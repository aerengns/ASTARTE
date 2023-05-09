import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'calendar_utils.dart';

class DynamicHeatmap {
  final List<String> rows;
  final List<String> columns;
  final List<double> items;
  final List<List<int>> sensor_locations;
  final Image heatmap_image;

  DynamicHeatmap({
    required this.rows,
    required this.columns,
    required this.items,
    required this.sensor_locations,
    required this.heatmap_image,
  });
}

Future<DynamicHeatmap> getHeatmapData() async {
  try {
    var headers = {
      'Authorization': 'Bearer ' "token",
    };
    // your endpoint and request method
    var request = http.MultipartRequest(
        'GET', Uri.parse('http://127.0.0.1:8000/api/v1/get_heatmap/'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String newMessage = await response.stream.bytesToString();
      dynamic data = jsonDecode(newMessage);

      List<List<int>> sensor_locs_temp = [];
      List<int> locs_temp = [];
      for (int i = 0; i < data['sensor_locations'].length; i++) {
        locs_temp = [];
        for (int j = 0; j < 2; j++) {
          locs_temp.add(data['sensor_locations'][i][j]);
        }
        sensor_locs_temp.add(locs_temp);
      }

      final String encodedImage = data['heatmap_image'];
      final Uint8List decodedImage = base64.decode(encodedImage);

      DynamicHeatmap result = DynamicHeatmap(
          rows: List<String>.from(data['rows']),
          columns: List<String>.from(data['columns']),
          items: List<double>.from(data['items']),
          sensor_locations: sensor_locs_temp,
          heatmap_image: Image.memory(
            decodedImage,
            fit: BoxFit.cover,
          ));

      return result;
    } else {
      print(response.reasonPhrase);
      return DynamicHeatmap(
        rows: ['5'],
        columns: ['10'],
        items: [10],
        sensor_locations: [
          [0, 0]
        ],
        heatmap_image: Image.asset(
          'assets/icons/launcher_icon.png',
          fit: BoxFit.cover,
        ),
      );
    }
  } catch (e) {
    print(e);
    return DynamicHeatmap(
      rows: ['5'],
      columns: ['5', '10'],
      items: [10, 15],
      sensor_locations: [
        [0, 0]
      ],
      heatmap_image: Image.asset(
        'assets/icons/launcher_icon.png',
        fit: BoxFit.cover,
      ),
    );
  }
}
