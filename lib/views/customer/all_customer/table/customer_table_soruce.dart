import 'package:admin_dashboard_v3/controllers/address/address_controller.dart';
import 'package:admin_dashboard_v3/controllers/customer/customer_controller.dart';
import 'package:admin_dashboard_v3/controllers/orders/orders_controller.dart';
import 'package:admin_dashboard_v3/routes/routes.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/icons/table_action_icon_buttons.dart';

class CustomerRow extends DataTableSource {
  CustomerRow({
    required this.customerCount,
    required this.filteredCustomers,
  });

  final CustomerController customerController = Get.find<CustomerController>();
  final AddressController addressController = Get.find<AddressController>();
  // final ProductImagesController productImagesController = Get.find<ProductImagesController>();

  final OrderController orderController = Get.find<OrderController>();

  final int customerCount;
  final List<dynamic> filteredCustomers;

  @override
  DataRow? getRow(int index) {
    final customer = filteredCustomers[index];
    return DataRow2(
        onTap: () async {
          await addressController.fetchEntityAddresses(
              customer.customerId!, EntityType.customer);
          await orderController.fetchEntityOrders(
              customer.customerId!, 'Customer');
          orderController.currentOrders.refresh();
          orderController.setRecentOrderDay();
          orderController.setAverageTotalAmount();
          // productImagesController.setDesiredImage(MediaCategory.customers, customer.customerId);
          Get.toNamed(TRoutes.customerDetails, arguments: customer);
        },
        selected: false,
        onSelectChanged: (value) {},
        cells: [
          // const DataCell(TRoundedImage(
          //   width: 50,
          //   height: 50,
          //   imageurl: TImages.user,
          //   isNetworkImage: false,
          // )),
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

          DataCell(TTableActionButtons(
            view: false,
            edit: true,
            delete: true,
            onEditPressed: () async {
              await addressController.fetchEntityAddresses(
                  customer.customerId!, EntityType.customer);
              customerController.setCustomerDetail(customer);
              // productImagesController.setDesiredImage(MediaCategory.customers, customer.customerId);
              Get.toNamed(TRoutes.addCustomer, arguments: customer);
            },
            onDeletePressed: () async {
              Get.defaultDialog(
                title: "Confirm Delete",
                middleText:
                    "Are you sure you want to delete ${customer.fullName}?",
                textConfirm: "Delete",
                textCancel: "Cancel",
                confirmTextColor: Colors.white,
                buttonColor: Colors.red,
                onConfirm: () async {
                  Navigator.of(Get.context!).pop(); // Close the dialog
                  await customerController.deleteCustomer(customer.customerId!);
                },
                onCancel: () {
                  Navigator.of(Get.context!).pop(); // Close the dialog
                },
              );
            },
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
