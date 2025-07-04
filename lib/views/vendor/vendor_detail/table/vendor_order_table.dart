import 'package:ecommerce_dashboard/controllers/orders/orders_controller.dart';
import 'package:ecommerce_dashboard/controllers/purchase/purchase_controller.dart';
import 'package:ecommerce_dashboard/utils/device/device_utility.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../paginated_data_table.dart';
import 'vendor_order_table_source.dart';

class VendorPurchaseTable extends StatelessWidget {
  const VendorPurchaseTable({super.key});

  @override
  Widget build(BuildContext context) {
    final PurchaseController purchaseController =
        Get.find<PurchaseController>();

    return Obx(
      () => TPaginatedDataTable(
        sortAscending: true,
        minWidth: 700,
        showCheckBox: false,
        columns: [
          const DataColumn2(label: Text('Order ID')),
          const DataColumn2(label: Text('Date')),
          DataColumn2(
            label: const Text('Status'),
            fixedWidth: TDeviceUtils.isMobileScreen(context) ? 120 : null,
          ),
          const DataColumn2(label: Text('Amount')),
          const DataColumn2(label: Text('Action'), fixedWidth: 100),
        ],
        source: VendorOrderRows(
          currentPurchases: purchaseController.currentPurchases,
          purchasesCount: purchaseController.currentPurchases.length,
        ),
      ),
    );
  }
}
