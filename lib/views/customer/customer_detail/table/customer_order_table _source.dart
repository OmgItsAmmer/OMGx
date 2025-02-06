import 'package:admin_dashboard_v3/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:admin_dashboard_v3/controllers/address/address_controller.dart';
import 'package:admin_dashboard_v3/controllers/guarantors/guarantor_controller.dart';
import 'package:admin_dashboard_v3/controllers/installments/installments_controller.dart';
import 'package:admin_dashboard_v3/controllers/orders/orders_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/helpers/helper_functions.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/constants/enums.dart';


class CustomerOrderRows extends DataTableSource {
  CustomerOrderRows({required this.ordersCount});
  int ordersCount;
  @override
  DataRow? getRow(int index) {
    final OrderController orderController = Get.find<OrderController>();
    final InstallmentController installmentController = Get.find<InstallmentController>();
    final AddressController addressController = Get.find<AddressController>();
    final GuarantorController guarantorController = Get.find<GuarantorController>();
    //order model
    final order = orderController.currentOrders[index];

    return DataRow2(
        onTap: () {
          orderController.fetchOrderItems(order.orderId);
          order.orderItems = orderController.orderItems;
          installmentController.fetchSpecificInstallmentPayment(order.orderId);
          installmentController.fetchCustomerInfo(order.customerId ?? -1);
          addressController.fetchCustomerAddresses(order.customerId ?? -1);
          guarantorController.fetchGuarantors(order.orderId);

          Get.toNamed(TRoutes.orderDetails, arguments: order);
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
              orderController.allOrders[index].orderDate.toString(),

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
            THelperFunctions.getOrderStatusColor(OrderStatus.pending)
                .withOpacity(0.1),
            child: Text(
              orderController.allOrders[index].status.toString(),
              style: TextStyle(
                  color: THelperFunctions.getOrderStatusColor(
                      OrderStatus.pending)),
            ),

          )),
          DataCell(Text(orderController.allOrders[index].totalPrice.toString(),)),
          DataCell(
              TTableActionButtons(
                view: true,
                edit: false,
                onViewPressed: () {
                  orderController.fetchOrderItems(order.orderId);
                  order.orderItems = orderController.orderItems;
                  installmentController.fetchSpecificInstallmentPayment(order.orderId);
                  Get.toNamed(TRoutes.orderDetails, arguments: order);
                },
                onDeletePressed: (){


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
