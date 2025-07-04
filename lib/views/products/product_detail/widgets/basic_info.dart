import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/common/widgets/texts/section_heading.dart';
import 'package:ecommerce_dashboard/controllers/product/product_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:ecommerce_dashboard/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class BasicInfo extends StatelessWidget {
  const BasicInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final productController = Get.find<ProductController>();

    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: TRoundedContainer(
        showBorder: true,
        padding: const EdgeInsets.all(TSizes.md),
        backgroundColor: TColors.light,
        child: Column(
          children: [
            // Section Heading
            const TSectionHeading(title: 'Basic Information'),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Form
            Form(
              key: productController.productDetail,
              child: Column(
                children: [
                  // Product Name
                  TextFormField(
                    controller: productController.productName,
                    focusNode: productController.nameFocusNode,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) =>
                        productController.descriptionFocusNode.requestFocus(),
                    validator: (value) =>
                        TValidator.validateEmptyText('Product name', value),
                    decoration: const InputDecoration(
                      labelText: 'Product name',
                      hintText: 'Enter product name',
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  // Product Description
                  TextFormField(
                    controller: productController.productDescription,
                    focusNode: productController.descriptionFocusNode,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      // Force focus to the serial numbers toggle
                      productController.serialNumbersFocusNode.requestFocus();
                    },
                    validator: (value) => TValidator.validateEmptyText(
                        'Product description', value),
                    decoration: const InputDecoration(
                      labelText: 'Product Description',
                      hintText: 'Enter product description',
                    ),
                    minLines: 3,
                    maxLines: null,
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  // Serial Numbers Toggle - Now properly focusable
                  Obx(() {
                    final isExistingProduct =
                        productController.productId.value > 0;
                    return FocusableActionDetector(
                      focusNode: productController.serialNumbersFocusNode,
                      descendantsAreFocusable: false,
                      onFocusChange: (hasFocus) {
                        if (hasFocus) {
                          // Ensure the SwitchListTile is highlighted when focused
                          productController.serialNumbersFocusNode
                              .requestFocus();
                        }
                      },
                      child: Tooltip(
                        message: isExistingProduct
                            ? 'Product type cannot be changed for existing products'
                            : 'Enable for products with unique serial numbers like electronics',
                        child: SwitchListTile(
                          title: const Text('Has Serial Numbers'),
                          subtitle: const Text(
                              'Enable for products with unique serial numbers like electronics'),
                          value: productController.hasSerialNumbers.value,
                          onChanged: isExistingProduct
                              ? null
                              : (value) {
                                  productController
                                      .toggleHasSerialNumbers(value);
                                  productController.basePriceFocusNode
                                      .requestFocus();
                                },
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  // Pricing & Stock Row
                  Row(
                    children: [
                      // Base Price Field
                      Obx(() => Expanded(
                            child: AnimatedOpacity(
                              opacity: productController.hasSerialNumbers.value
                                  ? 0.5
                                  : 1.0,
                              duration: const Duration(milliseconds: 300),
                              child: TextFormField(
                                controller: productController.basePrice,
                                focusNode: productController.basePriceFocusNode,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) => productController
                                    .salePriceFocusNode
                                    .requestFocus(),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                validator: (value) =>
                                    TValidator.validateEmptyText(
                                        'Basic price', value),
                                decoration: const InputDecoration(
                                  labelText: 'Base Price',
                                  hintText: 'Basic price of product',
                                ),
                                readOnly:
                                    productController.hasSerialNumbers.value,
                              ),
                            ),
                          )),
                      const SizedBox(width: TSizes.spaceBtwInputFields),
                      // Sale Price Field
                      Obx(() => Expanded(
                            child: AnimatedOpacity(
                              opacity: productController.hasSerialNumbers.value
                                  ? 0.5
                                  : 1.0,
                              duration: const Duration(milliseconds: 300),
                              child: TextFormField(
                                controller: productController.salePrice,
                                focusNode: productController.salePriceFocusNode,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) => productController
                                    .stockFocusNode
                                    .requestFocus(),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                validator: (value) =>
                                    TValidator.validateEmptyText(
                                        'Sale price', value),
                                decoration: const InputDecoration(
                                  labelText: 'Sale Price',
                                  hintText: 'Selling price of product',
                                ),
                                readOnly:
                                    productController.hasSerialNumbers.value,
                              ),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  Row(
                    children: [
                      // Stock Field
                      Obx(() => Expanded(
                            child: AnimatedOpacity(
                              opacity: productController.hasSerialNumbers.value
                                  ? 0.5
                                  : 1.0,
                              duration: const Duration(milliseconds: 300),
                              child: TextFormField(
                                controller: productController.stock,
                                focusNode: productController.stockFocusNode,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) => productController
                                    .alertStockFocusNode
                                    .requestFocus(),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                enabled:
                                    !productController.hasSerialNumbers.value,
                                validator: (value) =>
                                    !productController.hasSerialNumbers.value
                                        ? TValidator.validateEmptyText(
                                            'Stock', value)
                                        : null,
                                decoration: InputDecoration(
                                  labelText: 'Stock',
                                  hintText: 'Available stock',
                                  helperText: productController
                                          .hasSerialNumbers.value
                                      ? 'Auto-managed for serialized products'
                                      : null,
                                ),
                                readOnly: true,
                              ),
                            ),
                          )),
                      const SizedBox(width: TSizes.spaceBtwInputFields),
                      // Alert Stock Field
                      Expanded(
                        child: TextFormField(
                          controller: productController.alertStock,
                          focusNode: productController.alertStockFocusNode,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) => TValidator.validateEmptyText(
                              'Alert on stock', value),
                          decoration: const InputDecoration(
                            labelText: 'Alert Stock',
                            hintText: 'Alert on stock below',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
