// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<SensorData> _$sensorDataSerializer = new _$SensorDataSerializer();

class _$SensorDataSerializer implements StructuredSerializer<SensorData> {
  @override
  final Iterable<Type> types = const [SensorData, _$SensorData];
  @override
  final String wireName = 'SensorData';

  @override
  Iterable<Object?> serialize(Serializers serializers, SensorData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'farmName',
      serializers.serialize(object.farmName,
          specifiedType: const FullType(String)),
      'formDate',
      serializers.serialize(object.formDate,
          specifiedType: const FullType(String)),
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
      'latitude',
      serializers.serialize(object.latitude,
          specifiedType: const FullType(double)),
      'longitude',
      serializers.serialize(object.longitude,
          specifiedType: const FullType(double)),
    ];

    return result;
  }

  @override
  SensorData deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SensorDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'farmName':
          result.farmName = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'formDate':
          result.formDate = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
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
        case 'latitude':
          result.latitude = serializers.deserialize(value,
              specifiedType: const FullType(double))! as double;
          break;
        case 'longitude':
          result.longitude = serializers.deserialize(value,
              specifiedType: const FullType(double))! as double;
          break;
      }
    }

    return result.build();
  }
}

class _$SensorData extends SensorData {
  @override
  final String farmName;
  @override
  final String formDate;
  @override
  final double moisture;
  @override
  final double phosphorus;
  @override
  final double potassium;
  @override
  final double nitrogen;
  @override
  final double latitude;
  @override
  final double longitude;

  factory _$SensorData([void Function(SensorDataBuilder)? updates]) =>
      (new SensorDataBuilder()..update(updates))._build();

  _$SensorData._(
      {required this.farmName,
      required this.formDate,
      required this.moisture,
      required this.phosphorus,
      required this.potassium,
      required this.nitrogen,
      required this.latitude,
      required this.longitude})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(farmName, r'SensorData', 'farmName');
    BuiltValueNullFieldError.checkNotNull(formDate, r'SensorData', 'formDate');
    BuiltValueNullFieldError.checkNotNull(moisture, r'SensorData', 'moisture');
    BuiltValueNullFieldError.checkNotNull(
        phosphorus, r'SensorData', 'phosphorus');
    BuiltValueNullFieldError.checkNotNull(
        potassium, r'SensorData', 'potassium');
    BuiltValueNullFieldError.checkNotNull(nitrogen, r'SensorData', 'nitrogen');
    BuiltValueNullFieldError.checkNotNull(latitude, r'SensorData', 'latitude');
    BuiltValueNullFieldError.checkNotNull(
        longitude, r'SensorData', 'longitude');
  }

  @override
  SensorData rebuild(void Function(SensorDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SensorDataBuilder toBuilder() => new SensorDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SensorData &&
        farmName == other.farmName &&
        formDate == other.formDate &&
        moisture == other.moisture &&
        phosphorus == other.phosphorus &&
        potassium == other.potassium &&
        nitrogen == other.nitrogen &&
        latitude == other.latitude &&
        longitude == other.longitude;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, farmName.hashCode);
    _$hash = $jc(_$hash, formDate.hashCode);
    _$hash = $jc(_$hash, moisture.hashCode);
    _$hash = $jc(_$hash, phosphorus.hashCode);
    _$hash = $jc(_$hash, potassium.hashCode);
    _$hash = $jc(_$hash, nitrogen.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SensorData')
          ..add('farmName', farmName)
          ..add('formDate', formDate)
          ..add('moisture', moisture)
          ..add('phosphorus', phosphorus)
          ..add('potassium', potassium)
          ..add('nitrogen', nitrogen)
          ..add('latitude', latitude)
          ..add('longitude', longitude))
        .toString();
  }
}

class SensorDataBuilder implements Builder<SensorData, SensorDataBuilder> {
  _$SensorData? _$v;

  String? _farmName;
  String? get farmName => _$this._farmName;
  set farmName(String? farmName) => _$this._farmName = farmName;

  String? _formDate;
  String? get formDate => _$this._formDate;
  set formDate(String? formDate) => _$this._formDate = formDate;

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

  double? _latitude;
  double? get latitude => _$this._latitude;
  set latitude(double? latitude) => _$this._latitude = latitude;

  double? _longitude;
  double? get longitude => _$this._longitude;
  set longitude(double? longitude) => _$this._longitude = longitude;

  SensorDataBuilder();

  SensorDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _farmName = $v.farmName;
      _formDate = $v.formDate;
      _moisture = $v.moisture;
      _phosphorus = $v.phosphorus;
      _potassium = $v.potassium;
      _nitrogen = $v.nitrogen;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SensorData other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SensorData;
  }

  @override
  void update(void Function(SensorDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SensorData build() => _build();

  _$SensorData _build() {
    final _$result = _$v ??
        new _$SensorData._(
            farmName: BuiltValueNullFieldError.checkNotNull(
                farmName, r'SensorData', 'farmName'),
            formDate: BuiltValueNullFieldError.checkNotNull(
                formDate, r'SensorData', 'formDate'),
            moisture: BuiltValueNullFieldError.checkNotNull(
                moisture, r'SensorData', 'moisture'),
            phosphorus: BuiltValueNullFieldError.checkNotNull(
                phosphorus, r'SensorData', 'phosphorus'),
            potassium: BuiltValueNullFieldError.checkNotNull(
                potassium, r'SensorData', 'potassium'),
            nitrogen: BuiltValueNullFieldError.checkNotNull(
                nitrogen, r'SensorData', 'nitrogen'),
            latitude: BuiltValueNullFieldError.checkNotNull(
                latitude, r'SensorData', 'latitude'),
            longitude: BuiltValueNullFieldError.checkNotNull(
                longitude, r'SensorData', 'longitude'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
