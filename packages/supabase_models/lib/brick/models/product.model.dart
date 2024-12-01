import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:supabase_models/brick/models/composite.model.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'products'),
  sqliteConfig: SqliteSerializable(),
)
class Product extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  @Supabase(unique: true)
  final int id;

  final String name;
  String? description;
  String? taxId;
  String color;
  final int businessId;

  final int branchId;
  String? supplierId;
  int? categoryId;
  String? createdAt;
  String? unit;
  String? imageUrl;
  String? expiryDate;

  String? barCode;
  @Supabase(defaultValue: "false")
  bool? nfcEnabled;

  int? bindedToTenantId;
  @Supabase(defaultValue: "false")
  bool? isFavorite;

  DateTime? lastTouched;

  DateTime? deletedAt;

  String? spplrNm;
  @Supabase(defaultValue: "false")
  bool? isComposite;

  @Supabase(name: "composites")
  final List<Composite>? composites;

  Product({
    required this.id,
    required this.name,
    this.description,
    this.taxId,
    required this.color,
    required this.businessId,
    required this.branchId,
    this.supplierId,
    this.categoryId,
    this.createdAt,
    this.unit,
    this.imageUrl,
    this.expiryDate,
    this.barCode,
    this.nfcEnabled,
    this.bindedToTenantId,
    this.isFavorite,
    this.lastTouched,
    this.deletedAt,
    this.spplrNm,
    this.isComposite,
    this.composites = const [], // Initialize as an empty list
  });
}
