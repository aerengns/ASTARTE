import 'package:astarte/network_manager/models/custom_event.dart';
import 'package:astarte/network_manager/models/farm.dart';
import 'package:astarte/network_manager/models/post.dart';
import 'package:astarte/network_manager/models/npk_report.dart';
import 'package:astarte/network_manager/models/humidity_report.dart';
import 'package:astarte/network_manager/models/temperature_report.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_collection/built_collection.dart';
import 'dart:core';
import 'dart:convert';
import '../models/sensor_data.dart';
import '../models/farm_data.dart';

part 'serializers.g.dart';

@SerializersFor(const [
  SensorData,
  TemperatureReport,
  NpkReport,
  HumidityReport,
  PostData,
  FarmData,
  CustomEvent,
  Farm,
])

final Serializers serializers = (_$serializers.toBuilder()
  ..addBuilderFactory(
    const FullType(BuiltList, [FullType(CornerPoint)]),
        () => ListBuilder<CornerPoint>(),
  )..addPlugin(StandardJsonPlugin()))
    .build();

