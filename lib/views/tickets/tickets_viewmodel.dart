import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper_models/order.dart';
import 'package:flipper_models/ticket.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';
import 'package:stacked/stacked.dart';
import 'package:uuid/uuid.dart';

class TicketsViewModel extends ReactiveViewModel {
  final List<Ticket> _tickets = [];
  List<Ticket> get tickets => _tickets;
  final DatabaseService _databaseService = ProxyService.database;

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [ProxyService.sharedState, ProxyService.keypad];

  void loadTickets() {
    final ticketsQuery = Query(_databaseService.db,
        'SELECT id,orderId,ticketName,resumed,table,createdAt WHERE table=\$T');
    ticketsQuery.parameters = {
      'T': AppTables.tickets,
    }; //looking for active order joined with stock_histories
    ticketsQuery.addChangeListener((List orders) {
      // String orderId;
      // delete all and orders
      if (orders.isNotEmpty) {
        for (Map map in orders) {
          //NOTE: debuging
          // Ticket.fromMap(map).orders.toList().forEach((orderId) {
          //   _databaseService.delete(id: orderId);
          // });
          // _databaseService.delete(id: Ticket.fromMap(map).id);
          //NOTE: end of debuging.
          if (!_tickets.contains(Ticket.fromMap(map))) {
            _tickets.add(Ticket.fromMap(map));
          }
        }
        notifyListeners();
      }
    });
  }

  String _ticketName;
  String _note;
  bool _isLocked = true;
  bool get isLocked {
    return _isLocked;
  }

  void setTicketName({String ticketName}) {
    _ticketName = ticketName;
    notifyListeners();
  }

  void setNote({String note}) {
    _note = note;
    notifyListeners();
  }

  void lock() {
    _ticketName.isEmpty ? _isLocked = true : _isLocked = false;
    notifyListeners();
  }

  void saveToExistingTicket({@required String ticketId}) {
    final pendingTicket = _databaseService.getById(id: ticketId);
    ProxyService.keypad.order.listen((order) {
      List<String> ods = [];
      if (pendingTicket.properties['orders'] != null) {
        ods = Ticket.fromMap(pendingTicket.jsonProperties).orders.toList();
        ods.add(order.id);
        pendingTicket.properties['orders'] = ods;
        ProxyService.database.update(document: pendingTicket);
      }
      //create a ticke with a name then edit a ticket with orderId(s) added as array.
      final Document pending = ProxyService.database.getById(id: order.id);

      pending.properties['active'] = false;
      pending.properties['draft'] = false;
      pending.properties['orderNote'] = 'parked';
      pending.properties['status'] = 'parked';
      ProxyService.database.update(document: pending);
      // clear the current sale count.
      ProxyService.sharedState.setClear(c: true);
    });
  }

  Future<void> saveNewTicket() async {
    if (_ticketName != null) {
      ProxyService.keypad.order.listen((order) {
        final id5 = Uuid().v1();
        final Document ticket = _databaseService.insert(id: id5, data: {
          'id': id5,
          'ticketName': _ticketName,
          'table': AppTables.tickets,
          'cashReceived': 0.0, //this will be updated when complete an order.
          'note': _note,
          'resumed': false,
          'createdAt': DateTime.now().toIso8601String(),
          'channels': [ProxyService.sharedState.user.id.toString()],
          'orders': []
        });
        final pendingTicket = _databaseService.getById(id: ticket.ID);
        List<String> ods = [];
        if (pendingTicket.properties['orders'] != null) {
          ods = Ticket.fromMap(pendingTicket.jsonProperties).orders.toList();
          ods.add(order.id);
          pendingTicket.properties['orders'] = ods;
          ProxyService.database.update(document: pendingTicket);
        }
        final Document parkedOrder =
            ProxyService.database.getById(id: order.id);
        parkedOrder.properties['active'] = false;
        parkedOrder.properties['draft'] = false;
        parkedOrder.properties['orderNote'] = 'parked';
        parkedOrder.properties['status'] = 'parked';
        ProxyService.database.update(document: parkedOrder);
        // clear the current sale count.
        ProxyService.sharedState.setClear(c: true);
      });
      //create a new ticket for this order
    }
  }

  void resumeOrder({String ticketId}) {
    final Document ticket = _databaseService.getById(id: ticketId);
    // set resumable ticket this set the payable to save and with charge amount to be
    ticket.jsonProperties['orders'].toList().forEach((orderId) {
      final Document pendingOrder = ProxyService.database.getById(id: orderId);
      pendingOrder.properties['active'] = true;
      pendingOrder.properties['draft'] = true;
      ProxyService.database.update(document: pendingOrder);

      ticket.properties['createdAt'] = DateTime.now().toIso8601String();
      ProxyService.database.update(document: ticket);
    });
    ticket.properties['resumed'] = true;
    ProxyService.database.update(document: ticket);
  }
}
