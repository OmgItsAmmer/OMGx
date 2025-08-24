import 'package:ecommerce_dashboard/controllers/table/table_search_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:ecommerce_dashboard/utils/device/device_utility.dart';
import 'package:ecommerce_dashboard/views/orders/all_orders/table/table_source.dart';
import 'package:ecommerce_dashboard/common/widgets/shimmers/shimmer.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class OrderTableWidget extends StatefulWidget {
  const OrderTableWidget({super.key});

  @override
  State<OrderTableWidget> createState() => _OrderTableWidgetState();
}

class _OrderTableWidgetState extends State<OrderTableWidget> {
  late int _rowsPerPage;
  late int? _sortColumnIndex;
  late bool _sortAscending;
  bool _isInitialized = false;
  OrderRows? _dataSource;

  @override
  void initState() {
    super.initState();
    _rowsPerPage = 20; // Initial count of 20 as requested
    _sortColumnIndex = 0;
    _sortAscending = false;

    // Initialize the table search controller
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInitialized) {
        if (!Get.isRegistered<TableSearchController>(tag: 'orders')) {
          Get.put(TableSearchController(), tag: 'orders');
        }
        final tableSearchController =
            Get.find<TableSearchController>(tag: 'orders');
        tableSearchController.sort(0, false);
        _isInitialized = true;
      }
    });
  }

  @override
  void dispose() {
    _dataSource?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use a unique instance of TableSearchController for orders
    if (!Get.isRegistered<TableSearchController>(tag: 'orders')) {
      Get.put(TableSearchController(), tag: 'orders');
    }
    final tableSearchController =
        Get.find<TableSearchController>(tag: 'orders');

    return Obx(() {
      // Get the search term from the controller
      String searchTerm = tableSearchController.searchTerm.value;

      // Create or update data source when search term changes
      if (_dataSource == null || _dataSource!.searchTerm != searchTerm) {
        _dataSource?.dispose();
        _dataSource = OrderRows(searchTerm: searchTerm);
      }

      return SizedBox(
        height: 840,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Column(
              children: [
                Expanded(
                  child: PaginatedDataTable2(
                    // Source
                    source: _dataSource!,

                    // Columns & rows
                    columns: [
                      DataColumn2(
                        label: const Text('Order ID'),
                        tooltip: 'Order ID',
                        onSort: (columnIndex, ascending) {
                          _handleSort(
                              columnIndex, ascending, tableSearchController);
                        },
                      ),
                      const DataColumn2(
                          label: Text('Date'), tooltip: 'Order Date'),
                      const DataColumn2(
                          label: Text('Customer'), tooltip: 'Customer Name'),
                      DataColumn2(
                          label: const Text('Status'),
                          tooltip: 'Order Status',
                          fixedWidth: TDeviceUtils.isMobileScreen(context)
                              ? 120
                              : null),
                      const DataColumn2(
                          label: Text('Amount'),
                          tooltip: 'Order Amount',
                          numeric: true),
                      const DataColumn2(label: Text('Action'), fixedWidth: 100),
                    ],
                    columnSpacing: 12,
                    minWidth: 700,
                    dividerThickness: 0,
                    horizontalMargin: 12,
                    rowsPerPage: _rowsPerPage,
                    onRowsPerPageChanged: (value) {
                      setState(() {
                        _rowsPerPage = value ?? 20;
                      });
                    },
                    availableRowsPerPage: const [10, 20, 50],
                    dataRowHeight: 60,

                    // Checkbox
                    showCheckboxColumn: false,

                    // Header Design
                    headingTextStyle: Theme.of(context).textTheme.titleMedium,
                    headingRowColor: WidgetStateProperty.resolveWith(
                        (states) => TColors.white),
                    headingRowDecoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(TSizes.borderRadiusMd),
                      topRight: Radius.circular(TSizes.borderRadiusMd),
                    )),

                    // Empty state with loading check
                    empty: _dataSource!.isLoading
                        ? _buildShimmerLoadingWidget()
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inbox_outlined,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No Orders Found',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),

                    // Sorting
                    sortAscending: _sortAscending,
                    sortColumnIndex: _sortColumnIndex,
                    sortArrowBuilder: (bool ascending, bool sorted) {
                      // Always show descending arrow for Order ID column (column 0)
                      if (_sortColumnIndex == 0) {
                        return Icon(
                          Iconsax.arrow_down,
                          size: TSizes.iconSm,
                          color: TColors.primary,
                        );
                      }
                      // For other columns, show the actual sort direction
                      return Icon(
                        ascending ? Iconsax.arrow_up_3 : Iconsax.arrow_down,
                        size: TSizes.iconSm,
                        color: TColors.primary,
                      );
                    },
                  ),
                ),
                // Loading indicator at the bottom when loading more data
                if (_dataSource!.isLoading &&
                    _dataSource!.currentlyLoadedCount < _dataSource!.rowCount)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Loading more orders...',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildShimmerLoadingWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: List.generate(10, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TShimmerEffect(width: double.infinity, height: 16),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: TShimmerEffect(width: double.infinity, height: 16),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: TShimmerEffect(width: double.infinity, height: 16),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: TShimmerEffect(
                      width: double.infinity, height: 24, radius: 12),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: TShimmerEffect(width: double.infinity, height: 16),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 40,
                  child: TShimmerEffect(width: 40, height: 16),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  void _handleSort(
      int columnIndex, bool ascending, TableSearchController controller) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
    controller.sort(columnIndex, ascending);

    // Refresh the data source to apply new sorting by recreating it
    if (_dataSource != null) {
      final currentSearchTerm = _dataSource!.searchTerm;
      _dataSource!.dispose();
      _dataSource = OrderRows(searchTerm: currentSearchTerm);
    }
  }
}
