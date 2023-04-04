// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farm_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<FarmData> _$farmDataSerializer = new _$FarmDataSerializer();

class _$FarmDataSerializer implements StructuredSerializer<FarmData> {
  @override
  final Iterable<Type> types = const [FarmData, _$FarmData];
  @override
  final String wireName = 'FarmData';

  @override
  Iterable<Object?> serialize(Serializers serializers, FarmData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'created_at',
      serializers.serialize(object.created_at,
          specifiedType: const FullType(String)),
      'updated_at',
      serializers.serialize(object.updated_at,
          specifiedType: const FullType(String)),
      'is_active',
      serializers.serialize(object.is_active,
          specifiedType: const FullType(Bool)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'area',
      serializers.serialize(object.area, specifiedType: const FullType(double)),
      'owner',
      serializers.serialize(object.owner, specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  FarmData deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new FarmDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'created_at':
          result.created_at = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'updated_at':
          result.updated_at = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'is_active':
          result.is_active = serializers.deserialize(value,
              specifiedType: const FullType(Bool))! as Bool;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'area':
          result.area = serializers.deserialize(value,
              specifiedType: const FullType(double))! as double;
          break;
        case 'owner':
          result.owner = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
      }
    }

    return result.build();
  }
}

class _$FarmData extends FarmData {
  @override
  final int id;
  @override
  final String created_at;
  @override
  final String updated_at;
  @override
  final Bool is_active;
  @override
  final String name;
  @override
  final double area;
  @override
  final int owner;

  factory _$FarmData([void Function(FarmDataBuilder)? updates]) =>
      (new FarmDataBuilder()..update(updates))._build();

  _$FarmData._(
      {required this.id,
      required this.created_at,
      required this.updated_at,
      required this.is_active,
      required this.name,
      required this.area,
      required this.owner})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'FarmData', 'id');
    BuiltValueNullFieldError.checkNotNull(
        created_at, r'FarmData', 'created_at');
    BuiltValueNullFieldError.checkNotNull(
        updated_at, r'FarmData', 'updated_at');
    BuiltValueNullFieldError.checkNotNull(is_active, r'FarmData', 'is_active');
    BuiltValueNullFieldError.checkNotNull(name, r'FarmData', 'name');
    BuiltValueNullFieldError.checkNotNull(area, r'FarmData', 'area');
    BuiltValueNullFieldError.checkNotNull(owner, r'FarmData', 'owner');
  }

  @override
  FarmData rebuild(void Function(FarmDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FarmDataBuilder toBuilder() => new FarmDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FarmData &&
        id == other.id &&
        created_at == other.created_at &&
        updated_at == other.updated_at &&
        is_active == other.is_active &&
        name == other.name &&
        area == other.area &&
        owner == other.owner;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, created_at.hashCode);
    _$hash = $jc(_$hash, updated_at.hashCode);
    _$hash = $jc(_$hash, is_active.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, area.hashCode);
    _$hash = $jc(_$hash, owner.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FarmData')
          ..add('id', id)
          ..add('created_at', created_at)
          ..add('updated_at', updated_at)
          ..add('is_active', is_active)
          ..add('name', name)
          ..add('area', area)
          ..add('owner', owner))
        .toString();
  }
}

class FarmDataBuilder implements Builder<FarmData, FarmDataBuilder> {
  _$FarmData? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _created_at;
  String? get created_at => _$this._created_at;
  set created_at(String? created_at) => _$this._created_at = created_at;

  String? _updated_at;
  String? get updated_at => _$this._updated_at;
  set updated_at(String? updated_at) => _$this._updated_at = updated_at;

  Bool? _is_active;
  Bool? get is_active => _$this._is_active;
  set is_active(Bool? is_active) => _$this._is_active = is_active;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  double? _area;
  double? get area => _$this._area;
  set area(double? area) => _$this._area = area;

  int? _owner;
  int? get owner => _$this._owner;
  set owner(int? owner) => _$this._owner = owner;

  FarmDataBuilder();

  FarmDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _created_at = $v.created_at;
      _updated_at = $v.updated_at;
      _is_active = $v.is_active;
      _name = $v.name;
      _area = $v.area;
      _owner = $v.owner;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FarmData other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$FarmData;
  }

  @override
  void update(void Function(FarmDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FarmData build() => _build();

  _$FarmData _build() {
    final _$result = _$v ??
        new _$FarmData._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'FarmData', 'id'),
            created_at: BuiltValueNullFieldError.checkNotNull(
                created_at, r'FarmData', 'created_at'),
            updated_at: BuiltValueNullFieldError.checkNotNull(
                updated_at, r'FarmData', 'updated_at'),
            is_active: BuiltValueNullFieldError.checkNotNull(
                is_active, r'FarmData', 'is_active'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'FarmData', 'name'),
            area: BuiltValueNullFieldError.checkNotNull(
                area, r'FarmData', 'area'),
            owner: BuiltValueNullFieldError.checkNotNull(
                owner, r'FarmData', 'owner'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
