import 'package:ecommerce_dashboard/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:ecommerce_dashboard/controllers/vendor/vendor_controller.dart';
import 'package:ecommerce_dashboard/controllers/purchase/purchase_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:ecommerce_dashboard/utils/helpers/helper_functions.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../Models/purchase/purchase_model.dart';
import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../utils/constants/enums.dart';

class PurchaseRows extends DataTableSource {
  PurchaseRows({
    required this.purchasesCount,
    required this.filteredPurchases,
  });

  final int purchasesCount;
  final List<PurchaseModel> filteredPurchases;
  final PurchaseController purchaseController = Get.find<PurchaseController>();
  final VendorController vendorController = Get.find<VendorController>();

  // Get vendor name by ID
  String getVendorName(int? vendorId) {
    if (vendorId == null) return 'Unknown';

    final vendor = vendorController.allVendors
        .firstWhereOrNull((vendor) => vendor.vendorId == vendorId);

    return vendor?.fullName ?? 'Unknown';
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
    //  final AddressController addressController = Get.find<AddressController>();

    // Use the filtered purchases list
    final PurchaseModel purchase = filteredPurchases[index];

    PurchaseStatus? purchaseStatus = PurchaseStatus.values.firstWhere(
      (e) => e.name == purchase.status,
      orElse: () => PurchaseStatus.pending,
    );

    return DataRow2(
        onTap: () async {
          purchaseController.setUpPurchaseDetails(purchase);
        },
        selected: false,
        onSelectChanged: (value) {},
        cells: [
          DataCell(
            Text(
              purchase.purchaseId.toString(),
              style: Theme.of(Get.context!)
                  .textTheme
                  .bodyLarge!
                  .apply(color: TColors.primary),
            ),
          ),
          DataCell(
            Text(
              formatDate(purchase.purchaseDate),
            ),
          ),
          DataCell(
            Text(
              getVendorName(purchase.vendorId),
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
            backgroundColor:
                THelperFunctions.getPurchaseStatusColor(purchaseStatus)
                    .withValues(alpha: 0.1),
            child: Text(
              purchase.status.toString(),
              style: TextStyle(
                  color:
                      THelperFunctions.getPurchaseStatusColor(purchaseStatus)),
            ),
          )),
          DataCell(Text(purchase.subTotal.toString())),
          DataCell(TTableActionButtons(
            delete: false,
            view: true,
            edit: false,
            onViewPressed: () async {
              purchaseController.setUpPurchaseDetails(purchase);
            },
          ))
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => purchasesCount;

  @override
  int get selectedRowCount => 0;
}
