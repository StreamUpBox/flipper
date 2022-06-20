// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, inference_failure_on_function_invocation

extension GetVoucherCollection on Isar {
  IsarCollection<Voucher> get vouchers => getCollection();
}

const VoucherSchema = CollectionSchema(
  name: 'Voucher',
  schema:
      '{"name":"Voucher","idName":"id","properties":[{"name":"createdAt","type":"Long"},{"name":"descriptor","type":"String"},{"name":"interval","type":"Long"},{"name":"used","type":"Bool"},{"name":"usedAt","type":"Long"},{"name":"value","type":"Long"}],"indexes":[],"links":[{"name":"features","target":"Feature"}]}',
  idName: 'id',
  propertyIds: {
    'createdAt': 0,
    'descriptor': 1,
    'interval': 2,
    'used': 3,
    'usedAt': 4,
    'value': 5
  },
  listProperties: {},
  indexIds: {},
  indexValueTypes: {},
  linkIds: {'features': 0},
  backlinkLinkNames: {},
  getId: _voucherGetId,
  setId: _voucherSetId,
  getLinks: _voucherGetLinks,
  attachLinks: _voucherAttachLinks,
  serializeNative: _voucherSerializeNative,
  deserializeNative: _voucherDeserializeNative,
  deserializePropNative: _voucherDeserializePropNative,
  serializeWeb: _voucherSerializeWeb,
  deserializeWeb: _voucherDeserializeWeb,
  deserializePropWeb: _voucherDeserializePropWeb,
  version: 4,
);

int? _voucherGetId(Voucher object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _voucherSetId(Voucher object, int id) {
  object.id = id;
}

List<IsarLinkBase<dynamic>> _voucherGetLinks(Voucher object) {
  return [object.features];
}

void _voucherSerializeNative(
    IsarCollection<Voucher> collection,
    IsarCObject cObj,
    Voucher object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  final descriptor$Bytes =
      IsarBinaryWriter.utf8Encoder.convert(object.descriptor);
  final size = staticSize + (descriptor$Bytes.length);
  cObj.buffer = alloc(size);
  cObj.buffer_length = size;

  final buffer = IsarNative.bufAsBytes(cObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeLong(offsets[0], object.createdAt);
  writer.writeBytes(offsets[1], descriptor$Bytes);
  writer.writeLong(offsets[2], object.interval);
  writer.writeBool(offsets[3], object.used);
  writer.writeLong(offsets[4], object.usedAt);
  writer.writeLong(offsets[5], object.value);
}

Voucher _voucherDeserializeNative(IsarCollection<Voucher> collection, int id,
    IsarBinaryReader reader, List<int> offsets) {
  final object = Voucher();
  object.createdAt = reader.readLong(offsets[0]);
  object.descriptor = reader.readString(offsets[1]);
  object.id = id;
  object.interval = reader.readLong(offsets[2]);
  object.used = reader.readBool(offsets[3]);
  object.usedAt = reader.readLong(offsets[4]);
  object.value = reader.readLong(offsets[5]);
  _voucherAttachLinks(collection, id, object);
  return object;
}

P _voucherDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw 'Illegal propertyIndex';
  }
}

Object _voucherSerializeWeb(
    IsarCollection<Voucher> collection, Voucher object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, 'createdAt', object.createdAt);
  IsarNative.jsObjectSet(jsObj, 'descriptor', object.descriptor);
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(jsObj, 'interval', object.interval);
  IsarNative.jsObjectSet(jsObj, 'used', object.used);
  IsarNative.jsObjectSet(jsObj, 'usedAt', object.usedAt);
  IsarNative.jsObjectSet(jsObj, 'value', object.value);
  return jsObj;
}

Voucher _voucherDeserializeWeb(
    IsarCollection<Voucher> collection, Object jsObj) {
  final object = Voucher();
  object.createdAt = IsarNative.jsObjectGet(jsObj, 'createdAt') ??
      (double.negativeInfinity as int);
  object.descriptor = IsarNative.jsObjectGet(jsObj, 'descriptor') ?? '';
  object.id =
      IsarNative.jsObjectGet(jsObj, 'id') ?? (double.negativeInfinity as int);
  object.interval = IsarNative.jsObjectGet(jsObj, 'interval') ??
      (double.negativeInfinity as int);
  object.used = IsarNative.jsObjectGet(jsObj, 'used') ?? false;
  object.usedAt = IsarNative.jsObjectGet(jsObj, 'usedAt') ??
      (double.negativeInfinity as int);
  object.value = IsarNative.jsObjectGet(jsObj, 'value') ??
      (double.negativeInfinity as int);
  _voucherAttachLinks(
      collection,
      IsarNative.jsObjectGet(jsObj, 'id') ?? (double.negativeInfinity as int),
      object);
  return object;
}

