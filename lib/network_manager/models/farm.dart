
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'farm.g.dart';

abstract class CornerPoint implements Built<CornerPoint, CornerPointBuilder> {
  double get latitude;
  double get longitude;

  CornerPoint._();

  factory CornerPoint([updates(CornerPointBuilder b)]) = _$CornerPoint;

  static Serializer<CornerPoint> get serializer => _$cornerPointSerializer;
}

abstract class Farm implements Built<Farm, FarmBuilder> {
  String get name;
  BuiltList<CornerPoint> get cornerPoints;

  Farm._();

  factory Farm([void Function(FarmBuilder) updates]) = _$Farm;

  static Serializer<Farm> get serializer => _$farmSerializer;
}
