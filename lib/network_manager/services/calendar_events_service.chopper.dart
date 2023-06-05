// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_events_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$CalendarEventsService extends CalendarEventsService {
  _$CalendarEventsService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = CalendarEventsService;

  @override
  Future<Response<BuiltList<CustomEvent>>> getCalendarData(String date) {
    final Uri $url = Uri.parse('/create_event');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<BuiltList<CustomEvent>, CustomEvent>($request);
  }

  @override
  Future<Response<dynamic>> createCustomEvent(CustomEvent event) {
    final Uri $url = Uri.parse('/create_event');
    final $body = event;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getActivityLogData(
    String selectedFarm,
    String startDate,
    String endDate,
  ) {
    final Uri $url = Uri.parse(
        '/get_activity_logs/${selectedFarm}?start_date=${startDate}&end_date=${endDate}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
