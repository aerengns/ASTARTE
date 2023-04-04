import 'package:astarte/network_manager/models/farm_data.dart';
import 'package:chopper/chopper.dart';
import 'package:built_collection/built_collection.dart';
import 'package:astarte/network_manager/model_converters/built_value_converter.dart';


part "farm_data_service.chopper.dart";

@ChopperApi(baseUrl: "/farms")
abstract class FarmDataService extends ChopperService {

  @Get()
  Future<Response<BuiltList<FarmData>>> getFarmDataDetail();

  @Get(path: '/{farm_id}')
  Future<Response<FarmData>> getFarmData(@Path('farm_id') int farmId);

  //@Post()
  //Future<Response> saveSensorData(
  //    @Body() SensorData data
  //    );

  static FarmDataService create() {
    final client = ChopperClient(
        baseUrl: Uri.parse('http://127.0.0.1:8000/api/v1'),
        services: [
          _$FarmDataService(),
        ],
        converter: BuiltValueConverter(),
        interceptors: [
          HeadersInterceptor({'Authorization': 'Token ff87098fc547674d2c69361042b8504c573c5d4a'}),
          HttpLoggingInterceptor(),
        ]
    );
    return _$FarmDataService(client);
  }
}