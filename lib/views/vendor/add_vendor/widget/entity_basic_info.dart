import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/controllers/address/address_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/enums.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../utils/validators/validation.dart';

class EntityBasicInfo<T> extends StatelessWidget {
  const EntityBasicInfo({
    super.key,
    required this.controller,
    required this.entityType,
  });

  final dynamic controller; // Use GetX controller
  final EntityType entityType;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _getFormKey(controller),
      child: TRoundedContainer(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_getEntityName()} Detail',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(
              height: TSizes.spaceBtwSections,
            ),
            TextFormField(
              validator: (value) =>
                  TValidator.validateEmptyText('First Name', value),
              controller: _getFirstNameController(controller),
              maxLines: 1,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            const SizedBox(
              height: TSizes.spaceBtwSections,
            ),
            TextFormField(
              // Last Name is now optional - no validator
              controller: _getLastNameController(controller),
              maxLines: 1,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: const InputDecoration(labelText: 'Last Name (Optional)'),
            ),
            const SizedBox(
              height: TSizes.spaceBtwSections,
            ),

            TextFormField(
              validator: (value) =>
                  TValidator.validateEmptyText('Email Address', value),
              controller: _getEmailController(controller),
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: const InputDecoration(labelText: 'Email'),
            ),

            const SizedBox(
              height: TSizes.spaceBtwSections,
            ),

            TextFormField(
              // CNIC is now optional - no validator
              controller: _getCnicController(controller),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLines: 1,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: const InputDecoration(labelText: 'CNIC (Optional)'),
            ),

            const SizedBox(
              height: TSizes.spaceBtwSections,
            ),

            TextFormField(
              validator: (value) =>
                  TValidator.validateEmptyText('Phone Number', value),
              controller: _getPhoneNumberController(controller),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
              ],
              maxLines: 1,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(
              height: TSizes.spaceBtwSections,
            ),

            TextFormField(
              validator: (value) {
                final emptyError = TValidator.validateEmptyText('Postal Code', value);
                if (emptyError != null) return emptyError;
                
                // Validate postal code length (typically 5 digits)
                if (value != null && value.isNotEmpty) {
                  final trimmedValue = value.trim();
                  if (trimmedValue.length != 5) {
                    return 'Postal code must be exactly 5 digits.';
                  }
                }
                return null;
              },
              controller: AddressController.instance.postalCode,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(5), // Limit to 5 digits
              ],
              maxLines: 1,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: const InputDecoration(labelText: 'Postal Code'),
            ),
            const SizedBox(
              height: TSizes.spaceBtwSections,
            ),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    validator: (value) {
                      final emptyError = TValidator.validateEmptyText('Address', value);
                      if (emptyError != null) return emptyError;
                      
                      // Validate against database constraint: ^[a-zA-Z0-9\s\.\-\,]+$
                      if (value != null && value.isNotEmpty) {
                        final trimmedValue = value.trim();
                        final pattern = r'^[a-zA-Z0-9\s\.\-\,]+$';
                        final regex = RegExp(pattern);
                        if (!regex.hasMatch(trimmedValue)) {
                          return 'Address can only contain letters, numbers, spaces, periods, commas, and hyphens.';
                        }
                      }
                      return null;
                    },
                    controller: AddressController.instance.address,
                    maxLines: 5,
                    style: Theme.of(context).textTheme.bodyLarge,
                    decoration: const InputDecoration(labelText: 'Address'),
                    inputFormatters: [
                      // Only allow characters that match the database constraint
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s\.\-\,]')),
                    ],
                  ),
                ),
                // const SizedBox(width: TSizes.spaceBtwItems,),
                // GestureDetector(
                //   onTap: (){},
                //   child: const TRoundedContainer(
                //
                //       backgroundColor: TColors.primary,
                //       child: Icon(Iconsax.add,color: TColors.white,)),
                // ),
              ],
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

  String _getEntityName() {
    switch (entityType) {
      case EntityType.customer:
        return 'Customer';
      case EntityType.salesman:
        return 'Salesman';
      case EntityType.vendor:
        return 'Vendor';
      case EntityType.user:
        return 'User';
    }
  }

  GlobalKey<FormState> _getFormKey(dynamic controller) {
    switch (entityType) {
      case EntityType.customer:
        return controller.addCustomerKey;
      case EntityType.salesman:
        return controller.addSalesmanKey;
      case EntityType.vendor:
        return controller.addVendorKey;
      case EntityType.user:
        return controller.addUserKey;
    }
  }

  TextEditingController _getFirstNameController(dynamic controller) {
    switch (entityType) {
      case EntityType.customer:
        return controller.firstName;
      case EntityType.salesman:
        return controller.firstName;
      case EntityType.vendor:
        return controller.firstName;
      case EntityType.user:
        return controller.firstName;
    }
  }

  TextEditingController _getLastNameController(dynamic controller) {
    switch (entityType) {
      case EntityType.customer:
        return controller.lastName;
      case EntityType.salesman:
        return controller.lastName;
      case EntityType.vendor:
        return controller.lastName;
      case EntityType.user:
        return controller.lastName;
    }
  }

  TextEditingController _getEmailController(dynamic controller) {
    switch (entityType) {
      case EntityType.customer:
        return controller.email;
      case EntityType.salesman:
        return controller.email;
      case EntityType.vendor:
        return controller.email;
      case EntityType.user:
        return controller.email;
    }
  }

  TextEditingController _getCnicController(dynamic controller) {
    switch (entityType) {
      case EntityType.customer:
        return controller.cnic;
      case EntityType.salesman:
        return controller.cnic;
      case EntityType.vendor:
        return controller.cnic;
      case EntityType.user:
        return controller.cnic;
    }
  }

  TextEditingController _getPhoneNumberController(dynamic controller) {
    switch (entityType) {
      case EntityType.customer:
        return controller.phoneNumber;
      case EntityType.salesman:
        return controller.phoneNumber;
      case EntityType.vendor:
        return controller.phoneNumber;
      case EntityType.user:
        return controller.phoneNumber;
    }
  }

  // TextEditingController _getAddressController(dynamic controller) {
  //   switch (entityType) {
  //     case EntityType.customer:
  //       return controller.address;
  //     case EntityType.salesman:
  //       return controller.address;
  //     case EntityType.vendor:
  //       return controller.address;
  //   }
  // }
}
