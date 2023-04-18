import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';

part 'temperature_report.g.dart';

abstract class TemperatureReport implements Built<TemperatureReport, TemperatureReportBuilder> {

  List<int> get days;
  List<int> get temperatures;

  TemperatureReport._();

  factory TemperatureReport([updates(TemperatureReportBuilder b)]) = _$TemperatureReport;

  static Serializer<TemperatureReport> get serializer => _$temperatureReportSerializer;
}
