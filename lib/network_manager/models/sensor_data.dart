import 'dart:ffi';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';

part 'sensor_data.g.dart';

abstract class SensorData implements Built<SensorData, SensorDataBuilder> {
  String get farmName;
  String get formDate;
  double get parcelNo;
  double get temperature;
  double get moisture;
  double get phosphorus;
  double get potassium;
  double get nitrogen;
  double get ph;
  double get latitude;
  double get longitude;

  SensorData._();

  factory SensorData([updates(SensorDataBuilder b)]) = _$SensorData;

  static Serializer<SensorData> get serializer => _$sensorDataSerializer;
}
