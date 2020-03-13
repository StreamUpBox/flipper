import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/generated/l10n.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class VariationList extends StatefulWidget {
  @override
  _VariationListState createState() => _VariationListState();
}

class _VariationListState extends State<VariationList> {
  _buildVariationsList(
      List<VariationTableData> variations, CommonViewModel vm) {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < variations.length; i++) {
      if (variations[i].name != 'tmp') {
        list.add(
          Center(
            child: SizedBox(
              height: 90,
              width: 350,
              child: ListView(children: <Widget>[
                StreamBuilder(
                    stream: vm.database.stockDao.getStockByVariantStream(
                        branchId: vm.branch.id, variationId: variations[i].id),
                    builder: (context,
                        AsyncSnapshot<List<StockTableData>> snapshot) {
                      if (snapshot.data == null) {
                        return Text("");
                      }
                      return ListTile(
                        leading: Icon(
                          Icons.dehaze,
                        ),
                        subtitle: Text(
                            "${variations[i].name} \nRWF ${snapshot.data[0].retailPrice}"),
                        trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              FlatButton(
                                child: Text(
                                  snapshot.data[0].currentStock == 0
                                      ? S.of(context).receiveStock
                                      : snapshot.data[0].currentStock
                                              .toString() +
                                          S.of(context).inStock,
                                ),
                                onPressed: () {
                                  Router.navigator.pushNamed(
                                    Router.receiveStock,
                                    arguments: ReceiveStockScreenArguments(
                                      variationId: variations[i].id,
                                    ),
                                  );
                                },
                              ),
                            ]),
                        dense: true,
                      );
                    })
              ]),
            ),
          ),
        );
      }
    }
    if (list.length == 0) {
      return Container();
    }
    return Column(children: list);
  }

//  List<Widget> buildButton(AsyncSnapshot<List<StockTableData>> stock,
//      BuildContext context, VariationTableData variation) {
//    List<Widget> buttons = [];
//    for (var i = 0; i < stock.data.length; i++) {
//      buttons.add(
//        FlatButton(
//          child: Text(
//            stock.data[i].currentStock == 0
//                ? S.of(context).receiveStock
//                : stock.data[i].currentStock.toString() + S.of(context).inStock,
//          ),
//          onPressed: () {
//            Router.navigator.pushNamed(
//              Router.receiveStock,
//              arguments: ReceiveStockScreenArguments(
//                variationId: variation.id,
//              ),
//            );
//          },
//        ),
//      );
//    }
//
//    return buttons;
//  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (context, vm) {
        return StreamBuilder(
          stream:
              vm.database.variationDao.getItemVariationsByItemId(vm.tmpItem.id),
          builder: (context, AsyncSnapshot<List<VariationTableData>> snapshot) {
            if (snapshot.data == null) {
              return Text("");
            }
            return snapshot.data != 0
                ? _buildVariationsList(snapshot.data, vm)
                : Text("");
          },
        );
      },
    );
  }
}
