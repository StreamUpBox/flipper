import 'dart:convert';
import 'dart:io';

import 'package:flipper_models/objectbox.g.dart';
import 'package:flipper_models/order.dart';
import 'package:flipper_models/spenn.dart';
import 'package:flipper_models/variation.dart';

import 'package:flipper_models/variant_stock.dart';

import 'package:flipper_models/unit.dart';

import 'package:flipper_models/sync.dart';

import 'package:flipper_models/stock.dart';

import 'package:flipper_models/product.dart';

import 'package:flipper_models/login.dart';

import 'package:flipper_models/color.dart';

import 'package:flipper_models/category.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/business.dart';

import 'package:flipper_models/branch.dart';
import 'package:flipper_services/http_api.dart';
import 'abstractions/api.dart';
import 'package:http/http.dart' as http;

class ObjectBoxApi implements Api {
  ExtendedClient client = ExtendedClient(http.Client());
  String flipperApi = "https://flipper.yegobox.com";
  String apihub = "https://apihub.yegobox.com";
  late Store _store;
  ObjectBoxApi({required Directory dir}) {
    // Note: getObjectBoxModel() is generated for you in objectbox.g.dart
    _store = Store(getObjectBoxModel(), directory: dir.path + '/db2');
  }
  @override
  Future<List<Unit>> units({required int branchId}) async {
    return _store
        .box<Unit>()
        .getAll()
        .where((unit) => unit.branchId == branchId)
        .toList();
  }

  @override
  Future<List<Business>> businesses() async {
    final response = await client.get(Uri.parse("$apihub/api/businesses"));
    return businessFromJson(response.body);
  }

  @override
  Future<List<Category>> categories({required int branchId}) async {
    return _store
        .box<Category>()
        .getAll()
        .where((category) => category.branchId == branchId)
        .toList();
  }

  @override
  Future<List<PColor>> colors({required int branchId}) async {
    return _store
        .box<PColor>()
        .getAll()
        .where((color) => color.branchId == branchId)
        .toList();
  }

  @override
  Future<int> create<T>({required Map data, required String endPoint}) async {
    if (endPoint == 'color') {
      for (String co in data['colors']) {
        final box = _store.box<PColor>();
        final color = PColor(
          id: DateTime.now().millisecondsSinceEpoch,
          name: co,
          channels: data['channels'],
          table: data['table'],
          branchId: data['branchId'],
          active: data['active'],
        );
        box.put(color);
      }
      return 200;
    }
    return 200;
  }

  @override
  Future<List<Product>> isTempProductExist() async {
    return _store
        .box<Product>()
        .getAll()
        .where((product) => product.name == 'temp')
        .toList();
  }

  @override
  Future<List<Product>> products() async {
    return _store.box<Product>().getAll();
  }

  @override
  Future<bool> logOut() async {
    ProxyService.box.remove(key: 'userId');
    ProxyService.box.remove(key: 'bearerToken');
    ProxyService.box.remove(key: 'branchId');
    ProxyService.box.remove(key: 'UToken');
    ProxyService.box.remove(key: 'businessId');
    ProxyService.box.remove(key: 'branchId');
    return true;
  }

  @override
  Future<Login> login({required String phone}) async {
    final response = await client
        .post(Uri.parse("$flipperApi/open-login"), body: {'phone': phone});
    final Login resp = loginFromJson(response.body);
    ProxyService.box.write(key: 'UToken', value: resp.token);
    return resp;
  }

  @override
  Future<int> signup({required Map business}) async {
    final http.Response response = await client.post(
        Uri.parse("$apihub/api/business"),
        body: jsonEncode(business),
        headers: {'Content-Type': 'application/json'});
    return response.statusCode;
  }

  @override
  Future<List<Stock>> stocks({required int productId}) async {
    return _store
        .box<Stock>()
        .getAll()
        .where((stock) => stock.productId == productId)
        .toList();
  }

  @override
  Future<Variation> variant({required int variantId}) {
    // TODO: implement variant
    throw UnimplementedError();
  }

