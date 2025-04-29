import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/texts/section_heading.dart';
import 'package:admin_dashboard_v3/controllers/product/product_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/validators/validation.dart';
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

    return TRoundedContainer(
      showBorder: true,
      padding: const EdgeInsets.all(TSizes.md),
      backgroundColor: TColors.light,
      child: Column(
        children: [
          //Section Heading
          const TSectionHeading(title: 'Basic Information'),
          const SizedBox(
            height: TSizes.spaceBtwItems,
          ),

          // Form
          Form(
            key: productController.productDetail,
            child: Column(
              children: [
                // Product Name
                TextFormField(
                  controller: productController.productName,
                  validator: (value) =>
                      TValidator.validateEmptyText('Product name', value),
                  decoration: const InputDecoration(
                    labelText: 'Product name',
                    hintText: 'Enter product name',
                  ),
                ),
                const SizedBox(
                  height: TSizes.spaceBtwInputFields,
                ),
                // Product Description
                TextFormField(
                  controller: productController.productDescription,
                  validator: (value) => TValidator.validateEmptyText(
                      'Product description', value),
                  decoration: const InputDecoration(
                    labelText: 'Product Description',
                    hintText: 'Enter product description',
                  ),
                  minLines: 3,
                  maxLines: null,
                ),
                const SizedBox(
                  height: TSizes.spaceBtwInputFields,
                ),

                // Serial Numbers Toggle
                Obx(() {
                  // Check if this is an existing product (productId > 0)
                  final isExistingProduct =
                      productController.productId.value > 0;

                  return Tooltip(
                    message: isExistingProduct
                        ? 'Product type cannot be changed for existing products'
                        : 'Enable for products with unique serial numbers like electronics',
                    child: SwitchListTile(
                      title: const Text('Has Serial Numbers'),
                      subtitle: const Text(
                          'Enable for products with unique serial numbers like electronics'),
                      value: productController.hasSerialNumbers.value,
                      onChanged: isExistingProduct
                          ? null // Disabled for existing products
                          : (value) =>
                              productController.toggleHasSerialNumbers(value),
                    ),
                  );
                }),

                const SizedBox(
                  height: TSizes.spaceBtwInputFields,
                ),

                // Pricing & Stock Row
                Row(
                  children: [
                    // Base Price Field
                    Expanded(
                      child: TextFormField(
                        controller: productController.basePrice,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) =>
                            TValidator.validateEmptyText('Basic price', value),
                        decoration: const InputDecoration(
                          labelText: 'Base Price',
                          hintText: 'Basic price of product',
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: TSizes.spaceBtwInputFields,
                    ),
                    // Sale Price Field
                    Expanded(
                      child: TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: productController.salePrice,
                        validator: (value) =>
                            TValidator.validateEmptyText('Sale price', value),
                        decoration: const InputDecoration(
                          labelText: 'Sale Price',
                          hintText: 'Selling price of product',
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: TSizes.spaceBtwInputFields,
                ),

                Row(
                  children: [
                    // Stock & Alert Stock Row
                    Obx(() => Expanded(
                          child: AnimatedOpacity(
                            opacity: productController.hasSerialNumbers.value
                                ? 0.5
                                : 1.0,
                            duration: const Duration(milliseconds: 300),
                            child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              controller: productController.stock,
                              enabled:
                                  !productController.hasSerialNumbers.value,
                              validator: (value) => !productController
                                      .hasSerialNumbers.value
                                  ? TValidator.validateEmptyText('Stock', value)
                                  : null,
                              decoration: InputDecoration(
                                labelText: 'Stock',
                                hintText: 'Available stock',
                                helperText:
                                    productController.hasSerialNumbers.value
                                        ? 'Auto-managed for serialized products'
                                        : null,
                              ),
                            ),
                          ),
                        )),
                    const SizedBox(
                      width: TSizes.spaceBtwInputFields,
                    ),
                    // Alert Stock Field
                    Expanded(
                      child: TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: productController.alertStock,
                        validator: (value) => TValidator.validateEmptyText(
                            'Alert on stock ', value),
                        decoration: const InputDecoration(
                          labelText: 'Alert Stock',
                          hintText: 'Alert on stock below',
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: TSizes.spaceBtwSections,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
