import 'dart:developer';

import 'package:flipper_dashboard/Refund.dart';
import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_socials/ui/views/home/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:talker_flutter/talker_flutter.dart';

class DataView extends StatefulWidget {
  const DataView({
    super.key,
    required this.transactions,
    required this.startDate,
    required this.endDate,
    required this.workBookKey,
    required this.showPluReport,
    required this.rowsPerPage,
    required this.transactionItems,
  });

  final List<ITransaction> transactions;
  final DateTime startDate;
  final DateTime endDate;
  final GlobalKey<SfDataGridState> workBookKey;
  final bool showPluReport;
  final int rowsPerPage;
  final List<TransactionItem>? transactionItems;

  @override
  _DataViewState createState() => _DataViewState();
}

class _DataViewState extends State<DataView> {
  static const double dataPagerHeight = 60;
  DataGridSource? _dataGridSource; // Make it nullable
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // _dataGridSource.removeListener(updateWidget); // Remove this line
    super.dispose();
  }

  final talker = TalkerFlutter.init();

  void handleCellTap(DataGridCellTapDetails details) {
    final rowIndex = details.rowColumnIndex.rowIndex;
    if (rowIndex < 1) return;

    final dataSource = _dataGridSource as DynamicDataSource;
    final data = dataSource.data[pageIndex == 0 ? rowIndex - 1 : rowIndex - 1];

    talker.warning('Tapped row: ID = ${data.id}, Name = ${data.subTotal}');
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => OptionModal(
        child: Refund(
          refundAmount: data.subTotal,
          transactionId: data.id.toString(),
          currency: "RWF",
          transaction: data is ITransaction ? data : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const EdgeInsets headerPadding =
        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);

    // Update _dataGridSource based on widget.showPluReport
    _dataGridSource = _buildDataGridSource(widget.showPluReport,
        widget.transactionItems, widget.transactions, widget.rowsPerPage);

    return ViewModelBuilder.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onViewModelReady: (model) {},
      builder: (context, model, child) {
        return Scaffold(
          body: LayoutBuilder(
            builder: (context, constraint) {
              return Column(
                children: [
                  Expanded(
                    child: SfDataGridTheme(
                      data: SfDataGridThemeData(
                        headerHoverColor: Colors.yellow,
                        gridLineColor: Colors.amber,
                        gridLineStrokeWidth: 1.0,
                        rowHoverColor: Colors.yellow,
                        selectionColor: Colors.yellow,
                        rowHoverTextStyle: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                      child: SizedBox(
                        height: constraint.maxHeight - dataPagerHeight,
                        width: constraint.maxWidth,
                        child: SfDataGrid(
                          rowsPerPage: widget.rowsPerPage,
                          allowFiltering: true,
                          highlightRowOnHover: true,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          key: widget.workBookKey,
                          source:
                              _dataGridSource!, // Make sure _dataGridSource is not null
                          columnWidthMode: ColumnWidthMode.fill,
                          onCellTap: handleCellTap,
                          columns: widget.showPluReport
                              ? pluReportTableHeader(headerPadding)
                              : zReportTableHeader(headerPadding),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: dataPagerHeight,
                    child: SfDataPager(
                      lastPageItemVisible: false,
                      nextPageItemVisible: false,
                      delegate: _dataGridSource!,
                      pageCount:
                          (_dataGridSource!.rows.length / widget.rowsPerPage)
                              .ceilToDouble(),
                      direction: Axis.horizontal,
                      onPageNavigationEnd: (index) {
                        log("Page Index ${index}");
                        setState(() {
                          pageIndex = index;
                        });
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  List<GridColumn> pluReportTableHeader(EdgeInsets headerPadding) {
    return <GridColumn>[
      GridColumn(
        columnName: 'ItemCode',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('Item Code', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'Name',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('Name', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'Price',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('Price', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'TaxRate',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('Tax Rate', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'StockRemain',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('Stock Remain', overflow: TextOverflow.ellipsis),
        ),
      ),
    ];
  }

  List<GridColumn> zReportTableHeader(EdgeInsets headerPadding) {
    return <GridColumn>[
      GridColumn(
        columnName: 'id',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('ID', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'Type',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('Type', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'Amount',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('Amount', overflow: TextOverflow.ellipsis),
        ),
      ),
      GridColumn(
        columnName: 'CashReceived',
        label: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: headerPadding,
          alignment: Alignment.center,
          child: const Text('Cash Received', overflow: TextOverflow.ellipsis),
        ),
      ),
    ];
  }

  DataGridSource _buildDataGridSource(
      bool showPluReport,
      List<TransactionItem>? transactionItem,
      List<ITransaction> transactions,
      int rowsPerPage) {
    if (showPluReport) {
      return TransactionItemDataSource(
          transactionItem!, rowsPerPage, showPluReport);
    } else {
      return TransactionDataSource(transactions, rowsPerPage, showPluReport);
    }
  }
}

abstract class DynamicDataSource extends DataGridSource {
  List<dynamic> data = []; // Store the data
  bool showPluReport = false; // Add this property

  // Update the rows getter to dynamically check showPluReport
  @override
  List<DataGridRow> get rows {
    if (showPluReport) {
      return data.map((item) {
        String name = item.name.split('(')[0];
        String number = ''; // Initialize number to an empty stringg

        // Only try to split and get the number if the name has a '('
        if (item.name.contains('(')) {
          number = item.name.split('(')[1].split(')')[0];
        }
        name = name.toUpperCase();

        Configurations configurations =
            ProxyService.realm.getByTaxType(taxtype: item.taxTyCd ?? "B");

        String formattedName = '$name-$number';
        if (item is TransactionItem) {
          return DataGridRow(cells: [
            DataGridCell<String>(
                columnName: 'ItemCode', value: item.itemClsCd.toString()),
            DataGridCell<String>(columnName: 'Name', value: formattedName),
            DataGridCell<double>(columnName: 'Price', value: item.price),
            DataGridCell<double>(
                columnName: 'TaxRate', value: configurations.taxPercentage),
            DataGridCell<double>(
                columnName: 'StockRemain', value: item.remainingStock),
          ]);
        } else {
          // Handle the case where item is not a TransactionItem
          return DataGridRow(cells: []);
        }
      }).toList();
    } else {
      return data.map((item) {
        if (item is ITransaction) {
          return DataGridRow(cells: [
            DataGridCell<String>(columnName: 'Name', value: item.id.toString()),
            DataGridCell<String>(
                columnName: 'Type', value: item.receiptType ?? "-"),
            DataGridCell<double>(columnName: 'Amount', value: item.subTotal),
            DataGridCell<double>(
                columnName: 'CashReceived', value: item.cashReceived),
          ]);
        } else {
          // Handle the case where item is not an ITransaction
          return DataGridRow(cells: []);
        }
      }).toList();
    }
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(e.value.toString()),
        );
      }).toList(),
    );
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    // Handle page change logic here
    return true;
  }

  void buildPaginatedDataGridRows() {
    // Build data grid rows for the current page
  }
}

class TransactionDataSource extends DynamicDataSource {
  TransactionDataSource(
      List<ITransaction> transactions, this.rowsPerPage, this.showPluReport) {
    data = transactions;
    buildPaginatedDataGridRows();
  }

  final int rowsPerPage;
  bool showPluReport;
  @override
  void buildPaginatedDataGridRows() {
    data = data.sublist(
      0,
      data.length > rowsPerPage ? rowsPerPage : data.length,
    );
  }
}

class TransactionItemDataSource extends DynamicDataSource {
  final int rowsPerPage;
  TransactionItemDataSource(
      this.transactionItems, this.rowsPerPage, this.showPluReport) {
    // Initialize 'transactions'
    buildPaginatedDataGridRows();
  }

  final List<TransactionItem> transactionItems;

  bool showPluReport;

  @override
  void buildPaginatedDataGridRows() {
    if (transactionItems.isNotEmpty) {
      data = transactionItems;
    }
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    final int startRowIndex = newPageIndex * rowsPerPage;
    final int endIndex = startRowIndex + rowsPerPage;

    if (startRowIndex < transactionItems.length) {
      List<TransactionItem> items = transactionItems;

      if (startRowIndex < items.length) {
        data = items.sublist(
          startRowIndex,
          endIndex > items.length ? items.length : endIndex,
        );
        notifyListeners();
        return true;
      } else {
        return false; // Prevent page change
      }
    } else {
      return false; // Prevent page change
    }
  }
}
