import 'package:ecommerce_dashboard/controllers/brands/brand_controller.dart';
import 'package:ecommerce_dashboard/controllers/category/category_controller.dart';
import 'package:ecommerce_dashboard/routes/routes.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../common/widgets/icons/table_action_icon_buttons.dart';

class CategoryRow extends DataTableSource {
  CategoryRow({
    required this.categoryCount,
    required this.filteredCategories,
  });

  final CategoryController categoryController = Get.find<CategoryController>();
  final int categoryCount;
  final List<dynamic> filteredCategories;

  @override
  DataRow? getRow(int index) {
    final category = filteredCategories[index];
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
            (category.productCount == null)
                ? '0'
                : category.productCount.toString(),
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
            onDeletePressed: () {
              Get.defaultDialog(
                title: "Confirm Delete",
                middleText:
                    "Are you sure you want to delete the category ${category.categoryName}?",
                textConfirm: "Delete",
                textCancel: "Cancel",
                confirmTextColor: Colors.white,
                buttonColor: Colors.red,
                onConfirm: () async {
                  Navigator.of(Get.context!).pop(); // Close the dialog
                  await categoryController.deleteCategory(category.categoryId!);
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
  int get rowCount => categoryCount;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
