import 'package:customappbar/customappbar.dart';
import 'package:flipper/model/unit.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/ui/product/add/add_product_viewmodel.dart';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AddUnitTypeScreen extends StatelessWidget {
  const AddUnitTypeScreen({
    Key key,
    
  }) : super(key: key);


  List<Widget> _getUnitsWidgets(List<Unit> units, AddProductViewmodel model) {
    final List<Widget> list = <Widget>[];
    for (var i = 0; i < units.length; i++) {
      if (units[i].focused && model.product.id != null) {
        model.updateProductWithCurrentUnit(unit: units[i]);
      }
      list.add(
        GestureDetector(
          onTap: () {
            model.saveFocusedUnit(unit: units[i]);
          },
          child: ListTile(
            title: Text(
              units[i].name,
              style: const TextStyle(color: Colors.black),
            ),
            trailing: Radio(
              value: units[i].id,
              groupValue: units[i].focused ? units[i].id : 0,
              onChanged: (Object value) {},
            ),
          ),
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(builder: (BuildContext context,AddProductViewmodel model, Widget child){
      return Scaffold(
          appBar: CommonAppBar(
            onPop: () {
              ProxyService.nav.pop();
            },
            title: 'Edit Unit',
            showActionButton: true,
            disableButton: false,
            actionButtonName: 'Save',
            onPressedCallback: () {
              ProxyService.nav.pop();
            },
            icon: Icons.close,
            multi: 3,
            bottomSpacer: 52,
          ),
          body: Stack(
            children: [
              model.units.isEmpty
                  ? const SizedBox.shrink()
                  : ListView(
                      children: ListTile.divideTiles(
                        context: context,
                        tiles: _getUnitsWidgets(model.units,model),
                      ).toList(),
                    )
            ],
          ),
        );
    }, viewModelBuilder: ()=>AddProductViewmodel());
  }
}
