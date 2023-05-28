// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farm_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<FarmReportData> _$farmReportDataSerializer =
new _$FarmReportDataSerializer();
Serializer<FarmData> _$farmDataSerializer = new _$FarmDataSerializer();

class _$FarmReportDataSerializer
    implements StructuredSerializer<FarmReportData> {
  @override
  final Iterable<Type> types = const [FarmReportData, _$FarmReportData];
  @override
  final String wireName = 'FarmReportData';

  @override
  Iterable<Object?> serialize(Serializers serializers, FarmReportData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'moisture',
      serializers.serialize(object.moisture,
          specifiedType: const FullType(double)),
      'phosphorus',
      serializers.serialize(object.phosphorus,
          specifiedType: const FullType(double)),
      'potassium',
      serializers.serialize(object.potassium,
          specifiedType: const FullType(double)),
      'nitrogen',
      serializers.serialize(object.nitrogen,
          specifiedType: const FullType(double)),
      'temperature',
      serializers.serialize(object.temperature,
          specifiedType: const FullType(double)),
      'ph',
      serializers.serialize(object.ph, specifiedType: const FullType(double)),
    ];

    return result;
  }

  @override
  FarmReportData deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new FarmReportDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'moisture':
          result.moisture = serializers.deserialize(value,
              specifiedType: const FullType(double))! as double;
          break;
        case 'phosphorus':
          result.phosphorus = serializers.deserialize(value,
              specifiedType: const FullType(double))! as double;
          break;
        case 'potassium':
          result.potassium = serializers.deserialize(value,
              specifiedType: const FullType(double))! as double;
          break;
        case 'nitrogen':
          result.nitrogen = serializers.deserialize(value,
              specifiedType: const FullType(double))! as double;
          break;
        case 'temperature':
          result.temperature = serializers.deserialize(value,
              specifiedType: const FullType(double))! as double;
          break;
        case 'ph':
          result.ph = serializers.deserialize(value,
              specifiedType: const FullType(double))! as double;
          break;
      }
    }

    return result.build();
  }
}

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
          specifiedType: const FullType(int)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'area',
      serializers.serialize(object.area, specifiedType: const FullType(double)),
      'owner',
      serializers.serialize(object.owner, specifiedType: const FullType(int)),
    ];
    Object? value;
    value = object.latest_farm_report;
    if (value != null) {
      result
        ..add('latest_farm_report')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(FarmReportData)));
    }
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
              specifiedType: const FullType(int))! as int;
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
        case 'latest_farm_report':
          result.latest_farm_report.replace(serializers.deserialize(value,
              specifiedType: const FullType(FarmReportData))!
          as FarmReportData);
          break;
      }
    }

    return result.build();
  }
}

class _$FarmReportData extends FarmReportData {
  @override
  final double moisture;
  @override
  final double phosphorus;
  @override
  final double potassium;
  @override
  final double nitrogen;
  @override
  final double temperature;
  @override
  final double ph;

  factory _$FarmReportData([void Function(FarmReportDataBuilder)? updates]) =>
      (new FarmReportDataBuilder()..update(updates))._build();

  _$FarmReportData._(
      {required this.moisture,
        required this.phosphorus,
        required this.potassium,
        required this.nitrogen,
        required this.temperature,
        required this.ph})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        moisture, r'FarmReportData', 'moisture');
    BuiltValueNullFieldError.checkNotNull(
        phosphorus, r'FarmReportData', 'phosphorus');
    BuiltValueNullFieldError.checkNotNull(
        potassium, r'FarmReportData', 'potassium');
    BuiltValueNullFieldError.checkNotNull(
        nitrogen, r'FarmReportData', 'nitrogen');
    BuiltValueNullFieldError.checkNotNull(
        temperature, r'FarmReportData', 'temperature');
    BuiltValueNullFieldError.checkNotNull(ph, r'FarmReportData', 'ph');
  }

  @override
  FarmReportData rebuild(void Function(FarmReportDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FarmReportDataBuilder toBuilder() =>
      new FarmReportDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FarmReportData &&
        moisture == other.moisture &&
        phosphorus == other.phosphorus &&
        potassium == other.potassium &&
        nitrogen == other.nitrogen &&
        temperature == other.temperature &&
        ph == other.ph;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, moisture.hashCode);
    _$hash = $jc(_$hash, phosphorus.hashCode);
    _$hash = $jc(_$hash, potassium.hashCode);
    _$hash = $jc(_$hash, nitrogen.hashCode);
    _$hash = $jc(_$hash, temperature.hashCode);
    _$hash = $jc(_$hash, ph.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FarmReportData')
      ..add('moisture', moisture)
      ..add('phosphorus', phosphorus)
      ..add('potassium', potassium)
      ..add('nitrogen', nitrogen)
      ..add('temperature', temperature)
      ..add('ph', ph))
        .toString();
  }
}

