import 'package:ecommerce_dashboard/Models/purchase/purchase_model.dart';
import 'package:ecommerce_dashboard/controllers/purchase/purchase_controller.dart';

import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/utils/constants/enums.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:ecommerce_dashboard/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class VendorOrderRows extends DataTableSource {
  final PurchaseController purchaseController = Get.find();
  final List<PurchaseModel> currentPurchases;
  final int purchasesCount;

  VendorOrderRows({
    required this.currentPurchases,
    required this.purchasesCount,
  });

  @override
  DataRow getRow(int index) {
    if (index >= currentPurchases.length) {
      return const DataRow(cells: [
        DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Text('')),
      ]);
    }

    final PurchaseModel purchaseItem = currentPurchases[index];
    PurchaseStatus? purchaseStatus = PurchaseStatus.values.firstWhere(
      (e) => e.name == purchaseItem.status,
      orElse: () => PurchaseStatus.pending,
    );
    String formattedDate = '';
    try {
      formattedDate = DateFormat('MM/dd/yyyy')
          .format(DateTime.parse(purchaseItem.purchaseDate));
    } catch (e) {
      formattedDate = purchaseItem.purchaseDate.toString();
    }

    return DataRow(
      cells: [
        DataCell(Text(purchaseItem.purchaseId.toString())),
        DataCell(Text(formattedDate)),
        DataCell(TRoundedContainer(
          radius: TSizes.cardRadiusSm,
          padding: const EdgeInsets.symmetric(
              vertical: TSizes.sm, horizontal: TSizes.md),
          backgroundColor:
              THelperFunctions.getPurchaseStatusColor(purchaseStatus)
                  .withValues(alpha: 0.1),
          child: Text(
            purchaseController.allPurchases[index].status.toString(),
            style: TextStyle(
                color: THelperFunctions.getPurchaseStatusColor(purchaseStatus)),
          ),
        )),
        DataCell(Text(purchaseItem.subTotal.toStringAsFixed(2))),
        DataCell(
          IconButton(
            onPressed: () {
              purchaseController.setUpPurchaseDetails(purchaseItem);
            },
            icon: const Icon(Icons.visibility),
          ),
        ),
      ],
      onSelectChanged: (value) {
        if (value == true) {
          purchaseController.setUpPurchaseDetails(purchaseItem);
        }
      },
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => purchasesCount;

  @override
  int get selectedRowCount => 0;
}
