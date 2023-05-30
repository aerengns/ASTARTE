// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<CustomEvent> _$customEventSerializer = new _$CustomEventSerializer();

class _$CustomEventSerializer implements StructuredSerializer<CustomEvent> {
  @override
  final Iterable<Type> types = const [CustomEvent, _$CustomEvent];
  @override
  final String wireName = 'CustomEvent';

  @override
  Iterable<Object?> serialize(Serializers serializers, CustomEvent object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'description',
      serializers.serialize(object.description,
          specifiedType: const FullType(String)),
      'date',
      serializers.serialize(object.date, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.id;
    if (value != null) {
      result
        ..add('id')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  CustomEvent deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new CustomEventBuilder();

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
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'date':
          result.date = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$CustomEvent extends CustomEvent {
  @override
  final int? id;
  @override
  final String description;
  @override
  final String date;

  factory _$CustomEvent([void Function(CustomEventBuilder)? updates]) =>
      (new CustomEventBuilder()..update(updates))._build();

  _$CustomEvent._({this.id, required this.description, required this.date})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        description, r'CustomEvent', 'description');
    BuiltValueNullFieldError.checkNotNull(date, r'CustomEvent', 'date');
  }

  @override
  CustomEvent rebuild(void Function(CustomEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CustomEventBuilder toBuilder() => new CustomEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomEvent &&
        id == other.id &&
        description == other.description &&
        date == other.date;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomEvent')
          ..add('id', id)
          ..add('description', description)
          ..add('date', date))
        .toString();
  }
}

class CustomEventBuilder implements Builder<CustomEvent, CustomEventBuilder> {
  _$CustomEvent? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _date;
  String? get date => _$this._date;
  set date(String? date) => _$this._date = date;

  CustomEventBuilder();

  CustomEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _description = $v.description;
      _date = $v.date;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomEvent other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CustomEvent;
  }

  @override
  void update(void Function(CustomEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomEvent build() => _build();

  _$CustomEvent _build() {
    final _$result = _$v ??
        new _$CustomEvent._(
            id: id,
            description: BuiltValueNullFieldError.checkNotNull(
                description, r'CustomEvent', 'description'),
            date: BuiltValueNullFieldError.checkNotNull(
                date, r'CustomEvent', 'date'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
