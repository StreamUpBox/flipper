import 'package:moor/moor.dart';

class ItemTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get color => text()();

  IntColumn get categoryId =>
      integer().customConstraint('NULL REFERENCES category_table(id)')();
  IntColumn get branchId =>
      integer().customConstraint('NULL REFERENCES branch_table(id)')();

  IntColumn get unitId =>
      integer().customConstraint('NULL REFERENCES unit_table(id)')();

  IntColumn get variationId =>
      integer().customConstraint('NULL REFERENCES variation_table(id)')();

  // DateTimeColumn get createdAt => currentDateAndTime;
  // DateTimeColumn get updatedAt => currentDateAndTime;
}
