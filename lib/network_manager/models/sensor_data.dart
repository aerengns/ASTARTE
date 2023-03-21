import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';

// command to generate the file: flutter pub run build_runner build
part 'sensor_data.g.dart';

@JsonSerializable()
class SensorData {
  String farmName;
  String formDate;
  Float moisture;
  Float phosphorus;
  Float potassium;
  Float nitrogen;

  SensorData({required this.farmName, required this.formDate, required this.moisture,
    required this.phosphorus, required this.potassium, required this.nitrogen});

  factory SensorData.fromJson(Map<String, dynamic> json) => _$SensorDataFromJson(json);

  Map<String, dynamic> toJson() => _$SensorDataToJson(this);
}