import 'package:ecommerce_dashboard/controllers/address/address_controller.dart';
import 'package:ecommerce_dashboard/controllers/vendor/vendor_controller.dart';
import 'package:ecommerce_dashboard/routes/routes.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/enums.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Models/vendor/vendor_model.dart';
import '../../../../common/widgets/icons/table_action_icon_buttons.dart';

class VendorRow extends DataTableSource {
  VendorRow({
    required this.vendorCount,
    required this.filteredVendors,
  });

  final VendorController vendorController = Get.find<VendorController>();
  final AddressController addressController = Get.find<AddressController>();

  final int vendorCount;
  final List<VendorModel> filteredVendors;

  @override
  DataRow? getRow(int index) {
    final vendor = filteredVendors[index];
    return DataRow2(
        onTap: () async {
          await addressController.fetchEntityAddresses(
              vendor.vendorId!, EntityType.vendor);
          Get.toNamed(TRoutes.vendorDetails, arguments: vendor);
        },
        selected: false,
        onSelectChanged: (value) {},
        cells: [
          DataCell(Text(
            vendor.fullName,
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            vendor.email,
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          )),
          DataCell(Text(
            vendor.phoneNumber,
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
                  vendor.vendorId!, EntityType.vendor);
              vendorController.selectedVendor.value = vendor;
              Get.toNamed(TRoutes.addVendor, arguments: vendor);
            },
            onDeletePressed: () async {
              Get.defaultDialog(
                title: "Confirm Delete",
                middleText:
                    "Are you sure you want to delete ${vendor.fullName}?",
                textConfirm: "Delete",
                textCancel: "Cancel",
                confirmTextColor: Colors.white,
                buttonColor: Colors.red,
                onConfirm: () async {
                  Navigator.of(Get.context!).pop();
                  await vendorController.deleteVendor(vendor.vendorId!);
                },
                onCancel: () {
                  Navigator.of(Get.context!).pop();
                },
              );
            },
          ))
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => vendorCount;

  @override
  int get selectedRowCount => 0;
}
