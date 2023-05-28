import 'dart:ffi';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';

part 'farm_data.g.dart';

abstract class FarmReportData implements Built<FarmReportData, FarmReportDataBuilder> {
  double get moisture;
  double get phosphorus;
  double get potassium;
  double get nitrogen;
  double get temperature;
  double get ph;

  FarmReportData._();

  factory FarmReportData([updates(FarmReportDataBuilder b)]) = _$FarmReportData;

  static Serializer<FarmReportData> get serializer => _$farmReportDataSerializer;
}

abstract class FarmData implements Built<FarmData, FarmDataBuilder> {

  int get id;
  String get created_at;
  String get updated_at;
  int get is_active;
  String get name;
  double get area;
  int get owner;
  FarmReportData? get latest_farm_report;
  FarmData._();

  factory FarmData([updates(FarmDataBuilder b)]) = _$FarmData;

  static Serializer<FarmData> get serializer => _$farmDataSerializer;
}