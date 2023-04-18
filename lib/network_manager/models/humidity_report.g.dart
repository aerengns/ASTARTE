// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'humidity_report.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<HumidityReport> _$humidityReportSerializer =
    new _$HumidityReportSerializer();

class _$HumidityReportSerializer
    implements StructuredSerializer<HumidityReport> {
  @override
  final Iterable<Type> types = const [HumidityReport, _$HumidityReport];
  @override
  final String wireName = 'HumidityReport';

  @override
  Iterable<Object?> serialize(Serializers serializers, HumidityReport object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'days',
      serializers.serialize(object.days,
          specifiedType: const FullType(List, const [const FullType(int)])),
      'humidity_levels',
      serializers.serialize(object.humidity_levels,
          specifiedType: const FullType(List, const [const FullType(int)])),
    ];

    return result;
  }

  @override
  HumidityReport deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new HumidityReportBuilder();

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
        case 'humidity_levels':
          result.humidity_levels = serializers.deserialize(value,
                  specifiedType:
                      const FullType(List, const [const FullType(int)]))!
              as List<int>;
          break;
      }
    }

    return result.build();
  }
}

class _$HumidityReport extends HumidityReport {
  @override
  final List<int> days;
  @override
  final List<int> humidity_levels;

  factory _$HumidityReport([void Function(HumidityReportBuilder)? updates]) =>
      (new HumidityReportBuilder()..update(updates))._build();

  _$HumidityReport._({required this.days, required this.humidity_levels})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(days, r'HumidityReport', 'days');
    BuiltValueNullFieldError.checkNotNull(
        humidity_levels, r'HumidityReport', 'humidity_levels');
  }

  @override
  HumidityReport rebuild(void Function(HumidityReportBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HumidityReportBuilder toBuilder() =>
      new HumidityReportBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HumidityReport &&
        days == other.days &&
        humidity_levels == other.humidity_levels;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, days.hashCode);
    _$hash = $jc(_$hash, humidity_levels.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'HumidityReport')
          ..add('days', days)
          ..add('humidity_levels', humidity_levels))
        .toString();
  }
}

class HumidityReportBuilder
    implements Builder<HumidityReport, HumidityReportBuilder> {
  _$HumidityReport? _$v;

  List<int>? _days;
  List<int>? get days => _$this._days;
  set days(List<int>? days) => _$this._days = days;

  List<int>? _humidity_levels;
  List<int>? get humidity_levels => _$this._humidity_levels;
  set humidity_levels(List<int>? humidity_levels) =>
      _$this._humidity_levels = humidity_levels;

  HumidityReportBuilder();

  HumidityReportBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _days = $v.days;
      _humidity_levels = $v.humidity_levels;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HumidityReport other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$HumidityReport;
  }

  @override
  void update(void Function(HumidityReportBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  HumidityReport build() => _build();

  _$HumidityReport _build() {
    final _$result = _$v ??
        new _$HumidityReport._(
            days: BuiltValueNullFieldError.checkNotNull(
                days, r'HumidityReport', 'days'),
            humidity_levels: BuiltValueNullFieldError.checkNotNull(
                humidity_levels, r'HumidityReport', 'humidity_levels'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
