import 'dart:ffi';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';

part 'farm_data.g.dart';

abstract class FarmData implements Built<FarmData, FarmDataBuilder> {

  int get id;
  String get created_at;
  String get updated_at;
  int get is_active;
  String get name;
  double get area;
  int get owner;
  FarmData._();

  factory FarmData([updates(FarmDataBuilder b)]) = _$FarmData;

  static Serializer<FarmData> get serializer => _$farmDataSerializer;
}