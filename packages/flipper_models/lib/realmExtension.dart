import 'dart:isolate';
import 'dart:ui';

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/isolateHandelr.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/helperModels/extensions.dart';
import 'package:flipper_services/proxy.dart';
import 'package:realm/realm.dart';

extension RealmExtension on Realm {
  T writeN<T>({
    required String tableName,
    required T Function() writeCallback,
    required Function(T) onAdd,
  }) {
    assert(!_isFuture<T>(), 'writeCallback must be synchronous');
    final transaction = beginWrite();
    talker.warning("Transaction Started");
    try {
      T result = writeCallback();

      transaction.commit();
      onAdd(result);

      return result;
    } catch (e, s) {
      talker.error(s);
      if (transaction.isOpen) {
        transaction.rollback();
      }
      rethrow;
    }
  }

  void deleteN<T extends RealmObjectBase>(
      {required String tableName, required T Function() deleteCallback}) {
    T object = deleteCallback();
    _syncToFirestoreDelete(tableName, object);
    delete(object);
  }

  void put<T extends RealmObject>(
    T object, {
    required String tableName,
    Function(T)? onAdd,
  }) {
    write(() {
      add<T>(object, update: true);
      // _syncToFirestore(tableName, object);
      _spawnIsolate("transactions", IsolateHandler.handleEBMTrigger);
      if (onAdd != null) {
        onAdd(object);
      }
    });
  }

  void _syncToFirestoreDelete<T>(String tableName, T data) {
    final map = data is Stock
        ? data.toEJson(includeVariant: false)!.toFlipperJson()
        : data.toEJson().toFlipperJson();
    final id = map['id'];
    map['deleted_at'] = DateTime.now().toIso8601String();
    ProxyService.synchronize.deleteRecord(
      tableName: tableName,
      idField: tableName.singularize() + "_id",
      id: id,
    );
  }

  bool _isSubtype<S, T>() => <S>[] is List<T>;
  bool _isFuture<T>() => T != Never && _isSubtype<T, Future>();

  Future<void> _spawnIsolate(String name, dynamic isolateHandler) async {
    try {
      String encryptionKey = ProxyService.box.encryptionKey();
      Business business = ProxyService.local.realm!.query<Business>(
          r'id == $0', [ProxyService.box.getBusinessId()!]).first;

      EBM ebm = ProxyService.local.realm!.query<EBM>(
          r'businessId == $0', [ProxyService.box.getBusinessId()!]).first;

      ReceivePort receivePort = ReceivePort();
      await Isolate.spawn(
        isolateHandler,
        [
          RootIsolateToken.instance,
          receivePort.sendPort,
          ProxyService.box.getBranchId()!,
          'synced-removed',
          encryptionKey,
          business.tinNumber,
          ebm.bhfId
        ],
      );
    } catch (error) {}
  }
}