P _voucherDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'createdAt':
      return (IsarNative.jsObjectGet(jsObj, 'createdAt') ??
          (double.negativeInfinity as int)) as P;
    case 'descriptor':
      return (IsarNative.jsObjectGet(jsObj, 'descriptor') ?? '') as P;
    case 'id':
      return (IsarNative.jsObjectGet(jsObj, 'id') ??
          (double.negativeInfinity as int)) as P;
    case 'interval':
      return (IsarNative.jsObjectGet(jsObj, 'interval') ??
          (double.negativeInfinity as int)) as P;
    case 'used':
      return (IsarNative.jsObjectGet(jsObj, 'used') ?? false) as P;
    case 'usedAt':
      return (IsarNative.jsObjectGet(jsObj, 'usedAt') ??
          (double.negativeInfinity as int)) as P;
    case 'value':
      return (IsarNative.jsObjectGet(jsObj, 'value') ??
          (double.negativeInfinity as int)) as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _voucherAttachLinks(IsarCollection<dynamic> col, int id, Voucher object) {
  object.features.attach(col, col.isar.features, 'features', id);
}

extension VoucherQueryWhereSort on QueryBuilder<Voucher, Voucher, QWhere> {
  QueryBuilder<Voucher, Voucher, QAfterWhere> anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }
}

extension VoucherQueryWhere on QueryBuilder<Voucher, Voucher, QWhereClause> {
  QueryBuilder<Voucher, Voucher, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterWhereClause> idNotEqualTo(int id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(
        IdWhereClause.lessThan(upper: id, includeUpper: false),
      ).addWhereClauseInternal(
        IdWhereClause.greaterThan(lower: id, includeLower: false),
      );
    } else {
      return addWhereClauseInternal(
        IdWhereClause.greaterThan(lower: id, includeLower: false),
      ).addWhereClauseInternal(
        IdWhereClause.lessThan(upper: id, includeUpper: false),
      );
    }
  }

  QueryBuilder<Voucher, Voucher, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<Voucher, Voucher, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<Voucher, Voucher, QAfterWhereClause> idBetween(
    int lowerId,
    int upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: lowerId,
      includeLower: includeLower,
      upper: upperId,
      includeUpper: includeUpper,
    ));
  }
}

