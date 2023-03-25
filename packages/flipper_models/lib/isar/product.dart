library flipper_models;

import 'package:flipper_models/isar/variant.dart';
import 'package:flipper_models/sync_service.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';
part 'product.g.dart';

@JsonSerializable()
@Collection()
class Product extends IJsonSerializable {
  Id? id = null;
  @Index(caseSensitive: true)
  late String name;
  String? description;
  String? taxId;
  late String color;
  late int businessId;
  @Index()
  late int branchId;
  String? supplierId;
  String? categoryId;
  String? createdAt;
  String? unit;
  String? imageUrl;
  String? expiryDate;
  @Index()
  String? barCode;
  bool? nfcEnabled;
  // This is a localID not necessary coming from remote
  @Index()
  int? bindedToTenantId;
  bool? isFavorite;

  /// as multiple devices can touch the same product, we need to track the device
  /// the onlne generated ID will be the ID other device need to use in updating so
  /// the ID of the product in all devices should be similar and other IDs.
  @Index()
  String? lastTouched;
  @Index()
  String? remoteID;
  int? localId;
  String? action;
  final variants = IsarLinks<Variant>();

  Product(
      {required this.name,
      required this.color,
      required this.businessId,
      required this.branchId,
      this.id,
      this.description,
      this.taxId,
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
      this.localId,
      this.action,
      this.remoteID});

  factory Product.fromRecord(RecordModel record) =>
      Product.fromJson(record.toJson());

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        name: json['name'],
        color: json['color'],
        localId: json['localId'],
        businessId: json['businessId'],
        branchId: json['branchId'],
        description: json['description'].isEmpty ? null : json['description'],
        taxId: json['taxId'].isEmpty ? null : json['taxId'],
        supplierId: json['supplierId'].isEmpty ? null : json['supplierId'],
        categoryId: json['categoryId'].isEmpty ? null : json['categoryId'],
        createdAt: json['createdAt'].isEmpty ? null : json['createdAt'],
        unit: json['unit'],
        imageUrl: json['imageUrl'].isEmpty ? null : json['imageUrl'],
        expiryDate: json['expiryDate'].isEmpty ? null : json['expiryDate'],
        barCode: json['barCode'].isEmpty ? null : json['barCode'],
        nfcEnabled: json['nfcEnabled'],
        bindedToTenantId: json['bindedToTenantId'],
        isFavorite: json['isFavorite'],
        lastTouched: json['lastTouched'],
        id: json['localId'],
        action: json['action'],
        remoteID: json['id']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "color": color,
      "businessId": businessId,
      "branchId": branchId,
      "description": description ?? null,
      "taxId": taxId ?? null,
      "supplierId": supplierId ?? null,
      "categoryId": categoryId ?? null,
      "createdAt": createdAt,
      "unit": unit,
      "imageUrl": imageUrl ?? null,
      "expiryDate": expiryDate,
      "barCode": barCode ?? null,
      "nfcEnabled": nfcEnabled,
      "bindedToTenantId": bindedToTenantId,
      "isFavorite": isFavorite,
      "localId": id,
      "action": action,
      "remoteID": remoteID,
    };
  }
}
