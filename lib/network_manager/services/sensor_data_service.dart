import 'package:astarte/network_manager/models/sensor_data.dart';
import 'package:astarte/network_manager/models/temperature_report.dart';
import 'package:astarte/utils/parameters.dart';
import 'package:chopper/chopper.dart';
import 'package:built_collection/built_collection.dart';
import 'package:astarte/network_manager/model_converters/built_value_converter.dart';
import 'package:astarte/utils/parameters.dart';

part "sensor_data_service.chopper.dart";

@ChopperApi(baseUrl: "/reports")
abstract class SensorDataService extends ChopperService {
  @Get()
  Future<Response<BuiltList<SensorData>>> getSensorData();

  @Get(path: '/{name}')
  Future<Response<SensorData>> getFarmSensorData(@Path('name') String farmName);

  @Post()
  Future<Response> saveSensorData(@Body() SensorData data);

  @Get(path: '/temperature_report')
  Future<Response> getTemperatureReport();

  @Get(path: '/npk_report')
  Future<Response> getNpkReport();

  @Get(path: '/humidity_report')
  Future<Response> getHumidityReport();

  static SensorDataService create() {
    final client = ChopperClient(
        baseUrl: Uri.parse('${GENERAL_URL}app/'),
        services: [
          _$SensorDataService(),
        ],
        converter: BuiltValueConverter(),
        interceptors: [
          HeadersInterceptor({'Authorization': TOKEN}),
          HttpLoggingInterceptor(),
        ]);
    return _$SensorDataService(client);
  }
}
