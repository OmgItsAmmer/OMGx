import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/controllers/address/address_controller.dart';
import 'package:admin_dashboard_v3/controllers/customer/customer_controller.dart';
import 'package:admin_dashboard_v3/controllers/salesman/salesman_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../controllers/product/product_controller.dart';
import '../../../../utils/validators/validation.dart';

class SalesmanBasicInfo extends StatelessWidget {
  const SalesmanBasicInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final SalesmanController salesmanController = Get.find<SalesmanController>();
    final AddressController addressController = Get.find<AddressController>();

    return Form(
      key: salesmanController.addSalesmanKey ,
      child: TRoundedContainer(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Salesman Detail',style: Theme.of(context).textTheme.bodyLarge,),
            const SizedBox(height: TSizes.spaceBtwSections,),
            TextFormField(
              validator: (value) =>
                  TValidator.validateEmptyText('First Name', value),
              controller: salesmanController.firstName,
              maxLines: 1,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            const SizedBox(height: TSizes.spaceBtwSections,),
            TextFormField(
              validator: (value) =>
                  TValidator.validateEmptyText('Last Name', value),
              controller: salesmanController.lastName,
              maxLines: 1,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            const SizedBox(height: TSizes.spaceBtwSections,),

            TextFormField(
              validator: (value) =>
                  TValidator.validateEmptyText('Email Address', value),
              controller: salesmanController.email,

              // maxLines: 5,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: const InputDecoration(labelText: 'Email'),
            ),

            const SizedBox(height: TSizes.spaceBtwSections,),

            TextFormField(
              validator: (value) =>
                  TValidator.validateEmptyText('CNIC', value),
              controller: salesmanController.cnic,
              keyboardType: TextInputType
                  .number, // Ensure numeric keyboard is shown
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ], // Allow only digits
              maxLines: 1,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: const InputDecoration(labelText: 'CNIC'),
            ),

            const SizedBox(height: TSizes.spaceBtwSections,),

            TextFormField(
              validator: (value) =>
                  TValidator.validateEmptyText('Phone Number', value),
              controller: salesmanController.phoneNumber,
              keyboardType: const TextInputType.numberWithOptions(decimal: true), // Allow decimal input
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Allow numbers with one optional decimal point
              ], // Allow only digits

              maxLines: 1,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: TSizes.spaceBtwSections,),

            TextFormField(
              validator: (value) =>
                  TValidator.validateEmptyText('Commission', value),
              controller: salesmanController.commission,
              keyboardType: const TextInputType.numberWithOptions(decimal: true), // Allow decimal input
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Allow numbers with one optional decimal point
              ], // Allow only digits

              maxLines: 1,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: const InputDecoration(labelText: 'Commission(%)'),
            ),
            const SizedBox(height: TSizes.spaceBtwSections,),
            TextFormField(
              validator: (value) =>
                  TValidator.validateEmptyText('Area', value),
              controller: salesmanController.area,

              // maxLines: 5,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: const InputDecoration(labelText: 'Area'),
            ),

            const SizedBox(height: TSizes.spaceBtwSections,),
            TextFormField(
              validator: (value) =>
                  TValidator.validateEmptyText('City', value),
              controller: salesmanController.city,

              // maxLines: 5,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: const InputDecoration(labelText: 'City'),
            ),




            // Row(
            //   children: [
            //     Expanded(
            //       child: TextFormField(
            //         validator: (value) =>
            //             TValidator.validateEmptyText('Address', value),
            //         controller: addressController.address,
            //         // Allow only digits
            //
            //         maxLines: 5,
            //         style: Theme.of(context).textTheme.bodyLarge,
            //         decoration: const InputDecoration(labelText: 'Address'),
            //       ),
            //     ),
            //     // const SizedBox(width: TSizes.spaceBtwItems,),
            //     // GestureDetector(
            //     //   onTap: (){},
            //     //   child: const TRoundedContainer(
            //     //
            //     //       backgroundColor: TColors.primary,
            //     //       child: Icon(Iconsax.add,color: TColors.white,)),
            //     // ),
            //   ],
            // ),



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
