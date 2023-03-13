// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'astarte_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$AstarteApi extends AstarteApi {
  _$AstarteApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = AstarteApi;

  @override
  Future<Response<Hello>> getHello() {
    final Uri $url = Uri.parse('app/hello');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<Hello, Hello>($request);
  }
}