class FarmReportDataBuilder
    implements Builder<FarmReportData, FarmReportDataBuilder> {
  _$FarmReportData? _$v;

  double? _moisture;
  double? get moisture => _$this._moisture;
  set moisture(double? moisture) => _$this._moisture = moisture;

  double? _phosphorus;
  double? get phosphorus => _$this._phosphorus;
  set phosphorus(double? phosphorus) => _$this._phosphorus = phosphorus;

  double? _potassium;
  double? get potassium => _$this._potassium;
  set potassium(double? potassium) => _$this._potassium = potassium;

  double? _nitrogen;
  double? get nitrogen => _$this._nitrogen;
  set nitrogen(double? nitrogen) => _$this._nitrogen = nitrogen;

  double? _temperature;
  double? get temperature => _$this._temperature;
  set temperature(double? temperature) => _$this._temperature = temperature;

  double? _ph;
  double? get ph => _$this._ph;
  set ph(double? ph) => _$this._ph = ph;

  FarmReportDataBuilder();

  FarmReportDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _moisture = $v.moisture;
      _phosphorus = $v.phosphorus;
      _potassium = $v.potassium;
      _nitrogen = $v.nitrogen;
      _temperature = $v.temperature;
      _ph = $v.ph;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FarmReportData other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$FarmReportData;
  }

  @override
  void update(void Function(FarmReportDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FarmReportData build() => _build();

  _$FarmReportData _build() {
    final _$result = _$v ??
        new _$FarmReportData._(
            moisture: BuiltValueNullFieldError.checkNotNull(
                moisture, r'FarmReportData', 'moisture'),
            phosphorus: BuiltValueNullFieldError.checkNotNull(
                phosphorus, r'FarmReportData', 'phosphorus'),
            potassium: BuiltValueNullFieldError.checkNotNull(
                potassium, r'FarmReportData', 'potassium'),
            nitrogen: BuiltValueNullFieldError.checkNotNull(
                nitrogen, r'FarmReportData', 'nitrogen'),
            temperature: BuiltValueNullFieldError.checkNotNull(
                temperature, r'FarmReportData', 'temperature'),
            ph: BuiltValueNullFieldError.checkNotNull(
                ph, r'FarmReportData', 'ph'));
    replace(_$result);
    return _$result;
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
  final int is_active;
  @override
  final String name;
  @override
  final double area;
  @override
  final int owner;
  @override
  final FarmReportData? latest_farm_report;

  factory _$FarmData([void Function(FarmDataBuilder)? updates]) =>
      (new FarmDataBuilder()..update(updates))._build();

  _$FarmData._(
      {required this.id,
        required this.created_at,
        required this.updated_at,
        required this.is_active,
        required this.name,
        required this.area,
        required this.owner,
        this.latest_farm_report})
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
        owner == other.owner &&
        latest_farm_report == other.latest_farm_report;
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
    _$hash = $jc(_$hash, latest_farm_report.hashCode);
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
      ..add('owner', owner)
      ..add('latest_farm_report', latest_farm_report))
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

  int? _is_active;
  int? get is_active => _$this._is_active;
  set is_active(int? is_active) => _$this._is_active = is_active;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  double? _area;
  double? get area => _$this._area;
  set area(double? area) => _$this._area = area;

  int? _owner;
  int? get owner => _$this._owner;
  set owner(int? owner) => _$this._owner = owner;

  FarmReportDataBuilder? _latest_farm_report;
  FarmReportDataBuilder get latest_farm_report =>
      _$this._latest_farm_report ??= new FarmReportDataBuilder();
  set latest_farm_report(FarmReportDataBuilder? latest_farm_report) =>
      _$this._latest_farm_report = latest_farm_report;

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
      _latest_farm_report = $v.latest_farm_report?.toBuilder();
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
    _$FarmData _$result;
    try {
      _$result = _$v ??
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
                  owner, r'FarmData', 'owner'),
              latest_farm_report: _latest_farm_report?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'latest_farm_report';
        _latest_farm_report?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'FarmData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint