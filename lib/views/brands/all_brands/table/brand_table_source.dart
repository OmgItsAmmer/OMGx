import 'package:ecommerce_dashboard/controllers/brands/brand_controller.dart';
import 'package:ecommerce_dashboard/routes/routes.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/icons/table_action_icon_buttons.dart';

class BrandRow extends DataTableSource {
  BrandRow({
    required this.brandCount,
    required this.filteredBrands,
  });

  final BrandController brandController = Get.find<BrandController>();
  final int brandCount;
  final List<dynamic> filteredBrands;

  @override
  DataRow? getRow(int index) {
    final brand = filteredBrands[index];
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
            brand.brandname ?? '',
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),

          DataCell(Text(
            brand.productCount.toString(),
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
            onDeletePressed: () {
              Get.defaultDialog(
                title: "Confirm Delete",
                middleText:
                    "Are you sure you want to delete the brand ${brand.brandname ?? 'Unknown'}?",
                textConfirm: "Delete",
                textCancel: "Cancel",
                confirmTextColor: Colors.white,
                buttonColor: Colors.red,
                onConfirm: () async {
                  Navigator.of(Get.context!).pop(); // Close the dialog
                  await brandController.deleteBrand(brand.brandID);
                },
                onCancel: () {
                  Navigator.of(Get.context!).pop(); // Close the dialog
                },
              );
            },
          ))
        ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => brandCount;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
