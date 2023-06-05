import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';

part 'custom_event.g.dart';

abstract class CustomEvent implements Built<CustomEvent, CustomEventBuilder> {

  int? get id;
  String get description;
  String get date;

  CustomEvent._();

  factory CustomEvent([updates(CustomEventBuilder b)]) = _$CustomEvent;

  static Serializer<CustomEvent> get serializer => _$customEventSerializer;
}
