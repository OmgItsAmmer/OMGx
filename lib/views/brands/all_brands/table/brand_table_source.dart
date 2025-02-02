import 'package:admin_dashboard_v3/controllers/brands/brand_controller.dart';
import 'package:admin_dashboard_v3/routes/routes.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../common/widgets/icons/table_action_icon_buttons.dart';

class BrandRow extends DataTableSource {
  BrandRow({required this.brandCount});
  final BrandController brandController = Get.find<BrandController>();

  final brandCount;

  @override
  DataRow? getRow(int index) {
    final brand = brandController.allBrands[index];
    return DataRow2(
        onTap: () {
          brandController.setBrandDetail(brand);

          Get.toNamed(TRoutes.brandDetails, arguments: brand);
        },
        //   selected: productController.selectedRows[index],
        onSelectChanged: (value) {
          //   brandController.selectedRows[index] = value ?? false;
          // productController.selectedRows.refresh(); // Refresh observable list
        },
        cells: [
          DataCell(Text(
            brand.bname.toString(),
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),

          DataCell(Text(
            brand.productsCount.toString(),
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )), //TODO show brand names
          DataCell(TTableActionButtons(
            view: true,
            edit: false,
            onViewPressed: () {
              brandController.setBrandDetail(brand);

              Get.toNamed(TRoutes.brandDetails, arguments: brand);
            }, // TODO use get argument to send data in order detail screen
            onDeletePressed: () {},
          ))
        ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => brandController.allBrands.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
