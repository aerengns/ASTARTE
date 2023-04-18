// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temperature_report.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<TemperatureReport> _$temperatureReportSerializer =
    new _$TemperatureReportSerializer();

class _$TemperatureReportSerializer
    implements StructuredSerializer<TemperatureReport> {
  @override
  final Iterable<Type> types = const [TemperatureReport, _$TemperatureReport];
  @override
  final String wireName = 'TemperatureReport';

  @override
  Iterable<Object?> serialize(Serializers serializers, TemperatureReport object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'days',
      serializers.serialize(object.days,
          specifiedType: const FullType(List, const [const FullType(int)])),
      'temperatures',
      serializers.serialize(object.temperatures,
          specifiedType: const FullType(List, const [const FullType(int)])),
    ];

    return result;
  }

  @override
  TemperatureReport deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TemperatureReportBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'days':
          result.days = serializers.deserialize(value,
                  specifiedType:
                      const FullType(List, const [const FullType(int)]))!
              as List<int>;
          break;
        case 'temperatures':
          result.temperatures = serializers.deserialize(value,
                  specifiedType:
                      const FullType(List, const [const FullType(int)]))!
              as List<int>;
          break;
      }
    }

    return result.build();
  }
}

class _$TemperatureReport extends TemperatureReport {
  @override
  final List<int> days;
  @override
  final List<int> temperatures;

  factory _$TemperatureReport(
          [void Function(TemperatureReportBuilder)? updates]) =>
      (new TemperatureReportBuilder()..update(updates))._build();

  _$TemperatureReport._({required this.days, required this.temperatures})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(days, r'TemperatureReport', 'days');
    BuiltValueNullFieldError.checkNotNull(
        temperatures, r'TemperatureReport', 'temperatures');
  }

  @override
  TemperatureReport rebuild(void Function(TemperatureReportBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TemperatureReportBuilder toBuilder() =>
      new TemperatureReportBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TemperatureReport &&
        days == other.days &&
        temperatures == other.temperatures;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, days.hashCode);
    _$hash = $jc(_$hash, temperatures.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TemperatureReport')
          ..add('days', days)
          ..add('temperatures', temperatures))
        .toString();
  }
}

class TemperatureReportBuilder
    implements Builder<TemperatureReport, TemperatureReportBuilder> {
  _$TemperatureReport? _$v;

  List<int>? _days;
  List<int>? get days => _$this._days;
  set days(List<int>? days) => _$this._days = days;

  List<int>? _temperatures;
  List<int>? get temperatures => _$this._temperatures;
  set temperatures(List<int>? temperatures) =>
      _$this._temperatures = temperatures;

  TemperatureReportBuilder();

  TemperatureReportBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _days = $v.days;
      _temperatures = $v.temperatures;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TemperatureReport other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$TemperatureReport;
  }

  @override
  void update(void Function(TemperatureReportBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TemperatureReport build() => _build();

  _$TemperatureReport _build() {
    final _$result = _$v ??
        new _$TemperatureReport._(
            days: BuiltValueNullFieldError.checkNotNull(
                days, r'TemperatureReport', 'days'),
            temperatures: BuiltValueNullFieldError.checkNotNull(
                temperatures, r'TemperatureReport', 'temperatures'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
