library flipper_services;

import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper_models/order.dart';
import 'package:flipper_models/variation.dart';
import 'package:flipper_services/constant.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/logger.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/shared_state_service.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:uuid/uuid.dart';

class KeyPadService with ReactiveServiceMixin {
  final RxValue<double> _totalAmount = RxValue<double>();
  final _sharedStateService = locator<SharedStateService>();
  final RxValue<Order> _currentSale = RxValue<Order>(initial: null);
  Order get currentSales => _currentSale.value;

  final Logger log = Logging.getLogger('O2:)');
  double get totalAmount => _totalAmount.value;
  final DatabaseService _databaseService = ProxyService.database;

  /// create new order,this method assume a cashier is still in progress of taking order
  /// then the amount passed assume that we are dealing with custom item
  /// if the takeNewOrder is not passed it will keep updating the current active and draft order
  void createCustomAmountItemAndSell(
      {double customAmount = 0.0, bool takeNewOrder = false}) {
    final Document variation = _databaseService.getCustomProductVariant();
    final String stockId = _databaseService.getStockIdGivenProductId(
        variantId: Variation.fromMap(variation.jsonProperties).id);

    final Order order = pendingOrder(
        customAmount: customAmount,
        stockId: stockId,
        variation: Variation.fromMap(variation.jsonProperties));
    if (order.active && order.draft && !takeNewOrder) {
      final Document orderDocument = _databaseService.getById(id: order.id);
      orderDocument.properties['cashReceived'] = customAmount;
      _databaseService.update(document: orderDocument);
      _totalAmount.value = customAmount;
      notifyListeners();
      return;
    }
  }

  /// the pending order will return the existing order if draft and active are still true otherwise
  /// wise it will create a new active & draft order.
  /// Also it is very important to treat order as an item added to the
  Order pendingOrder(
      {double customAmount, String stockId, Variation variation}) {
    final q = Query(_databaseService.db,
        'SELECT  id , branchId ,variantId,stockId,variantName, reference, draft ,active , orderType , orderNUmber , subTotal , double , taxAmount , cashReceived , saleTotal  , orderNote  , status  , variationId  , productName , channels , customerChangeDue WHERE table=\$T AND draft=\$DRAFT');
    q.parameters = {'T': AppTables.order, 'DRAFT': true};
    final od = q.execute();
    Order order;

    if (od.isEmpty) {
      final id4 = Uuid().v1();
      final Document ordr = _databaseService.insert(id: id4, data: {
        'reference': id4.substring(0, 4),
        'orderNUmber': id4.substring(0, 5),
        'status': 'pending',
        'variantId': variation.id,
        'variantName': variation.name,
        'orderType': 'mobile',
        'active':
            true, //used to check if order is parked becomes parked when false.
        'draft': true,
        'channels': [_sharedStateService.user.id.toString()],
        'subTotal': customAmount,
        'table': AppTables.order,
        'cashReceived': customAmount,
        'customerChangeDue': 0.0,
        'id': id4,
        'stockId': stockId,
        'branchId': _sharedStateService.branch.id,
        'createdAt': DateTime.now().toIso8601String(),
      });
      order = Order.fromMap(ordr.jsonProperties);
      _currentSale.value = order;
      return order;
    } else {
      order = Order.fromMap(od[0]);
      _currentSale.value = order;
      return order;
    }
  }

  void updateStock({String stockId, double quantity}) {
    final Document stock = ProxyService.database.getById(id: stockId);
    stock.properties['currentStock'] =
        stock.properties['currentStock'].asDouble - quantity;
    ProxyService.database.update(document: stock);
  }
}
