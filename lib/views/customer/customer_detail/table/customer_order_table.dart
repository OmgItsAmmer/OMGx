import 'package:admin_dashboard_v3/controllers/orders/orders_controller.dart';
import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../paginated_data_table.dart';
import 'customer_order_table_source.dart';

class CustomerOrderTable extends StatelessWidget {
  const CustomerOrderTable({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.find<OrderController>();

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
        source: CustomerOrderRows(
          currentOrders: orderController.currentOrders,
          ordersCount: orderController.currentOrders.length,
        ),
      ),
    );
  }
}
