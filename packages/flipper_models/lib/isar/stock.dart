library flipper_models;

import 'package:flipper_models/sync_service.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';
part 'stock.g.dart';

@JsonSerializable()
@Collection()
class Stock extends IJsonSerializable {
  Id? id = null;
  @Index()
  late int branchId;
  @Index(composite: [CompositeIndex('branchId')])
  late int variantId;
  double? lowStock;
  late double currentStock;

  bool? canTrackingStock;
  bool? showLowStockAlert;
  @Index()
  late int productId;
  bool? active;
  // the value of stock is currentStock * retailPrice
  double? value;
  // RRA fields
  double? rsdQty;
  @Index()
  double? supplyPrice;
  @Index()
  double? retailPrice;
  @Index()
  String? lastTouched;
  @Index()
  String? remoteID;
  int? localId;
  String? action;
  Stock(
      {required this.branchId,
      required this.variantId,
      required this.currentStock,
      required this.productId,
      this.id,
      this.action,
      this.lowStock,
      this.supplyPrice,
      this.retailPrice,
      this.canTrackingStock,
      this.showLowStockAlert,
      this.active,
      this.value,
      this.rsdQty,
      this.lastTouched,
      this.remoteID,
      this.localId});

  @override
  Map<String, dynamic> toJson() => {
        'branchId': branchId,
        'variantId': variantId,
        'lowStock': lowStock,
        'currentStock': currentStock,
        'supplyPrice': supplyPrice,
        'retailPrice': retailPrice,
        'canTrackingStock': canTrackingStock,
        'showLowStockAlert': showLowStockAlert,
        'productId': productId,
        'active': active,
        'value': value,
        'rsdQty': rsdQty,
        "localId": id,
        "action": action,
        "remoteID": remoteID,
      };
  factory Stock.fromRecord(RecordModel record) =>
      Stock.fromJson(record.toJson());
  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
        branchId: json['branchId'],
        localId: json['localId'],
        variantId: json['variantId'],
        lowStock: json['lowStock']?.toDouble() ?? 0.0,
        currentStock: json['currentStock']?.toDouble() ?? 0.0,
        supplyPrice: json['supplyPrice']?.toDouble() ?? 0.0,
        retailPrice: json['retailPrice']?.toDouble() ?? 0.0,
        canTrackingStock: json['canTrackingStock'],
        showLowStockAlert: json['showLowStockAlert'],
        productId: json['productId'],
        active: json['active'],
        value: json['value']?.toDouble() ?? 0.0,
        rsdQty: json['rsdQty']?.toDouble() ?? 0.0,
        lastTouched: json['lastTouched'],
        id: json['localId'],
        action: json['action'],
        remoteID: json['id']);
  }
}
