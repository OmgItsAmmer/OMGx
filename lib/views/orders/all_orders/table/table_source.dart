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

import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../utils/constants/enums.dart';


class OrderRows extends DataTableSource {
  OrderRows({required this.ordersCount});
  int ordersCount;
  @override
  DataRow? getRow(int index) {
    final OrderController orderController = Get.find<OrderController>();
    final InstallmentController installmentController = Get.find<InstallmentController>();
    final AddressController addressController = Get.find<AddressController>();
    final GuarantorController guarantorController = Get.find<GuarantorController>();
    final CustomerController customerController = Get.find<CustomerController>();
    final SalesmanController salesmanController = Get.find<SalesmanController>();
    //order model
    final order = orderController.allOrders[index];
    SaleType? saleTypeFromOrder = SaleType.values.firstWhere(
          (e) => e.name == order.saletype,
      orElse: () => SaleType.cash,
    );

    OrderStatus? orderStatus = OrderStatus.values.firstWhere(
          (e) => e.name == order.status,
      orElse: () => OrderStatus.pending,
    );
    return DataRow2(
        onTap: () async  {
         orderController.setUpOrderDetails(order);


        },
        selected: false,
        onSelectChanged: (value) {},
        cells: [
          DataCell(
            Text(
              orderController.allOrders[index].orderId.toString(),
              style: Theme.of(Get.context!)
                  .textTheme
                  .bodyLarge!
                  .apply(color: TColors.primary),
            ),
          ),
          DataCell(
            Text(
              DateFormat('dd-MM-yyyy').format(DateTime.parse(orderController.allOrders[index].orderDate)),
            ),
          ),
          //  DataCell(
          //
          //     Text('Item length')
          //
          // ),
          DataCell(TRoundedContainer(
            radius: TSizes.cardRadiusSm,
            padding: const EdgeInsets.symmetric(
                vertical: TSizes.sm, horizontal: TSizes.md),
            backgroundColor:
                THelperFunctions.getOrderStatusColor(orderStatus)
                    .withValues(alpha: 0.1),
            child: Text(
               orderController.allOrders[index].status.toString(),
              style: TextStyle(
                  color: THelperFunctions.getOrderStatusColor(
                      orderStatus)),
            ),

          )),
           DataCell(Text(orderController.allOrders[index].totalPrice.toString(),)),
          DataCell(
            TTableActionButtons(
              delete: false,
              view: true,
              edit: false,
              onViewPressed: () async {
                orderController.setUpOrderDetails(order);
              },

            )
          )//orderid
        ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => ordersCount;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
