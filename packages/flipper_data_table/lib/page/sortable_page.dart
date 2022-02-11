import 'package:flipper_data_table/widget/scrollable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/models/models.dart';

class SortablePage extends StatefulWidget {
  const SortablePage({Key? key, required this.columns, required this.data})
      : super(key: key);
  final List<String> columns;
  final List<OrderItemSync> data;

  @override
  _SortablePageState createState() => _SortablePageState();
}

class _SortablePageState extends State<SortablePage> {
  int? sortColumnIndex;
  bool isAscending = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      ScrollableWidget(child: buildDataTable());

  Widget buildDataTable() {
    return SizedBox(
      height: MediaQuery.of(context).size.width,
      child: DataTable(
        sortAscending: isAscending,
        sortColumnIndex: sortColumnIndex,
        columns: getColumns(widget.columns),
        rows: getRows(widget.data),
      ),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map(
        (String column) => DataColumn(
          label: Text(column),
          onSort: onSort,
        ),
      )
      .toList();

  List<DataRow> getRows(List<OrderItemSync> users) =>
      users.map((OrderItemSync user) {
        final cells = [
          user.name,
          user.price,
          user.discount,
          user.remainingStock,
          user.type,
          user.createdAt
        ];

        return DataRow(
          cells: getCells(cells),
        );
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      widget.data.sort(
          (user1, user2) => compareString(ascending, user1.name, user2.name));
    } else if (columnIndex == 1) {
      widget.data.sort((user1, user2) => compareString(
          ascending, user1.price.toString(), user2.price.toString()));
    } else if (columnIndex == 2) {
      widget.data.sort((user1, user2) =>
          compareString(ascending, '${user1.discount}', '${user2.discount}'));
    }

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}
