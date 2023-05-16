import 'dart:io';

import 'package:astarte/network_manager/models/post.dart';
import 'package:astarte/utils/parameters.dart';
import 'package:chopper/chopper.dart';
import 'package:built_collection/built_collection.dart';
import 'package:astarte/network_manager/model_converters/built_value_converter.dart';

part "posts_service.chopper.dart";

@ChopperApi(baseUrl: "/posts")
abstract class PostsService extends ChopperService {

  @Get()
  Future<Response<BuiltList<PostData>>> getPosts();

  @Post(path: '/new_post')
  Future<Response> createPost(
      @Body() PostData data
      );

  @Get(path: '/reply/{post_id}')
  Future<Response<BuiltList<PostData>>> getReplies(@Path('post_id') int postId);

  @Post(path: '/reply/{post_id}')
  Future<Response> createReply(
      @Path('post_id') int postId,
      @Body() PostData data
      );

  static PostsService create() {
    final client = ChopperClient(
        baseUrl: Uri.parse('${GENERAL_URL}app/'),
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