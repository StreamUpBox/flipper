// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250215104421_up = [
  InsertColumn('financing_id', Column.varchar, onTable: 'InventoryRequest'),
  InsertColumn('finance_provider_id', Column.varchar, onTable: 'Financing')
];

const List<MigrationCommand> _migration_20250215104421_down = [
  DropColumn('financing_id', onTable: 'InventoryRequest'),
  DropColumn('finance_provider_id', onTable: 'Financing')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250215104421',
  up: _migration_20250215104421_up,
  down: _migration_20250215104421_down,
)
class Migration20250215104421 extends Migration {
  const Migration20250215104421()
    : super(
        version: 20250215104421,
        up: _migration_20250215104421_up,
        down: _migration_20250215104421_down,
      );
}
