import 'package:astarte/sign_in.dart';
import 'package:json_annotation/json_annotation.dart';

// command to generate the file: flutter pub run build_runner build
part 'hello.g.dart';

@JsonSerializable()
class Hello {
  String message;

  Hello({required this.message});

  factory Hello.fromJson(Map<String, dynamic> json) => _$HelloFromJson(json);

  Map<String, dynamic> toJson() => _$HelloToJson(this);
}