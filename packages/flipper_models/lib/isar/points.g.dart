// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers, inference_failure_on_function_invocation

extension GetPointsCollection on Isar {
  IsarCollection<Points> get pointss => getCollection();
}

const PointsSchema = CollectionSchema(
  name: 'Points',
  schema:
      '{"name":"Points","idName":"id","properties":[{"name":"userId","type":"Long"},{"name":"value","type":"Long"}],"indexes":[{"name":"userId","unique":false,"replace":false,"properties":[{"name":"userId","type":"Value","caseSensitive":false}]}],"links":[]}',
  idName: 'id',
  propertyIds: {'userId': 0, 'value': 1},
  listProperties: {},
  indexIds: {'userId': 0},
  indexValueTypes: {
    'userId': [
      IndexValueType.long,
    ]
  },
  linkIds: {},
  backlinkLinkNames: {},
  getId: _pointsGetId,
  setId: _pointsSetId,
  getLinks: _pointsGetLinks,
  attachLinks: _pointsAttachLinks,
  serializeNative: _pointsSerializeNative,
  deserializeNative: _pointsDeserializeNative,
  deserializePropNative: _pointsDeserializePropNative,
  serializeWeb: _pointsSerializeWeb,
  deserializeWeb: _pointsDeserializeWeb,
  deserializePropWeb: _pointsDeserializePropWeb,
  version: 4,
);

int? _pointsGetId(Points object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _pointsSetId(Points object, int id) {
  object.id = id;
}

List<IsarLinkBase<dynamic>> _pointsGetLinks(Points object) {
  return [];
}

void _pointsSerializeNative(IsarCollection<Points> collection, IsarCObject cObj,
    Points object, int staticSize, List<int> offsets, AdapterAlloc alloc) {
  final size = staticSize;
  cObj.buffer = alloc(size);
  cObj.buffer_length = size;

  final buffer = IsarNative.bufAsBytes(cObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeLong(offsets[0], object.userId);
  writer.writeLong(offsets[1], object.value);
}

Points _pointsDeserializeNative(IsarCollection<Points> collection, int id,
    IsarBinaryReader reader, List<int> offsets) {
  final object = Points(
    id: id,
    userId: reader.readLong(offsets[0]),
    value: reader.readLong(offsets[1]),
  );
  return object;
}

P _pointsDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    default:
      throw 'Illegal propertyIndex';
  }
}

Object _pointsSerializeWeb(IsarCollection<Points> collection, Points object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(jsObj, 'userId', object.userId);
  IsarNative.jsObjectSet(jsObj, 'value', object.value);
  return jsObj;
}

Points _pointsDeserializeWeb(IsarCollection<Points> collection, Object jsObj) {
  final object = Points(
    id: IsarNative.jsObjectGet(jsObj, 'id') ?? (double.negativeInfinity as int),
    userId: IsarNative.jsObjectGet(jsObj, 'userId') ??
        (double.negativeInfinity as int),
    value: IsarNative.jsObjectGet(jsObj, 'value') ??
        (double.negativeInfinity as int),
  );
  return object;
}

P _pointsDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'id':
      return (IsarNative.jsObjectGet(jsObj, 'id') ??
          (double.negativeInfinity as int)) as P;
    case 'userId':
      return (IsarNative.jsObjectGet(jsObj, 'userId') ??
          (double.negativeInfinity as int)) as P;
    case 'value':
      return (IsarNative.jsObjectGet(jsObj, 'value') ??
          (double.negativeInfinity as int)) as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _pointsAttachLinks(IsarCollection<dynamic> col, int id, Points object) {}

extension PointsQueryWhereSort on QueryBuilder<Points, Points, QWhere> {
  QueryBuilder<Points, Points, QAfterWhere> anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }

  QueryBuilder<Points, Points, QAfterWhere> anyUserId() {
    return addWhereClauseInternal(
        const IndexWhereClause.any(indexName: 'userId'));
  }
}

