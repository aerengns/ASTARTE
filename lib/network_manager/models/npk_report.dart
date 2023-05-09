import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';

part 'npk_report.g.dart';

abstract class NpkReport implements Built<NpkReport, NpkReportBuilder> {

  List<int> get days;
  List<int> get n_values;
  List<int> get p_values;
  List<int> get k_values;

  NpkReport._();

  factory NpkReport([updates(NpkReportBuilder b)]) = _$NpkReport;

  static Serializer<NpkReport> get serializer => _$npkReportSerializer;
}
