import 'package:ecommerce_dashboard/controllers/sales/sales_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:ecommerce_dashboard/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controllers/purchase_sales/purchase_sales_controller.dart';

class PurchaseUnitPriceQuantity extends StatelessWidget {
  const PurchaseUnitPriceQuantity({
    super.key,
    required this.unitPriceFocus,
    required this.quantityFocus,
  });

  final FocusNode unitPriceFocus;
  final FocusNode quantityFocus;

  @override
  Widget build(BuildContext context) {
    final PurchaseSalesController purchaseSalesController =
        Get.find<PurchaseSalesController>();

    return Form(
      key: purchaseSalesController.addUnitPriceAndQuantityKey,
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              //  height: 80,

              child: Obx(
                () => TextFormField(
                  focusNode: unitPriceFocus,
                  onChanged: (value) {
                    purchaseSalesController.calculateTotalPrice();
                  },
                  controller: purchaseSalesController.unitPrice.value,
                  validator: (value) =>
                      TValidator.validateEmptyText('Unit Price', value),
                  decoration: const InputDecoration(labelText: 'Unit Price'),
                  style: Theme.of(context).textTheme.bodyMedium,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(
                          r'^\d*\.?\d{0,2}'), // Allows numbers with up to 2 decimal places
                    ),
                  ],
                  enabled: !purchaseSalesController
                      .isSerializedProduct.value, // Disable if serialized
                ),
              ),
            ),
          ),
          const SizedBox(
            width: TSizes.spaceBtwItems,
          ),
          Expanded(
            child: SizedBox(
              width: double.infinity,

              //  height: 80,
              child: Obx(
                () => TextFormField(
                  focusNode: quantityFocus,
                  onChanged: (value) {
                    purchaseSalesController.calculateTotalPrice();
                  },
                  readOnly: purchaseSalesController.isSerializedProduct.value,
                  validator: (value) =>
                      TValidator.validateEmptyText('quantity ', value),
                  controller: purchaseSalesController.quantity,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  style: Theme.of(context).textTheme.bodyMedium,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(
                          r'^\d*\.?\d{0,2}'), // Allows numbers with up to 2 decimal places
                    ),
                  ],
                  enabled: !purchaseSalesController
                      .isSerializedProduct.value, // Disable if serialized
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
