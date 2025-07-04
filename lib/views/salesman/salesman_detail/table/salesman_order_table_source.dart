import 'package:ecommerce_dashboard/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:ecommerce_dashboard/controllers/address/address_controller.dart';
import 'package:ecommerce_dashboard/controllers/guarantors/guarantor_controller.dart';
import 'package:ecommerce_dashboard/controllers/installments/installments_controller.dart';
import 'package:ecommerce_dashboard/controllers/orders/orders_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:ecommerce_dashboard/utils/helpers/helper_functions.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../Models/orders/order_item_model.dart';
import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../controllers/customer/customer_controller.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/constants/enums.dart';
import 'package:intl/intl.dart';

class SalesmanOrderRows extends DataTableSource {
  final OrderController orderController = Get.find();
  final List<OrderModel> currentOrders;
  final int ordersCount;

  SalesmanOrderRows({
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
            orderItem.status.toString(),
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

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => ordersCount;

  @override
  int get selectedRowCount => 0;
}
