import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

import '../models/sensor_data.dart';
import '../models/farm_data.dart';

part 'serializers.g.dart';

@SerializersFor(const [SensorData, FarmData])
final Serializers serializers = (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
