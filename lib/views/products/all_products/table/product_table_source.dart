import 'package:admin_dashboard_v3/routes/routes.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

class ProductRow extends DataTableSource {
  @override
  DataRow? getRow(int index) {
  return DataRow2(
      //onTap:
      selected: false,
      onSelectChanged: (value) {},

      cells: [
      DataCell(Text('1',style: Theme.of(Get.context!).textTheme.bodyLarge!.apply(color: TColors.primary),)),

      ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => 10;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;

}