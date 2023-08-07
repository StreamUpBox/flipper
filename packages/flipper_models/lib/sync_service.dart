import 'dart:developer';
import 'dart:core';
import 'package:flipper_models/isar/random.dart';
import 'package:flipper_models/server_definitions.dart';
import 'package:flipper_models/sync.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:pocketbase/pocketbase.dart';

import 'isar_models.dart';

abstract class IJsonSerializable {
  Map<String, dynamic> toJson();
  DateTime? lastTouched = DateTime.now();
  DateTime? deletedAt;
  String? remoteId;
  String action = AppActions.create;
  int? localId;
}

class SynchronizationService<M extends IJsonSerializable>
    implements SyncApiInterface<M> {
  @override
  Future<void> push() async {
    await dirtyData();
  }

  Future<Map<String, dynamic>?> _push(M model) async {
    Type modelType = model.runtimeType;
    // Use the model type to get the corresponding endpoint from the map
    String? endpoint = serverDefinitions[modelType];

    if (endpoint != null) {
      // Convert the model to JSON using the `toJson()` method
      Map<String, dynamic> json = model.toJson();

      if (endpoint == "transactions") {
        List<TransactionItem> itemOnTransaction = await ProxyService.isar
            .transactionItems(
                transactionId: json["id"], doneWithTransaction: true);
        String namesString =
            itemOnTransaction.map((item) => item.name).join(',');
        json["itemName"] = namesString;
      }

      if (endpoint == "stocks" && json["retailPrice"] == null) {
        throw Exception("stocks has null retail price");
      }

      if (endpoint == "variants" && json["retailPrice"] == null) {
        throw Exception("variant has null retail price");
      }

      /// remove trailing dashes to sent lastTouched
      json["lastTouched"] = DateTime.now().toIso8601String();
      json['localId'] = json['id'];
      RecordModel? result = null;
      if (json['action'] == 'update' || json['action'] == 'delete') {
        result = await ProxyService.remote.update(
            data: json, collectionName: endpoint, recordId: json['remoteId']);
      } else if (json['action'] == 'create' || result == null) {
        result = await ProxyService.remote
            .create(collection: json, collectionName: endpoint);
      }
      if (result != null) {
        Map<String, dynamic> updatedJson = Map.from(result.toJson());
        updatedJson['action'] = AppActions.updated;
        return updatedJson;
      }
      return null;
    }
    return null;
  }

  @override
  void pull() async {
    ProxyService.remote.listenToChanges();
  }

  // The extracted function for updating and reporting transactions
  Future<void> _pushTransactions(Transaction transaction) async {
    /// fix@issue where the createdAt synced on server is older compared to when a transaction was completed.
    transaction.updatedAt = DateTime.now().toIso8601String();
    transaction.createdAt = DateTime.now().toIso8601String();

    Map<String, dynamic>? variantRecord = await _push(transaction as M);
    if (variantRecord != null && variantRecord.isNotEmpty) {
      Transaction o = Transaction.fromJson(variantRecord);
      o.remoteId = variantRecord['id'];

      // /// keep the local ID unchanged to avoid complication
      o.id = transaction.id;

      await ProxyService.isar.update(data: o);
    }
  }

  @override
  Future<void> dirtyData() async {
    final data = await ProxyService.isar.getUnSyncedData();

    for (Transaction transaction in data.transactions) {
      await _pushTransactions(transaction);
    }
    for (TransactionItem item in data.transactionItems) {
      int transactionItemId = item.id!;

      Map<String, dynamic>? stockRecord = await _push(item as M);
      if (stockRecord != null && stockRecord.isNotEmpty) {
        TransactionItem iItem = TransactionItem.fromJson(stockRecord);
        iItem.remoteId = stockRecord['id'];

        /// keep the local ID unchanged to avoid complication
        iItem.id = transactionItemId;
        iItem.action = AppActions.updated;

        await ProxyService.isar.update(data: iItem);
      }
    }
    for (Stock stock in data.stocks) {
      int stockId = stock.id!;

      Map<String, dynamic>? stockRecord = await _push(stock as M);
      if (stockRecord != null && stockRecord.isNotEmpty) {
        Stock s = Stock.fromJson(stockRecord);
        s.remoteId = stockRecord['id'];

        /// keep the local ID unchanged to avoid complication
        s.id = stockId;
        s.action = AppActions.updated;

        await ProxyService.isar.update(data: s);
      }
    }
    for (Variant variant in data.variants) {
      int variantId = variant.id!;

      Map<String, dynamic>? variantRecord = await _push(variant as M);
      if (variantRecord != null && variantRecord.isNotEmpty) {
        Variant va = Variant.fromJson(variantRecord);
        va.remoteId = variantRecord['id'];

        // /// keep the local ID unchanged to avoid complication
        va.id = variantId;
        va.action = AppActions.updated;
        await ProxyService.isar.update(data: va);
      }
    }

    for (Product product in data.products) {
      Map<String, dynamic>? record = await _push(product as M);
      int oldId = product.id!;
      if (record != null && record.isNotEmpty) {
        Product product = Product.fromJson(record);
        product.remoteId = record['id'];

        /// keep the local ID unchanged to avoid complication
        product.id = oldId;
        product.action = AppActions.updated;
        await ProxyService.isar.update(data: product);
      }
    }

    for (Favorite favorite in data.favorites) {
      Map<String, dynamic>? record = await _push(favorite as M);
      int oldId = favorite.id!;
      if (record != null && record.isNotEmpty) {
        Favorite fav = Favorite.fromJson(record);
        fav.remoteId = record['id'];

        /// keep the local ID unchanged to avoid complication
        fav.id = oldId;
        fav.action = AppActions.updated;
        await ProxyService.isar.update(data: fav);
      }
    }

    /// pushing devices
    for (Device device in data.devices) {
      Map<String, dynamic>? record = await _push(device as M);
      int oldId = device.id!;
      if (record != null && record.isNotEmpty) {
        Device dev = Device.fromJson(record);
        dev.remoteId = record['id'];

        /// keep the local ID unchanged to avoid complication
        dev.id = oldId;
        dev.action = AppActions.updated;
        await ProxyService.isar.update(data: dev);
      }
    }
  }
}
