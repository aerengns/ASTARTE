import 'dart:async';
import 'package:chopper/chopper.dart';

class HeaderInterceptor implements RequestInterceptor {
  // TODO: keys
  static const String AUTH_HEADER = "Authorization";
  static const String BEARER = "Bearer ";
  static const String V4_AUTH_HEADER = "< your key here >";

  @override
  FutureOr<Request> onRequest(Request request) async {
    Request newRequest = request.copyWith(headers: {AUTH_HEADER: BEARER + V4_AUTH_HEADER});
    return newRequest;
  }
}
