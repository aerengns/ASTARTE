import 'package:astarte/network_manager/models/custom_event.dart';
import 'package:astarte/utils/parameters.dart';
import 'package:chopper/chopper.dart';
import 'package:built_collection/built_collection.dart';
import 'package:astarte/network_manager/model_converters/built_value_converter.dart';

part "calendar_events_service.chopper.dart";

@ChopperApi(baseUrl: "")
abstract class CalendarEventsService extends ChopperService {
  @Get(path: '/create_event')
  Future<Response<BuiltList<CustomEvent>>> getCalendarData(
      @Path('date') String date);

  @Post(path: '/create_event')
  Future<Response> createCustomEvent(@Body() CustomEvent event);

  @Get(
      path:
          '/get_activity_logs/{farm}?start_date={startDate}&end_date={endDate}')
  Future<Response> getActivityLogData(@Path('farm') String selectedFarm,
      @Path('startDate') String startDate, @Path('endDate') String endDate);

  static CalendarEventsService create() {
    final client = ChopperClient(
        baseUrl: Uri.parse('${GENERAL_URL}app/'),
        services: [
          _$CalendarEventsService(),
        ],
        converter: BuiltValueConverter(),
        interceptors: [
          HeadersInterceptor({'Authorization': TOKEN}),
          HttpLoggingInterceptor(),
        ]);
    return _$CalendarEventsService(client);
  }
}
