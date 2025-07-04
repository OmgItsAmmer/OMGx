import 'package:ecommerce_dashboard/Models/orders/order_item_model.dart';
import 'package:ecommerce_dashboard/controllers/orders/orders_controller.dart';
import 'package:ecommerce_dashboard/controllers/table/table_search_controller.dart';
import 'package:ecommerce_dashboard/utils/device/device_utility.dart';
import 'package:ecommerce_dashboard/views/orders/all_orders/table/table_source.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../paginated_data_table.dart';

class OrderTable extends StatelessWidget {
  const OrderTable({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.find<OrderController>();

    // Use a unique instance of TableSearchController for orders
    if (!Get.isRegistered<TableSearchController>(tag: 'orders')) {
      Get.put(TableSearchController(), tag: 'orders');
    }
    final tableSearchController =
        Get.find<TableSearchController>(tag: 'orders');

    return Obx(() {
      // Get the search term from the controller
      String searchTerm = tableSearchController.searchTerm.value.toLowerCase();

      // Create a filtered orders list based on search term
      var filteredOrders = [...orderController.allOrders]; // Create a copy
      if (searchTerm.isNotEmpty) {
        filteredOrders = orderController.allOrders.where((order) {
          // Add search criteria based on OrderModel properties
          return order.orderId.toString().toLowerCase().contains(searchTerm) ||
              order.orderDate.toLowerCase().contains(searchTerm) ||
              order.status.toLowerCase().contains(searchTerm) ||
              order.subTotal.toString().toLowerCase().contains(searchTerm);
        }).toList();
      }

      // Sort orders by ID in descending order (bigger order ID first) by default
      if (tableSearchController.sortColumnIndex.value == null) {
        filteredOrders.sort((a, b) => b.orderId.compareTo(a.orderId));
      } else if (tableSearchController.sortColumnIndex.value == 0) {
        // Sort by Order ID based on the current sorting state
        filteredOrders.sort((a, b) {
          if (tableSearchController.sortAscending.value) {
            return a.orderId.compareTo(b.orderId); // Ascending
          } else {
            return b.orderId.compareTo(a.orderId); // Descending
          }
        });
      }

      return TPaginatedDataTable(
        // isScrollable: false,
        sortAscending: tableSearchController.sortAscending.value,
        sortColumnIndex: tableSearchController.sortColumnIndex.value,
        minWidth: 700,
        showCheckBox: false,
        dataRowHeight: 60,
        tableHeight: 840,
        rowsperPage: 10,
        availableRowsPerPage: const [5, 10],
        controllerTag: 'orders',
        onSortChanged: (columnIndex, ascending) {
          // Only sort by Order ID (column 0)
          if (columnIndex == 0) {
            tableSearchController.sort(columnIndex, ascending);

            // Sort orders by ID in descending order (bigger order ID first)
            filteredOrders.sort((a, b) {
              if (ascending) {
                return a.orderId.compareTo(b.orderId); // Ascending
              } else {
                return b.orderId.compareTo(a.orderId); // Descending
              }
            });
          }
        },
        columns: [
          DataColumn2(
            label: const Text('Order ID'),
            tooltip: 'Order ID',
            onSort: (columnIndex, ascending) {
              // Enable sorting only for this column
              tableSearchController.sort(columnIndex, ascending);
            },
          ),
          const DataColumn2(label: Text('Date'), tooltip: 'Order Date'),
          const DataColumn2(label: Text('Customer'), tooltip: 'Customer Name'),
          DataColumn2(
              label: const Text('Status'),
              tooltip: 'Order Status',
              fixedWidth: TDeviceUtils.isMobileScreen(context) ? 120 : null),
          const DataColumn2(
              label: Text('Amount'), tooltip: 'Order Amount', numeric: true),
          const DataColumn2(label: Text('Action'), fixedWidth: 100),
        ],
        source: OrderRows(
          ordersCount: filteredOrders.length,
          filteredOrders: filteredOrders.cast<OrderModel>(),
        ),
      );
    });
  }
}
