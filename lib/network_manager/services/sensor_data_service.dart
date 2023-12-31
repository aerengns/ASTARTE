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

  @Post(path: '/{farm_id}')
  Future<Response> saveSensorData(@Body() SensorData data, @Path('farm_id') int farmId);

  @Get(
      path:
          '/temperature_report/{farm}?start_date={startDate}&end_date={endDate}')
  Future<Response> getTemperatureReport(@Path('farm') String selectedFarm,
      @Path('startDate') String startDate, @Path('endDate') String endDate);

  @Get(path: '/ph_report/{farm}?start_date={startDate}&end_date={endDate}')
  Future<Response> getPHReport(@Path('farm') String selectedFarm,
      @Path('startDate') String startDate, @Path('endDate') String endDate);

  @Get(path: '/npk_report/{farm}?start_date={startDate}&end_date={endDate}')
  Future<Response> getNpkReport(@Path('farm') String selectedFarm,
      @Path('startDate') String startDate, @Path('endDate') String endDate);

  @Get(
      path: '/humidity_report/{farm}?start_date={startDate}&end_date={endDate}')
  Future<Response> getHumidityReport(@Path('farm') String selectedFarm,
      @Path('startDate') String startDate, @Path('endDate') String endDate);

  @Get(path: '/get_farms')
  Future<Response> getFarmList();

  @Get(path: '/get_logs/{farm}?start_date={startDate}&end_date={endDate}')
  Future<Response> getLogData(@Path('farm') String selectedFarm,
      @Path('startDate') String startDate, @Path('endDate') String endDate);

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
