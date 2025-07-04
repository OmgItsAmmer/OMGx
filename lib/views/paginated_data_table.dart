import 'package:ecommerce_dashboard/common/widgets/loaders/animation_loader.dart';
import 'package:ecommerce_dashboard/controllers/table/table_search_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:ecommerce_dashboard/utils/device/device_utility.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../controllers/dashboard/dashboard_controoler.dart';
import '../utils/constants/image_strings.dart';

class TPaginatedDataTable extends StatefulWidget {
  const TPaginatedDataTable({
    super.key,
    required this.sortAscending,
    this.sortColumnIndex,
    this.rowsperPage = 10,
    required this.source,
    required this.columns,
    this.onPageChanged,
    this.dataRowHeight = TSizes.xl * 2,
    this.tableHeight = 840,
    this.minWidth = 1000,
    this.showCheckBox = true,
    this.availableRowsPerPage = const [10, 20, 50, 100],
    this.onSortChanged,
    this.searchQuery = '',
    this.controllerTag,
  });

  // Dynamic column names
  final bool showCheckBox;
  final bool sortAscending;
  final int? sortColumnIndex;
  final int rowsperPage;
  final DataTableSource source;
  final List<DataColumn> columns;
  final Function(int)? onPageChanged;
  final double dataRowHeight;
  final double tableHeight;
  final double? minWidth;
  final List<int> availableRowsPerPage;
  final Function(int, bool)? onSortChanged;
  final String searchQuery;
  final String? controllerTag;

  @override
  State<TPaginatedDataTable> createState() => _TPaginatedDataTableState();
}

class _TPaginatedDataTableState extends State<TPaginatedDataTable> {
  late int _rowsPerPage;
  late int? _sortColumnIndex;
  late bool _sortAscending;

  @override
  void initState() {
    super.initState();
    _rowsPerPage = widget.rowsperPage;
    _sortColumnIndex = widget.sortColumnIndex;
    _sortAscending = widget.sortAscending;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.tableHeight,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: PaginatedDataTable2(
            // Source
            source: widget.source,

            // Columns & rows
            columns: widget.columns.map((column) {
              if (column is DataColumn2) {
                return DataColumn2(
                  label: column.label,
                  numeric: column.numeric,
                  tooltip: column.tooltip,
                  size: column.size,
                  fixedWidth: column.fixedWidth,
                  onSort: widget.onSortChanged != null
                      ? (columnIndex, ascending) {
                          setState(() {
                            _sortColumnIndex = columnIndex;
                            _sortAscending = ascending;
                          });
                          widget.onSortChanged!(columnIndex, ascending);
                        }
                      : null,
                );
              } else {
                return DataColumn(
                  label: column.label,
                  numeric: column.numeric,
                  tooltip: column.tooltip,
                  onSort: widget.onSortChanged != null
                      ? (columnIndex, ascending) {
                          setState(() {
                            _sortColumnIndex = columnIndex;
                            _sortAscending = ascending;
                          });
                          widget.onSortChanged!(columnIndex, ascending);
                        }
                      : null,
                );
              }
            }).toList(),
            columnSpacing: 12,
            minWidth: widget.minWidth,
            dividerThickness: 0,
            horizontalMargin: 12,
            rowsPerPage: _rowsPerPage,
            onRowsPerPageChanged: null,
            availableRowsPerPage: widget.availableRowsPerPage,
            dataRowHeight: widget.dataRowHeight,
            onPageChanged: widget.onPageChanged,

            // Checkbox
            showCheckboxColumn: widget.showCheckBox,

            // Header Design
            headingTextStyle: Theme.of(context).textTheme.titleMedium,
            headingRowColor:
                WidgetStateProperty.resolveWith((states) => TColors.white),
            headingRowDecoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(TSizes.borderRadiusMd),
              topRight: Radius.circular(TSizes.borderRadiusMd),
            )),

            empty: TAnimationLoaderWidget(
              text:
                  (TDeviceUtils.isMobileScreen(context)) ? '' : 'Nothing Found',
              animation: TImages.noDataFound,
              showAction: false,
              width: 200,
              height: 200,
            ),

            // Sorting
            sortAscending: _sortAscending,
            sortColumnIndex: _sortColumnIndex,
            sortArrowBuilder: (bool ascending, bool sorted) {
              if (!sorted)
                return Container(); // Don't show arrow if column is not sorted
              return Icon(
                ascending ? Iconsax.arrow_up_3 : Iconsax.arrow_down,
                size: TSizes.iconSm,
              );
            },
          ),
        ),
      ),
    );
  }
}

class MyData extends DataTableSource {
  final DashboardController dashboardController =
      Get.put(DashboardController());
  @override
  DataRow? getRow(int index) {
    final data = dashboardController.dataList[index];
    return DataRow2(cells: [
      DataCell(
        Text(data['Column 1'] ?? ''),
      ),
      DataCell(
        Text(data['Column 2'] ?? ''),
      ),
      DataCell(
        Text(data['Column 3'] ?? ''),
      ),
      DataCell(
        Text(data['Column 4'] ?? ''),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => dashboardController.dataList.length;

  @override
  int get selectedRowCount => 0;
}
