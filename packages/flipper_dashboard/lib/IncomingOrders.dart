import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flipper_dashboard/NoOrderPlaceholder.dart';
import 'package:flipper_dashboard/stockApprovalMixin.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:intl/intl.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';

class IncomingOrdersWidget extends HookConsumerWidget
    with StockRequestApprovalLogic {
  const IncomingOrdersWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stringValue = ref.watch(stringProvider);
    //  final incomingBranch = ref.watch(activeBranchProvider);
    final stockRequests =
        ref.watch(stockRequestsProvider((filter: stringValue)));

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: stockRequests.when(
          data: (requests) {
            if (requests.isEmpty) {
              return buildNoOrdersPlaceholder();
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: requests.length,
              itemBuilder: (context, index) => _buildRequestCard(
                context,
                ref,
                requests[index],
              ),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (err, stack) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
                SizedBox(height: 16),
                Text(
                  'Error loading requests',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  err.toString(),
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestCard(
      BuildContext context, WidgetRef ref, InventoryRequest request) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      margin: EdgeInsets.only(bottom: 16.0),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          title: _buildRequestHeader(request, context),
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBranchInfo(request, ref),
                  SizedBox(height: 16.0),
                  _buildItemsList(ref, request: request),
                  SizedBox(height: 16.0),
                  _buildStatusAndDeliveryInfo(request),
                  if (request.orderNote?.isNotEmpty ?? false) ...[
                    SizedBox(height: 16.0),
                    _buildOrderNote(request),
                  ],
                  SizedBox(height: 20.0),
                  _buildActionRow(context, ref, request),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestHeader(InventoryRequest request, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Material(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: request.id.toString()));

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Request ID copied to clipboard'),
                        backgroundColor: Colors.blue,
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.only(
                          left: 350.0, // Adjust left margin
                          right: 350.0, // Adjust right margin
                          bottom: 20.0, // Adjust bottom margin if needed
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.copy, color: Colors.blue[700], size: 20),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Request From ${request.branch?.name}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.green[100]!),
          ),
          child: Text(
            '${request.itemCounts} Item${request.itemCounts! > 1 ? 's' : ''}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.green[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBranchInfo(
    InventoryRequest request,
    WidgetRef ref,
  ) {
    final incomingBranch = ref.watch(activeBranchProvider);
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.swap_horiz, color: Colors.blue[700], size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBranchInfoRow(
                    'From', "${request.branch?.name}", Colors.green[700]!),
                SizedBox(height: 8),
                _buildBranchInfoRow(
                    'To', "${incomingBranch.value?.name}", Colors.blue[700]!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchInfoRow(String label, String branch, Color color) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          branch,
          style: TextStyle(
            fontSize: 14,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildItemsList(WidgetRef ref, {required InventoryRequest request}) {
    final transactionItemsAsync = ref.watch(transactionItemsProvider(
      requestId: request.id,
      fetchRemote: true,
      doneWithTransaction: true,
    ));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Requested Items',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ),
          Divider(height: 1),
          transactionItemsAsync.when(
            data: (items) => items.isNotEmpty
                ? ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    separatorBuilder: (context, index) => Divider(height: 1),
                    itemBuilder: (context, index) =>
                        _buildItemRow(items[index]),
                  )
                : Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No items found.'),
                  ),
            loading: () => Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) => Padding(
              padding: EdgeInsets.all(16),
              child: Text('Error: $err'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(TransactionItem item) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue[700],
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              item.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Qty: ${item.qty}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusAndDeliveryInfo(InventoryRequest request) {
    return Row(
      children: [
        Expanded(
          child: _buildStatusInfo(request),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _buildDeliveryInfo(request),
        ),
      ],
    );
  }

  Widget _buildStatusInfo(InventoryRequest request) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getStatusColor(request.status).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: _getStatusColor(request.status).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            _getStatusIcon(request.status),
            color: _getStatusColor(request.status),
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  request.status ?? 'Unknown',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(request.status),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo(InventoryRequest request) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today,
            color: Colors.grey[600],
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery Date',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  request.deliveryDate != null
                      ? DateFormat('MMM d, y')
                          .format(request.deliveryDate!.toLocal())
                      : 'Not specified',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderNote(InventoryRequest request) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.note, size: 20, color: Colors.grey[600]),
              SizedBox(width: 8),
              Text(
                'Order Note',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            request.orderNote ?? '',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow(
      BuildContext context, WidgetRef ref, InventoryRequest request) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildActionButton(
          onPressed: request.status == RequestStatus.approved
              ? null
              : () => _handleApproveRequest(context, ref, request),
          icon: Icons.check_circle_outline,
          label: 'Approve',
          color: Colors.green[600]!,
          isDisabled: request.status == RequestStatus.approved,
        ),
        SizedBox(width: 12),
        _buildActionButton(
          onPressed: () => _voidRequest(context, ref, request),
          icon: Icons.cancel_outlined,
          label: 'Void',
          color: Colors.red[600]!,
          isDisabled: false,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required String label,
    required Color color,
    required bool isDisabled,
  }) {
    return Material(
      color: isDisabled ? Colors.grey[100] : color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isDisabled ? Colors.grey[400] : color,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDisabled ? Colors.grey[400] : color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _voidRequest(
      BuildContext context, WidgetRef ref, InventoryRequest request) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded,
                  color: Colors.red[400], size: 24),
              SizedBox(width: 12),
              Text(
                'Void Request',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to void this request?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'This action cannot be undone.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await ProxyService.strategy.delete(
                    id: request.id,
                    endPoint: 'stockRequest',
                  );
                  final stringValue = ref.watch(stringProvider);
                  ref.refresh(stockRequestsProvider((filter: stringValue)));

                  // Show success snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Request voided successfully'),
                      backgroundColor: Colors.green[600],
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                } catch (e) {
                  // Show error snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to void request: ${e.toString()}'),
                      backgroundColor: Colors.red[600],
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Void Request',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleApproveRequest(
      BuildContext context, WidgetRef ref, InventoryRequest request) {
    try {
      approveRequest(request: request, context: context);
      final stringValue = ref.watch(stringProvider);
      ref.refresh(stockRequestsProvider((filter: stringValue)));

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Request approved successfully'),
          backgroundColor: Colors.green[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } catch (e) {
      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to approve request: ${e.toString()}'),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange[700]!;
      case 'approved':
        return Colors.green[600]!;
      case 'partiallyapproved':
        return Colors.amber[700]!;
      case 'rejected':
        return Colors.red[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Icons.hourglass_empty_rounded;
      case 'approved':
        return Icons.check_circle_rounded;
      case 'partiallyapproved':
        return Icons.remove_circle_outline_rounded;
      case 'rejected':
        return Icons.cancel_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }
}
