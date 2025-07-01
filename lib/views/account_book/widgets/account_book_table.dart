import 'package:admin_dashboard_v3/Models/account_book/account_book_model.dart';
import 'package:admin_dashboard_v3/views/paginated_data_table.dart';
import 'package:admin_dashboard_v3/controllers/account_book/account_book_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'add_account_book_dialog.dart';

class AccountBookTable extends StatelessWidget {
  const AccountBookTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AccountBookController.instance;

    return PaginatedDataTable(
      header: const Text('Account Book Entries'),
      columns: const [
        DataColumn(label: Text('Date')),
        DataColumn(label: Text('Entity Type')),
        DataColumn(label: Text('Entity Name')),
        DataColumn(label: Text('Type')),
        DataColumn(label: Text('Amount')),
        DataColumn(label: Text('Description')),
        DataColumn(label: Text('Reference')),
        DataColumn(label: Text('Actions')),
      ],
      source: AccountBookDataSource(
        controller: controller,
        entries: controller.filteredEntries,
        onEdit: (entry) {
          controller.loadEntryForEditing(entry);
          _showEditDialog(context, controller);
        },
        onDelete: (entryId) {
          _showDeleteConfirmation(context, controller, entryId);
        },
      ),
      rowsPerPage: 10,
      showCheckboxColumn: false,
      columnSpacing: 20,
    );
  }

  void _showEditDialog(BuildContext context, AccountBookController controller) {
    showDialog(
      context: context,
      builder: (context) => const AddAccountBookDialog(isEditing: true),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, AccountBookController controller, int entryId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entry'),
        content: const Text(
            'Are you sure you want to delete this account book entry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteAccountBookEntry(entryId);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class AccountBookDataSource extends DataTableSource {
  final List<AccountBookModel> entries;
  final Function(AccountBookModel) onEdit;
  final Function(int) onDelete;
  final AccountBookController _controller;

  AccountBookDataSource({
    required this.entries,
    required this.onEdit,
    required this.onDelete,
    required AccountBookController controller,
  }) : _controller = controller {
    _controller.filteredEntries.listen((_) {
      notifyListeners();
    });
  }

  @override
  DataRow? getRow(int index) {
    if (index >= entries.length) return null;
    final entry = entries[index];

    return DataRow(
      cells: [
        DataCell(Text(entry.transactionDate.toString().split(' ')[0])),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: TSizes.xs, vertical: TSizes.xs / 2),
            decoration: BoxDecoration(
              color: _getEntityTypeColor(entry.entityType).withOpacity(0.1),
              borderRadius: BorderRadius.circular(TSizes.xs),
            ),
            child: Text(
              entry.entityTypeDisplay,
              style: TextStyle(
                color: _getEntityTypeColor(entry.entityType),
                fontSize: 12,
              ),
            ),
          ),
        ),
        DataCell(Text(entry.entityName)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: TSizes.xs, vertical: TSizes.xs / 2),
            decoration: BoxDecoration(
              color: entry.isIncoming
                  ? TColors.success.withOpacity(0.1)
                  : TColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(TSizes.xs),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  entry.isIncoming ? Iconsax.arrow_down_1 : Iconsax.arrow_up_3,
                  size: 12,
                  color: entry.isIncoming ? TColors.success : TColors.error,
                ),
                const SizedBox(width: TSizes.xs / 2),
                Text(
                  entry.transactionTypeDisplay,
                  style: TextStyle(
                    color: entry.isIncoming ? TColors.success : TColors.error,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        DataCell(
          Text(
            '\$${entry.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: entry.isIncoming ? TColors.success : TColors.error,
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 150,
            child: Text(
              entry.description,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ),
        DataCell(Text(entry.reference ?? '-')),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Iconsax.edit_2, size: 16),
                onPressed: () => onEdit(entry),
                tooltip: 'Edit Entry',
              ),
              IconButton(
                icon: const Icon(Iconsax.trash, size: 16, color: TColors.error),
                onPressed: () => onDelete(entry.accountBookId!),
                tooltip: 'Delete Entry',
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => entries.length;

  @override
  int get selectedRowCount => 0;

  Color _getEntityTypeColor(String entityType) {
    switch (entityType.toLowerCase()) {
      case 'customer':
        return TColors.primary;
      case 'vendor':
        return TColors.warning;
      case 'salesman':
        return TColors.info;
      default:
        return TColors.darkGrey;
    }
  }
}