extension PointsQueryWhere on QueryBuilder<Points, Points, QWhereClause> {
  QueryBuilder<Points, Points, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<Points, Points, QAfterWhereClause> idNotEqualTo(int id) {
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

  QueryBuilder<Points, Points, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<Points, Points, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<Points, Points, QAfterWhereClause> idBetween(
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

  QueryBuilder<Points, Points, QAfterWhereClause> userIdEqualTo(int userId) {
    return addWhereClauseInternal(IndexWhereClause.equalTo(
      indexName: 'userId',
      value: [userId],
    ));
  }

  QueryBuilder<Points, Points, QAfterWhereClause> userIdNotEqualTo(int userId) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'userId',
        upper: [userId],
        includeUpper: false,
      )).addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'userId',
        lower: [userId],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'userId',
        lower: [userId],
        includeLower: false,
      )).addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'userId',
        upper: [userId],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<Points, Points, QAfterWhereClause> userIdGreaterThan(
    int userId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(IndexWhereClause.greaterThan(
      indexName: 'userId',
      lower: [userId],
      includeLower: include,
    ));
  }

  QueryBuilder<Points, Points, QAfterWhereClause> userIdLessThan(
    int userId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(IndexWhereClause.lessThan(
      indexName: 'userId',
      upper: [userId],
      includeUpper: include,
    ));
  }

  QueryBuilder<Points, Points, QAfterWhereClause> userIdBetween(
    int lowerUserId,
    int upperUserId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(IndexWhereClause.between(
      indexName: 'userId',
      lower: [lowerUserId],
      includeLower: includeLower,
      upper: [upperUserId],
      includeUpper: includeUpper,
    ));
  }
}

extension PointsQueryFilter on QueryBuilder<Points, Points, QFilterCondition> {
  QueryBuilder<Points, Points, QAfterFilterCondition> idEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition.equalTo(
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Points, Points, QAfterFilterCondition> idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition.greaterThan(
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Points, Points, QAfterFilterCondition> idLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition.lessThan(
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Points, Points, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Points, Points, QAfterFilterCondition> userIdEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition.equalTo(
      property: 'userId',
      value: value,
    ));
  }

  QueryBuilder<Points, Points, QAfterFilterCondition> userIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition.greaterThan(
      include: include,
      property: 'userId',
      value: value,
    ));
  }

  QueryBuilder<Points, Points, QAfterFilterCondition> userIdLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition.lessThan(
      include: include,
      property: 'userId',
      value: value,
    ));
  }

  QueryBuilder<Points, Points, QAfterFilterCondition> userIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'userId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Points, Points, QAfterFilterCondition> valueEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition.equalTo(
      property: 'value',
      value: value,
    ));
  }

  QueryBuilder<Points, Points, QAfterFilterCondition> valueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition.greaterThan(
      include: include,
      property: 'value',
      value: value,
    ));
  }

  QueryBuilder<Points, Points, QAfterFilterCondition> valueLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition.lessThan(
      include: include,
      property: 'value',
      value: value,
    ));
  }

  QueryBuilder<Points, Points, QAfterFilterCondition> valueBetween(
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

extension PointsQueryLinks on QueryBuilder<Points, Points, QFilterCondition> {}

extension PointsQueryWhereSortBy on QueryBuilder<Points, Points, QSortBy> {
  QueryBuilder<Points, Points, QAfterSortBy> sortByUserId() {
    return addSortByInternal('userId', Sort.asc);
  }

  QueryBuilder<Points, Points, QAfterSortBy> sortByUserIdDesc() {
    return addSortByInternal('userId', Sort.desc);
  }

  QueryBuilder<Points, Points, QAfterSortBy> sortByValue() {
    return addSortByInternal('value', Sort.asc);
  }

  QueryBuilder<Points, Points, QAfterSortBy> sortByValueDesc() {
    return addSortByInternal('value', Sort.desc);
  }
}

extension PointsQueryWhereSortThenBy
    on QueryBuilder<Points, Points, QSortThenBy> {
  QueryBuilder<Points, Points, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Points, Points, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Points, Points, QAfterSortBy> thenByUserId() {
    return addSortByInternal('userId', Sort.asc);
  }

  QueryBuilder<Points, Points, QAfterSortBy> thenByUserIdDesc() {
    return addSortByInternal('userId', Sort.desc);
  }

  QueryBuilder<Points, Points, QAfterSortBy> thenByValue() {
    return addSortByInternal('value', Sort.asc);
  }

  QueryBuilder<Points, Points, QAfterSortBy> thenByValueDesc() {
    return addSortByInternal('value', Sort.desc);
  }
}

extension PointsQueryWhereDistinct on QueryBuilder<Points, Points, QDistinct> {
  QueryBuilder<Points, Points, QDistinct> distinctByUserId() {
    return addDistinctByInternal('userId');
  }

  QueryBuilder<Points, Points, QDistinct> distinctByValue() {
    return addDistinctByInternal('value');
  }
}

extension PointsQueryProperty on QueryBuilder<Points, Points, QQueryProperty> {
  QueryBuilder<Points, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Points, int, QQueryOperations> userIdProperty() {
    return addPropertyNameInternal('userId');
  }

  QueryBuilder<Points, int, QQueryOperations> valueProperty() {
    return addPropertyNameInternal('value');
  }
}
