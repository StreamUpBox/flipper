import 'package:moor/moor.dart';

class TabsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tab => integer().nullable()();

  // DateTimeColumn get createdAt => currentDateAndTime;
  // DateTimeColumn get updatedAt => currentDateAndTime;
}
