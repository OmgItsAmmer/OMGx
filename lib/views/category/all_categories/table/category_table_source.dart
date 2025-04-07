import 'package:admin_dashboard_v3/controllers/brands/brand_controller.dart';
import 'package:admin_dashboard_v3/controllers/category/category_controller.dart';
import 'package:admin_dashboard_v3/routes/routes.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../common/widgets/icons/table_action_icon_buttons.dart';

class CategoryRow extends DataTableSource {
  CategoryRow({required this.categoryCount});
  final CategoryController categoryController = Get.find<CategoryController>();

  final categoryCount;

  @override
  DataRow? getRow(int index) {
    final category = categoryController.allCategories[index];
    return DataRow2(
        onTap: () {
          categoryController.setCategoryDetail(category);

          Get.toNamed(TRoutes.categoryDetails, arguments: category);
        },
        //   selected: productController.selectedRows[index],
        onSelectChanged: (value) {
          //   brandController.selectedRows[index] = value ?? false;
          // productController.selectedRows.refresh(); // Refresh observable list
        },
        cells: [
          DataCell(Text(
            category.categoryName.toString(),
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),

          DataCell(Text(
            category.image.toString(),
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(TTableActionButtons(
            view: true,
            edit: false,
            onViewPressed: () {
              categoryController.setCategoryDetail(category);

              Get.toNamed(TRoutes.categoryDetails, arguments: category);
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
  int get rowCount => categoryController.allCategories.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
