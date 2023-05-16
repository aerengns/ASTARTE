import 'dart:io';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';

part 'post.g.dart';

abstract class PostData implements Built<PostData, PostDataBuilder> {

  int? get id;
  String? get image;
  String get message;

  PostData._();

  factory PostData([updates(PostDataBuilder b)]) = _$PostData;

  static Serializer<PostData> get serializer => _$postDataSerializer;
}
