import 'package:admin_dashboard_v3/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:admin_dashboard_v3/controllers/address/address_controller.dart';
import 'package:admin_dashboard_v3/controllers/customer/customer_controller.dart';
import 'package:admin_dashboard_v3/controllers/guarantors/guarantor_controller.dart';
import 'package:admin_dashboard_v3/controllers/installments/installments_controller.dart';
import 'package:admin_dashboard_v3/controllers/orders/orders_controller.dart';
import 'package:admin_dashboard_v3/controllers/salesman/salesman_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/helpers/helper_functions.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../../../Models/orders/order_item_model.dart';
import '../../../../Models/customer/customer_model.dart';
import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../utils/constants/enums.dart';

class OrderRows extends DataTableSource {
  OrderRows({
    required this.ordersCount,
    required this.filteredOrders,
  });

  final int ordersCount;
  final List<OrderModel> filteredOrders;
  final OrderController orderController = Get.find<OrderController>();
  final CustomerController customerController = Get.find<CustomerController>();

  // Get customer name by ID
  String getCustomerName(int? customerId) {
    if (customerId == null) return 'Unknown';

    final customer = customerController.allCustomers
        .firstWhereOrNull((customer) => customer.customerId == customerId);

    return customer?.fullName ?? 'Unknown';
  }

  // Format date to dd/mm/yyyy
  String formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  DataRow? getRow(int index) {
    final InstallmentController installmentController =
        Get.find<InstallmentController>();
    final AddressController addressController = Get.find<AddressController>();
    final GuarantorController guarantorController =
        Get.find<GuarantorController>();
    final SalesmanController salesmanController =
        Get.find<SalesmanController>();

    // Use the filtered orders list
    final OrderModel order = filteredOrders[index];

    SaleType? saleTypeFromOrder = SaleType.values.firstWhere(
      (e) => e.name == order.saletype,
      orElse: () => SaleType.cash,
    );

    OrderStatus? orderStatus = OrderStatus.values.firstWhere(
      (e) => e.name == order.status,
      orElse: () => OrderStatus.pending,
    );

    return DataRow2(
        onTap: () async {
          orderController.setUpOrderDetails(order);
        },
        selected: false,
        onSelectChanged: (value) {},
        cells: [
          DataCell(
            Text(
              order.orderId.toString(),
              style: Theme.of(Get.context!)
                  .textTheme
                  .bodyLarge!
                  .apply(color: TColors.primary),
            ),
          ),
          DataCell(
            Text(
              formatDate(order.orderDate),
            ),
          ),
          DataCell(
            Text(
              getCustomerName(order.customerId),
              style: Theme.of(Get.context!)
                  .textTheme
                  .bodyLarge!
                  .apply(color: TColors.primary),
            ),
          ),
          DataCell(TRoundedContainer(
            radius: TSizes.cardRadiusSm,
            padding: const EdgeInsets.symmetric(
                vertical: TSizes.sm, horizontal: TSizes.md),
            backgroundColor: THelperFunctions.getOrderStatusColor(orderStatus)
                .withValues(alpha: 0.1),
            child: Text(
              order.status.toString(),
              style: TextStyle(
                  color: THelperFunctions.getOrderStatusColor(orderStatus)),
            ),
          )),
          DataCell(Text(order.totalPrice.toString())),
          DataCell(TTableActionButtons(
            delete: false,
            view: true,
            edit: false,
            onViewPressed: () async {
              orderController.setUpOrderDetails(order);
            },
          ))
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => ordersCount;

  @override
  int get selectedRowCount => 0;
}
