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
  final List items;

  DynamicHeatmap(
      {required this.rows, required this.columns, required this.items});
}

Future<DynamicHeatmap> getHeatmapData() async {
  try {
    var headers = {
      'Authorization': 'Bearer ' "token",
    };
    // your endpoint and request method
    var request = http.MultipartRequest(
        'GET', Uri.parse('127.0.0.1:8000/api/v1/get_heatmap/'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String newMessage = await response.stream.bytesToString();
      dynamic data = jsonDecode(newMessage);

      DynamicHeatmap result = DynamicHeatmap(
          rows: data['rows'], columns: data['columns'], items: data['items']);

      return result;
    } else {
      print(response.reasonPhrase);
      return DynamicHeatmap(rows: [], columns: [], items: []);
    }
  } catch (e) {
    print(e);
    return DynamicHeatmap(rows: [], columns: [], items: []);
  }
}
