import 'package:admin_dashboard_v3/Models/orders/order_item_model.dart';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/controllers/orders/orders_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CustomerOrderRows extends DataTableSource {
  final OrderController orderController = Get.find();
  final List<OrderModel> currentOrders;
  final int ordersCount;

  CustomerOrderRows({
    required this.currentOrders,
    required this.ordersCount,
  });

  @override
  DataRow getRow(int index) {
    if (index >= currentOrders.length) {
      return const DataRow(cells: [
        DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Text('')),
      ]);
    }

    final OrderModel orderItem = currentOrders[index];
    OrderStatus? orderStatus = OrderStatus.values.firstWhere(
      (e) => e.name == orderItem.status,
      orElse: () => OrderStatus.pending,
    );
    String formattedDate = '';
    try {
      formattedDate =
          DateFormat('MM/dd/yyyy').format(DateTime.parse(orderItem.orderDate));
    } catch (e) {
      formattedDate = orderItem.orderDate.toString();
    }

    return DataRow(
      cells: [
        DataCell(Text(orderItem.orderId.toString())),
        DataCell(Text(formattedDate)),
        DataCell(TRoundedContainer(
          radius: TSizes.cardRadiusSm,
          padding: const EdgeInsets.symmetric(
              vertical: TSizes.sm, horizontal: TSizes.md),
          backgroundColor: THelperFunctions.getOrderStatusColor(orderStatus)
              .withValues(alpha: 0.1),
          child: Text(
            orderController.allOrders[index].status.toString(),
            style: TextStyle(
                color: THelperFunctions.getOrderStatusColor(orderStatus)),
          ),
        )),
        DataCell(Text(orderItem.subTotal.toStringAsFixed(2))),
        DataCell(
          IconButton(
            onPressed: () {
              orderController.setUpOrderDetails(orderItem);
            },
            icon: const Icon(Icons.visibility),
          ),
        ),
      ],
      onSelectChanged: (value) {
        if (value == true) {
          orderController.setUpOrderDetails(orderItem);
        }
      },
    );
  }

  // Color _getStatusColor(String status) {
  //   switch (status.toLowerCase()) {
  //     case 'completed':
  //       return Colors.green;
  //     case 'pending':
  //       return Colors.orange;
  //     case 'cancelled':
  //       return Colors.red;
  //     default:
  //       return Colors.grey;
  //   }
  // }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => ordersCount;

  @override
  int get selectedRowCount => 0;
}
