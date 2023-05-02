import 'dart:io';

import 'package:astarte/network_manager/models/sensor_data.dart';
import 'package:chopper/chopper.dart';
import 'package:built_collection/built_collection.dart';
import 'package:astarte/network_manager/model_converters/built_value_converter.dart';

part "posts_service.chopper.dart";

@ChopperApi(baseUrl: "/posts")
abstract class PostsService extends ChopperService {

  @Get()
  Future<Response> getPosts();

  @Post(path: '/new_post')
  Future<Response> createPost(
      @Body() String postText,
      @Field() File? image,
      );

  static PostsService create() {
    final client = ChopperClient(
        baseUrl: Uri.parse('https://astarte.pythonanywhere.com/api/v1'),
        services: [
          _$PostsService(),
        ],
        converter: BuiltValueConverter(),
        interceptors: [
          HttpLoggingInterceptor(),
        ]
    );
    return _$PostsService(client);
  }
}