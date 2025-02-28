import 'package:admin_dashboard_v3/common/widgets/images/t_rounded_image.dart';
import 'package:admin_dashboard_v3/controllers/address/address_controller.dart';
import 'package:admin_dashboard_v3/controllers/customer/customer_controller.dart';
import 'package:admin_dashboard_v3/controllers/orders/orders_controller.dart';
import 'package:admin_dashboard_v3/routes/routes.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../common/widgets/icons/table_action_icon_buttons.dart';

class CustomerRow extends DataTableSource {
  CustomerRow({required this.customerCount});

  final CustomerController customerController = Get.find<CustomerController>();
  final AddressController addressController = Get.find<AddressController>();
  final OrderController orderController = Get.find<OrderController>();
  final customerCount;
  @override
  DataRow? getRow(int index) {
    final customer = customerController.allCustomers[index];
    return DataRow2(
        onTap: () async {
        await  addressController.fetchCustomerAddresses(customer.customerId);
        await orderController.fetchCustomerOrders(customer.customerId);
        orderController.setRecentOrderDay();
        orderController.setAverageTotalAmount();

          Get.toNamed(TRoutes.customerDetails, arguments: customer);
        },
        selected: false,
        onSelectChanged: (value) {},
        cells: [
          const DataCell(TRoundedImage(
          width: 50,
          height: 50,
          imageurl: TImages.user,
          isNetworkImage: false,
        )),
          DataCell(Text(
            customer.fullName.toString(),
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),

          DataCell(Text(
            customer.email.toString(),
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            customer.phoneNumber.toString(),
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          //TODO show brand names
          DataCell(TTableActionButtons(
            view: false,
            edit: true,

            onViewPressed: () => Get.toNamed(TRoutes.customerDetails,
                arguments:
                    customer), // TODO use get argument to send data in order detail screen
            onDeletePressed: () {},
          ))
        ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => customerCount;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
