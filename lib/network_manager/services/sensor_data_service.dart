import "dart:async";
import 'package:chopper/chopper.dart';

part "sensor_data_service.chopper.dart";

@ChopperApi(baseUrl: "/reports")
abstract class SensorDataService extends ChopperService {

  @Get()
  Future<Response> getSensorData();

  @Get(path: '/{name}')
  Future<Response> getFarmSensorData(@Path('name') String farmName);

  @Post()
  Future<Response> saveSensorData(
      @Body() Map<String, dynamic> data
      );

  static SensorDataService create() {
    final client = ChopperClient(
        baseUrl: Uri.parse('https://astarte.pythonanywhere.com/api/v1'),
        services: [
          _$SensorDataService(),
        ],
        converter: JsonConverter(),
    );
    return _$SensorDataService(client);
  }
}