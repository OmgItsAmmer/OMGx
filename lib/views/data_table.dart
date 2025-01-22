import 'package:admin_dashboard_v3/common/widgets/loaders/animation_loader.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../controllers/dashboard/dashboard_controoler.dart';
import '../utils/constants/image_strings.dart';

class TPaginatedDataTable extends StatelessWidget {
  const TPaginatedDataTable(
      {super.key,
      required this.sortAscending,
      this.sortColumnIndex,
      this.rowsperPage = 10,
      required this.source,
      required this.columns,
      this.onPageChanged,
      this.dataRowHeight = TSizes.xl * 2,
      this.tableHeight = 760,
      this.minWidth = 1000,
        this.showCheckBox = true});
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
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: tableHeight,
      child: Padding(
        padding: EdgeInsets.all(30.0),
        child: Center(
            child: PaginatedDataTable2(
          //source
          source: source,

          //columms & rows
          columns: columns,
          columnSpacing: 12,
          minWidth: minWidth,
          dividerThickness: 0,
          horizontalMargin: 12,
          rowsPerPage: rowsperPage,
          dataRowHeight: dataRowHeight,

          //checkbox
          showCheckboxColumn: showCheckBox,

          //Header Design

          headingTextStyle: Theme.of(context).textTheme.titleMedium,
          headingRowColor:
              WidgetStateProperty.resolveWith((states) => TColors.white),
          headingRowDecoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(TSizes.borderRadiusMd),
            topRight: Radius.circular(TSizes.borderRadiusMd),
          )),

          empty: const TAnimationLoaderWidget(
            text: 'Nothing Found',
            animation: TImages.productsIllustration,
            showAction: false,
          ),

          //Sorting
          sortArrowAlwaysVisible: sortAscending,
          sortColumnIndex: sortColumnIndex,
          sortArrowBuilder: (bool ascending, bool sorted) {
            if (sorted) {
              return Icon(
                ascending ? Iconsax.arrow_up_3 : Iconsax.arrow_down,
                size: TSizes.iconSm,
              );
            } else {
              return Icon(
                ascending ? Iconsax.arrow_up_3 : Iconsax.arrow_down,
                size: TSizes.iconSm,
              ); // idk whats here
            }
          },
        )),
      ),
    );
  }
}

class MyData extends DataTableSource {
  final DashboardController dashboardController =
      Get.put(DashboardController());
  @override
  DataRow? getRow(int index) {
    final data = dashboardController.DataList[index];
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
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => dashboardController.DataList.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}


