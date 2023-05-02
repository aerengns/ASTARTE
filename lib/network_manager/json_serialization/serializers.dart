import 'package:astarte/network_manager/services/posts_service.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

import '../models/sensor_data.dart';

part 'serializers.g.dart';

@SerializersFor(const [SensorData, PostsService])
final Serializers serializers = (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
