import 'package:chopper/chopper.dart';
import 'header_interceptor.dart';
import 'model_converter.dart';
import 'package:astarte/network_manager/models/hello.dart';

part 'astarte_api.chopper.dart';

@ChopperApi()
abstract class AstarteApi extends ChopperService {

  @Get(path: 'app/hello')
  Future<Response<Hello>> getHello();

  static AstarteApi create() {
    final client = ChopperClient(
      baseUrl: 'http://localhost:8000/' as Uri,
      services: [
        _$AstarteApi(),
      ],
    );
    return _$AstarteApi(client);
  }
}