extension VoucherQueryFilter
    on QueryBuilder<Voucher, Voucher, QFilterCondition> {
  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> createdAtEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition.equalTo(
      property: 'createdAt',
      value: value,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> createdAtGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition.greaterThan(
      include: include,
      property: 'createdAt',
      value: value,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> createdAtLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition.lessThan(
      include: include,
      property: 'createdAt',
      value: value,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> createdAtBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'createdAt',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition.equalTo(
      property: 'descriptor',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition.greaterThan(
      include: include,
      property: 'descriptor',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition.lessThan(
      include: include,
      property: 'descriptor',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'descriptor',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition.startsWith(
      property: 'descriptor',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition.endsWith(
      property: 'descriptor',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition.contains(
      property: 'descriptor',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition.matches(
      property: 'descriptor',
      wildcard: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> idEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition.equalTo(
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition.greaterThan(
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> idLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition.lessThan(
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'id',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> intervalEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition.equalTo(
      property: 'interval',
      value: value,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> intervalGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition.greaterThan(
      include: include,
      property: 'interval',
      value: value,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> intervalLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition.lessThan(
      include: include,
      property: 'interval',
      value: value,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> intervalBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'interval',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> usedEqualTo(
      bool value) {
    return addFilterConditionInternal(FilterCondition.equalTo(
      property: 'used',
      value: value,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> usedAtEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition.equalTo(
      property: 'usedAt',
      value: value,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> usedAtGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition.greaterThan(
      include: include,
      property: 'usedAt',
      value: value,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> usedAtLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition.lessThan(
      include: include,
      property: 'usedAt',
      value: value,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> usedAtBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'usedAt',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> valueEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition.equalTo(
      property: 'value',
      value: value,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> valueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition.greaterThan(
      include: include,
      property: 'value',
      value: value,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> valueLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition.lessThan(
      include: include,
      property: 'value',
      value: value,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> valueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'value',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }
}

extension VoucherQueryLinks
    on QueryBuilder<Voucher, Voucher, QFilterCondition> {
  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> features(
      FilterQuery<Feature> q) {
    return linkInternal(
      isar.features,
      q,
      'features',
    );
  }
}

extension VoucherQueryWhereSortBy on QueryBuilder<Voucher, Voucher, QSortBy> {
  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByCreatedAt() {
    return addSortByInternal('createdAt', Sort.asc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByCreatedAtDesc() {
    return addSortByInternal('createdAt', Sort.desc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByDescriptor() {
    return addSortByInternal('descriptor', Sort.asc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByDescriptorDesc() {
    return addSortByInternal('descriptor', Sort.desc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByInterval() {
    return addSortByInternal('interval', Sort.asc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByIntervalDesc() {
    return addSortByInternal('interval', Sort.desc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByUsed() {
    return addSortByInternal('used', Sort.asc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByUsedDesc() {
    return addSortByInternal('used', Sort.desc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByUsedAt() {
    return addSortByInternal('usedAt', Sort.asc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByUsedAtDesc() {
    return addSortByInternal('usedAt', Sort.desc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByValue() {
    return addSortByInternal('value', Sort.asc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByValueDesc() {
    return addSortByInternal('value', Sort.desc);
  }
}

extension VoucherQueryWhereSortThenBy
    on QueryBuilder<Voucher, Voucher, QSortThenBy> {
  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByCreatedAt() {
    return addSortByInternal('createdAt', Sort.asc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByCreatedAtDesc() {
    return addSortByInternal('createdAt', Sort.desc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByDescriptor() {
    return addSortByInternal('descriptor', Sort.asc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByDescriptorDesc() {
    return addSortByInternal('descriptor', Sort.desc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByInterval() {
    return addSortByInternal('interval', Sort.asc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByIntervalDesc() {
    return addSortByInternal('interval', Sort.desc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByUsed() {
    return addSortByInternal('used', Sort.asc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByUsedDesc() {
    return addSortByInternal('used', Sort.desc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByUsedAt() {
    return addSortByInternal('usedAt', Sort.asc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByUsedAtDesc() {
    return addSortByInternal('usedAt', Sort.desc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByValue() {
    return addSortByInternal('value', Sort.asc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByValueDesc() {
    return addSortByInternal('value', Sort.desc);
  }
}

extension VoucherQueryWhereDistinct
    on QueryBuilder<Voucher, Voucher, QDistinct> {
  QueryBuilder<Voucher, Voucher, QDistinct> distinctByCreatedAt() {
    return addDistinctByInternal('createdAt');
  }

  QueryBuilder<Voucher, Voucher, QDistinct> distinctByDescriptor(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('descriptor', caseSensitive: caseSensitive);
  }

  QueryBuilder<Voucher, Voucher, QDistinct> distinctByInterval() {
    return addDistinctByInternal('interval');
  }

  QueryBuilder<Voucher, Voucher, QDistinct> distinctByUsed() {
    return addDistinctByInternal('used');
  }

  QueryBuilder<Voucher, Voucher, QDistinct> distinctByUsedAt() {
    return addDistinctByInternal('usedAt');
  }

  QueryBuilder<Voucher, Voucher, QDistinct> distinctByValue() {
    return addDistinctByInternal('value');
  }
}

extension VoucherQueryProperty
    on QueryBuilder<Voucher, Voucher, QQueryProperty> {
  QueryBuilder<Voucher, int, QQueryOperations> createdAtProperty() {
    return addPropertyNameInternal('createdAt');
  }

  QueryBuilder<Voucher, String, QQueryOperations> descriptorProperty() {
    return addPropertyNameInternal('descriptor');
  }

  QueryBuilder<Voucher, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Voucher, int, QQueryOperations> intervalProperty() {
    return addPropertyNameInternal('interval');
  }

  QueryBuilder<Voucher, bool, QQueryOperations> usedProperty() {
    return addPropertyNameInternal('used');
  }

  QueryBuilder<Voucher, int, QQueryOperations> usedAtProperty() {
    return addPropertyNameInternal('usedAt');
  }

  QueryBuilder<Voucher, int, QQueryOperations> valueProperty() {
    return addPropertyNameInternal('value');
  }
}
