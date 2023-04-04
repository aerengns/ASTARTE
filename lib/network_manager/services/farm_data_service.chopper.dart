// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farm_data_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$FarmDataService extends FarmDataService {
  _$FarmDataService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = FarmDataService;

  @override
  Future<Response<dynamic>> getFarmDataDetail() {
    final Uri $url = Uri.parse('/farms');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getFarmData(int farmId) {
    final Uri $url = Uri.parse('/farms/${farmId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
