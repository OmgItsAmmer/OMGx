import 'package:admin_dashboard_v3/common/widgets/shimmers/shimmer.dart';
import 'package:admin_dashboard_v3/views/products/all_products/table/product_table_source.dart';
import 'package:admin_dashboard_v3/views/sales/table/sale_table_source.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/device/device_utility.dart';
import '../../../controllers/installments/installments_controller.dart';
import '../../../controllers/sales/sales_controller.dart';
import '../../data_table.dart';
import 'installment_table_source.dart';

class InstallmentTable extends StatelessWidget {
  const InstallmentTable({super.key});

  @override
  Widget build(BuildContext context) {
    final InstallmentController installmentController = Get.find<InstallmentController>();


    return Obx(
            () {
              if(installmentController.isLoading.value){
                return const TShimmerEffect(width: 100, height: 100);
              }
              if(installmentController.installmentPlans.isEmpty)
                {
                  return const Text('No Installment Plan!!',);
                }

          return TPaginatedDataTable(
            showCheckBox: false,
            sortAscending: true,
            minWidth: 700,
            rowsperPage: 10,

            columns: const [
              DataColumn2(label: Text('#')),
              DataColumn2(label: Text('Description')),
              DataColumn2(label: Text('Due Date')),
              DataColumn2(label: Text('Paid Date')),
              DataColumn2(label: Text('Amount')),
              DataColumn2(label: Text('Paid')),
              DataColumn2(label: Text('Remarks')),
              DataColumn2(label: Text('Balance')),
              DataColumn2(label: Text('Status')),
              DataColumn2(label: Text('Action'), fixedWidth: 100),
            ],
            source: InstallmentRow(
                installmentCount: installmentController.installmentPlans.length

            ),
          );

        }
    );
  }
}
