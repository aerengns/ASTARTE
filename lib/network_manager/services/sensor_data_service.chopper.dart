// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_data_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$SensorDataService extends SensorDataService {
  _$SensorDataService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = SensorDataService;

  @override
  Future<Response<BuiltList<SensorData>>> getSensorData() {
    final Uri $url = Uri.parse('/reports');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<BuiltList<SensorData>, SensorData>($request);
  }

  @override
  Future<Response<SensorData>> getFarmSensorData(String farmName) {
    final Uri $url = Uri.parse('/reports/${farmName}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<SensorData, SensorData>($request);
  }

  @override
  Future<Response<dynamic>> saveSensorData(SensorData data) {
    final Uri $url = Uri.parse('/reports');
    final $body = data;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getTemperatureReport(
      String selectedFarm, String startDate, String endDate) {
    final Uri $url = Uri.parse(
        '/reports/temperature_report/${selectedFarm}?start_date=$startDate&end_date=$endDate');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getPHReport(
      String selectedFarm, String startDate, String endDate) {
    final Uri $url = Uri.parse(
        '/reports/ph_report/${selectedFarm}?start_date=$startDate&end_date=$endDate');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getNpkReport(
      String selectedFarm, String startDate, String endDate) {
    final Uri $url = Uri.parse(
        '/reports/npk_report/${selectedFarm}?start_date=$startDate&end_date=$endDate');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getHumidityReport(
      String selectedFarm, String startDate, String endDate) {
    final Uri $url = Uri.parse(
        '/reports/humidity_report/${selectedFarm}?start_date=$startDate&end_date=$endDate');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getFarmList() {
    final Uri $url = Uri.parse('/reports/get_farms');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getLogData(
      String selectedFarm, String startDate, String endDate) {
    final Uri $url = Uri.parse(
        '/reports/get_logs/${selectedFarm}?start_date=$startDate&end_date=$endDate');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
