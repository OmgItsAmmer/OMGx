import 'package:admin_dashboard_v3/controllers/sales/sales_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class UnitPriceQuantity extends StatelessWidget {
  const UnitPriceQuantity({
    super.key,
    required this.unitPriceFocus,
    required this.quantityFocus,
  });

  final FocusNode unitPriceFocus;
  final FocusNode quantityFocus;

  @override
  Widget build(BuildContext context) {
    final SalesController salesController = Get.find<SalesController>();

    return Form(
      key: salesController.addUnitPriceAndQuantityKey,
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
                    salesController.calculateTotalPrice();
                  },
                  controller: salesController.unitPrice.value,
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
              child: TextFormField(
                focusNode: quantityFocus,
                onChanged: (value) {
                  salesController.calculateTotalPrice();
                },
                validator: (value) =>
                    TValidator.validateEmptyText('quantity ', value),
                controller: salesController.quantity,
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
              ),
            ),
          )
        ],
      ),
    );
  }
}
