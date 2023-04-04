import 'package:built_value/serializer.dart';
import 'package:chopper/chopper.dart';
import '../json_serialization/serializers.dart';
import 'package:built_collection/built_collection.dart';

class BuiltValueConverter extends JsonConverter {
  @override
  Request convertRequest(Request request) {
    return super.convertRequest(
        request.copyWith(
            body: serializers.serializeWith(
              serializers.serializerForType(request.body.runtimeType)!,
              request.body,
            )
        )
    );
  }

  @override
  Response<BodyType> convertResponse<BodyType, SingleItemType>(Response response) {
    final BodyType customBody = _convertToCustomObject<SingleItemType>(response.body);

    return response.copyWith<BodyType>(body: customBody);
  }

  dynamic _convertToCustomObject<SingleItemType>(dynamic element) {
    if (element is SingleItemType) {
      return element;
    } else if (element is List) {
      return _deserializeListOf<SingleItemType>(element);
    } else {
      return _deserialize<SingleItemType>(element);
    }
  }

  BuiltList<SingleItemType> _deserializeListOf<SingleItemType>(List dynamicList) {
    return BuiltList<SingleItemType>(
      dynamicList.map((element) => _deserialize<SingleItemType>(element)),
    );
  }

  SingleItemType _deserialize<SingleItemType>(Map<String, dynamic> value) {
    return serializers.deserializeWith<SingleItemType>(
      serializers.serializerForType(SingleItemType)! as Serializer<SingleItemType>,
      value,
    )!;
  }
}