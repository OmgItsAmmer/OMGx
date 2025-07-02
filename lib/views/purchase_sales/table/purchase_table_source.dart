import 'package:admin_dashboard_v3/common/widgets/icons/t_circular_icon.dart';
import 'package:admin_dashboard_v3/controllers/purchase_sales/purchase_sales_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class PurchaseRow extends DataTableSource {
  PurchaseRow({
    required this.purchaseCount,
    required this.filteredPurchases,
  });

  final int purchaseCount;
  final List<PurchaseCartItem> filteredPurchases;

  @override
  DataRow? getRow(int index) {
    if (index >= filteredPurchases.length) return null;

    final purchase = filteredPurchases[index];
    final purchaseSalesController = Get.find<PurchaseSalesController>();

    return DataRow2(
      cells: [
        DataCell(Text(purchase.name)),
        DataCell(Text(purchase.purchasePrice)),
        DataCell(Text(purchase.quantity)),
        DataCell(Text(purchase.unit)),
        DataCell(Text(purchase.totalPrice)),
        DataCell(
          TCircularIcon(
            icon: Iconsax.trash,
            backgroundColor: TColors.error.withValues(alpha: 0.1),
            color: TColors.error,
            onPressed: () {
              // Delete functionality
              _deletePurchaseItem(purchase, purchaseSalesController);
            },
          ),
        ),
      ],
    );
  }

  // void _editPurchaseItem(
  //     PurchaseCartItem purchase, PurchaseSalesController controller) {
  //   try {
  //     // Set the dropdown to the product name
  //     controller.dropdownController.text = purchase.name;
  //     controller.selectedProductName.value = purchase.name;
  //     controller.selectedProductId.value = purchase.productId;

  //     // Set the form fields
  //     controller.unitPrice.value.text = purchase.purchasePrice;
  //     controller.quantity.text = purchase.quantity;
  //     controller.unit.text = purchase.unit;
  //     controller.totalPrice.value.text = purchase.totalPrice;

  //     // If variant is selected, set it
  //     if (purchase.variantId != null) {
  //       controller.selectedVariantId.value = purchase.variantId!;
  //     }

  //     // Remove the item from cart so it can be re-added with new values
  //     controller.allPurchases.removeWhere((p) =>
  //         p.productId == purchase.productId &&
  //         p.variantId == purchase.variantId &&
  //         p.unit == purchase.unit);

  //     // Recalculate totals
  //     controller.calculateNetTotal();

  //     // Focus on unit price field for editing
  //     controller.unitPriceFocus.requestFocus();
  //   } catch (e) {
  //     print('Error editing purchase item: $e');
  //   }
  // }

  void _deletePurchaseItem(
      PurchaseCartItem purchase, PurchaseSalesController controller) {
    try {
      // Remove item from cart
      controller.allPurchases.removeWhere((p) =>
          p.productId == purchase.productId &&
          p.variantId == purchase.variantId &&
          p.unit == purchase.unit);

      // Recalculate totals
      controller.calculateNetTotal();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting purchase item: $e');
      }
    }
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => filteredPurchases.length;

  @override
  int get selectedRowCount => 0;
}
