import 'dart:io';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';

part 'post.g.dart';

abstract class Post implements Built<Post, PostBuilder> {

  File? get image;
  String get postText;

  Post._();

  factory Post([updates(PostBuilder b)]) = _$Post;

  static Serializer<Post> get serializer => _$postSerializer;
}