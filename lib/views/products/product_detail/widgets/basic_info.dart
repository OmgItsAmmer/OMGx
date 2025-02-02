import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../controllers/product/product_controller.dart';
import '../../../../utils/validators/validation.dart';

class BasicInfo extends StatelessWidget {
  const BasicInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find<ProductController>();

    return Form(
      key: productController.productDetail ,
      child: TRoundedContainer(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
         // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Product Detail',style: Theme.of(context).textTheme.bodyLarge,),
            const SizedBox(height: TSizes.spaceBtwSections,),
            TextFormField(
              validator: (value) =>
                  TValidator.validateEmptyText('Product Name', value),
              controller: productController.productName,
              maxLines: 1,
            style: Theme.of(context).textTheme.bodyLarge,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            const SizedBox(height: TSizes.spaceBtwSections,),

            TextFormField(
              validator: (value) =>
                  TValidator.validateEmptyText('Description', value),
              controller: productController.productDescription,

              maxLines: 5,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: const InputDecoration(labelText: 'Description'),
            ),

            const SizedBox(height: TSizes.spaceBtwSections,),

            TextFormField(
              validator: (value) =>
                  TValidator.validateEmptyText('Unit Price', value),
              controller: productController.unitPrice,
              keyboardType: TextInputType
                  .number, // Ensure numeric keyboard is shown
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ], // Allow only digits
              maxLines: 1,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: const InputDecoration(labelText: 'Unit Price'),
            ),

            const SizedBox(height: TSizes.spaceBtwSections,),

            TextFormField(
              validator: (value) =>
                  TValidator.validateEmptyText('Stock', value),
              controller: productController.stock,
              keyboardType: const TextInputType.numberWithOptions(decimal: true), // Allow decimal input
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Allow numbers with one optional decimal point
              ], // Allow only digits

              maxLines: 1,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: const InputDecoration(labelText: 'Stock'),
            ),

            const SizedBox(height: TSizes.spaceBtwSections,),

            TextFormField(
              validator: (value) =>
                  TValidator.validateEmptyText('Alert Stock', value),
              controller: productController.alertStock,
              keyboardType: TextInputType
                  .number, // Ensure numeric keyboard is shown
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ], // Allow only digits
              maxLines: 1,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: const InputDecoration(labelText: 'Alert Stock'),
            ),

            // const SizedBox(height: TSizes.spaceBtwSections,),

            // TextFormField(
            //   controller: productController.productName,
            //
            //   maxLines: 1,
            //   style: Theme.of(context).textTheme.bodyLarge,
            //   decoration: const InputDecoration(labelText: 'Description'),
            // ),
          ],
        ),
      ),
    );
  }
}