  @override
  Future<List<Variation>> variants(
      {required int branchId, required int productId}) async {
    return _store
        .box<Variation>()
        .getAll()
        .where((stock) => stock.productId == productId)
        .toList();
  }

  @override
  Future<int> addUnits({required Map data}) async {
    for (Map map in data['units']) {
      final box = _store.box<Unit>();

      final unit = Unit(
        active: false,
        branchId: data['branchId'],
        table: data['table'],
        channels: data['channels'],
        value: map['value'],
        name: map['name'],
      );

      box.put(unit);
    }
    return 200;
  }

  @override
  Future<List<VariantStock>> variantStock(
      {required int branchId, required int variantId}) async {
    return _store
        .box<VariantStock>()
        .getAll()
        .where((v) => v.variantId == variantId)
        .toList();
  }

  @override
  Future<bool> delete({required dynamic id, String? endPoint}) async {
    switch (endPoint) {
      case 'color':
        _store.box<PColor>().remove(id);
        break;
      default:
    }
    return true;
  }

  @override
  Future<int> addVariant(
      {required List<Variation> data,
      required double retailPrice,
      required double supplyPrice}) async {
    for (Variation variation in data) {
      Map d = variation.toJson();
      final box = _store.box<Variation>();
      final variantId = box.put(variation);
      final stockId = DateTime.now().millisecondsSinceEpoch;
      String? userId = ProxyService.box.read(key: 'userId');
      final stock = new Stock(
        id: stockId,
        branchId: d['branchId'],
        variantId: variantId,
        lowStock: 0.0,
        currentStock: 0.0,
        supplyPrice: supplyPrice,
        retailPrice: retailPrice,
        canTrackingStock: false,
        showLowStockAlert: false,
        channels: [userId!],
        table: AppTables.stock,
        productId: d['productId'],
        value: 0,
        active: false,
      );
      final stockBox = _store.box<Stock>();
      stockBox.put(stock);
    }
    return 200;
  }

  @override
  Future<List<Branch>> branches({required int businessId}) {
    // TODO: implement branches
    throw UnimplementedError();
  }

  @override
  Future<void> collectCashPayment(
      {required double cashReceived, required OrderF order}) {
    // TODO: implement collectCashPayment
    throw UnimplementedError();
  }

  @override
  Future<OrderF> createOrder(
      {required double customAmount,
      required Variation variation,
      required double price,
      bool useProductName = false,
      String orderType = 'custom',
      double quantity = 1}) {
    // TODO: implement createOrder
    throw UnimplementedError();
  }

  @override
  Future<Product> createProduct({required Product product}) {
    // TODO: implement createProduct
    throw UnimplementedError();
  }

  @override
  Future<PColor> getColor({required int id, String? endPoint}) {
    // TODO: implement getColor
    throw UnimplementedError();
  }

  @override
  Future<Variation> getCustomProductVariant() {
    // TODO: implement getCustomProductVariant
    throw UnimplementedError();
  }

  @override
  Future<Product> getProduct({required String id}) {
    // TODO: implement getProduct
    throw UnimplementedError();
  }

  @override
  Future<List<OrderF>> orders() {
    // TODO: implement orders
    throw UnimplementedError();
  }

  @override
  Future<Spenn> spennPayment({required double amount, required phoneNumber}) {
    // TODO: implement spennPayment
    throw UnimplementedError();
  }

  @override
  Future<Stock> stockByVariantId({required int variantId}) {
    // TODO: implement stockByVariantId
    throw UnimplementedError();
  }

  @override
  Stream<Stock> stockByVariantIdStream({required int variantId}) {
    // TODO: implement stockByVariantIdStream
    throw UnimplementedError();
  }

  @override
  Future<int> update<T>({required Map data, required String endPoint}) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<SyncF> authenticateWithOfflineDb({required String userId}) {
    // TODO: implement authenticateWithOfflineDb
    throw UnimplementedError();
  }
}
