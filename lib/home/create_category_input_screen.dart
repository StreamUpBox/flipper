import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/generated/l10n.dart';
import 'package:flipper/presentation/common/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CreateCategoryInputScreen extends StatefulWidget {
  CreateCategoryInputScreen({Key key}) : super(key: key);

  @override
  _CreateCategoryInputScreenState createState() =>
      _CreateCategoryInputScreenState();
}

class _CreateCategoryInputScreenState extends State<CreateCategoryInputScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: S.of(context).createCategory,
        icon: Icons.keyboard_backspace,
        multi: 3,
        bottomSpacer: 52,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: TextFormField(
            style: TextStyle(color: Colors.black),
            onChanged: (name) {
              StoreProvider.of<AppState>(context)
                  .dispatch(CategoryNameAction(name: name));
            },
            decoration:
                InputDecoration(hintText: "Name", focusColor: Colors.blue),
          ),
        ),
      ),
    );
  }
}
