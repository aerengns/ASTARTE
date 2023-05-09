import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';

part 'humidity_report.g.dart';

abstract class HumidityReport implements Built<HumidityReport, HumidityReportBuilder> {

  List<int> get days;
  List<int> get humidity_levels;

  HumidityReport._();

  factory HumidityReport([updates(HumidityReportBuilder b)]) = _$HumidityReport;

  static Serializer<HumidityReport> get serializer => _$humidityReportSerializer;
}
