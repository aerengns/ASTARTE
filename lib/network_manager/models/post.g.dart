// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<PostData> _$postDataSerializer = new _$PostDataSerializer();

class _$PostDataSerializer implements StructuredSerializer<PostData> {
  @override
  final Iterable<Type> types = const [PostData, _$PostData];
  @override
  final String wireName = 'PostData';

  @override
  Iterable<Object?> serialize(Serializers serializers, PostData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'message',
      serializers.serialize(object.message,
          specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.id;
    if (value != null) {
      result
        ..add('id')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.image;
    if (value != null) {
      result
        ..add('image')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  PostData deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PostDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'image':
          result.image = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'message':
          result.message = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$PostData extends PostData {
  @override
  final int? id;
  @override
  final String? image;
  @override
  final String message;

  factory _$PostData([void Function(PostDataBuilder)? updates]) =>
      (new PostDataBuilder()..update(updates))._build();

  _$PostData._({this.id, this.image, required this.message}) : super._() {
    BuiltValueNullFieldError.checkNotNull(message, r'PostData', 'message');
  }

  @override
  PostData rebuild(void Function(PostDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PostDataBuilder toBuilder() => new PostDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PostData &&
        id == other.id &&
        image == other.image &&
        message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, image.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PostData')
          ..add('id', id)
          ..add('image', image)
          ..add('message', message))
        .toString();
  }
}

class PostDataBuilder implements Builder<PostData, PostDataBuilder> {
  _$PostData? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _image;
  String? get image => _$this._image;
  set image(String? image) => _$this._image = image;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  PostDataBuilder();

  PostDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _image = $v.image;
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PostData other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PostData;
  }

  @override
  void update(void Function(PostDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PostData build() => _build();

  _$PostData _build() {
    final _$result = _$v ??
        new _$PostData._(
            id: id,
            image: image,
            message: BuiltValueNullFieldError.checkNotNull(
                message, r'PostData', 'message'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
