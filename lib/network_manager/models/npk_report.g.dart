// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'npk_report.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<NpkReport> _$npkReportSerializer = new _$NpkReportSerializer();

class _$NpkReportSerializer implements StructuredSerializer<NpkReport> {
  @override
  final Iterable<Type> types = const [NpkReport, _$NpkReport];
  @override
  final String wireName = 'NpkReport';

  @override
  Iterable<Object?> serialize(Serializers serializers, NpkReport object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'days',
      serializers.serialize(object.days,
          specifiedType: const FullType(List, const [const FullType(int)])),
      'n_values',
      serializers.serialize(object.n_values,
          specifiedType: const FullType(List, const [const FullType(int)])),
      'p_values',
      serializers.serialize(object.p_values,
          specifiedType: const FullType(List, const [const FullType(int)])),
      'k_values',
      serializers.serialize(object.k_values,
          specifiedType: const FullType(List, const [const FullType(int)])),
    ];

    return result;
  }

  @override
  NpkReport deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new NpkReportBuilder();

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
        case 'n_values':
          result.n_values = serializers.deserialize(value,
                  specifiedType:
                      const FullType(List, const [const FullType(int)]))!
              as List<int>;
          break;
        case 'p_values':
          result.p_values = serializers.deserialize(value,
                  specifiedType:
                      const FullType(List, const [const FullType(int)]))!
              as List<int>;
          break;
        case 'k_values':
          result.k_values = serializers.deserialize(value,
                  specifiedType:
                      const FullType(List, const [const FullType(int)]))!
              as List<int>;
          break;
      }
    }

    return result.build();
  }
}

class _$NpkReport extends NpkReport {
  @override
  final List<int> days;
  @override
  final List<int> n_values;
  @override
  final List<int> p_values;
  @override
  final List<int> k_values;

  factory _$NpkReport([void Function(NpkReportBuilder)? updates]) =>
      (new NpkReportBuilder()..update(updates))._build();

  _$NpkReport._(
      {required this.days,
      required this.n_values,
      required this.p_values,
      required this.k_values})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(days, r'NpkReport', 'days');
    BuiltValueNullFieldError.checkNotNull(n_values, r'NpkReport', 'n_values');
    BuiltValueNullFieldError.checkNotNull(p_values, r'NpkReport', 'p_values');
    BuiltValueNullFieldError.checkNotNull(k_values, r'NpkReport', 'k_values');
  }

  @override
  NpkReport rebuild(void Function(NpkReportBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NpkReportBuilder toBuilder() => new NpkReportBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NpkReport &&
        days == other.days &&
        n_values == other.n_values &&
        p_values == other.p_values &&
        k_values == other.k_values;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, days.hashCode);
    _$hash = $jc(_$hash, n_values.hashCode);
    _$hash = $jc(_$hash, p_values.hashCode);
    _$hash = $jc(_$hash, k_values.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NpkReport')
          ..add('days', days)
          ..add('n_values', n_values)
          ..add('p_values', p_values)
          ..add('k_values', k_values))
        .toString();
  }
}

class NpkReportBuilder implements Builder<NpkReport, NpkReportBuilder> {
  _$NpkReport? _$v;

  List<int>? _days;
  List<int>? get days => _$this._days;
  set days(List<int>? days) => _$this._days = days;

  List<int>? _n_values;
  List<int>? get n_values => _$this._n_values;
  set n_values(List<int>? n_values) => _$this._n_values = n_values;

  List<int>? _p_values;
  List<int>? get p_values => _$this._p_values;
  set p_values(List<int>? p_values) => _$this._p_values = p_values;

  List<int>? _k_values;
  List<int>? get k_values => _$this._k_values;
  set k_values(List<int>? k_values) => _$this._k_values = k_values;

  NpkReportBuilder();

  NpkReportBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _days = $v.days;
      _n_values = $v.n_values;
      _p_values = $v.p_values;
      _k_values = $v.k_values;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NpkReport other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$NpkReport;
  }

  @override
  void update(void Function(NpkReportBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NpkReport build() => _build();

  _$NpkReport _build() {
    final _$result = _$v ??
        new _$NpkReport._(
            days: BuiltValueNullFieldError.checkNotNull(
                days, r'NpkReport', 'days'),
            n_values: BuiltValueNullFieldError.checkNotNull(
                n_values, r'NpkReport', 'n_values'),
            p_values: BuiltValueNullFieldError.checkNotNull(
                p_values, r'NpkReport', 'p_values'),
            k_values: BuiltValueNullFieldError.checkNotNull(
                k_values, r'NpkReport', 'k_values'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
