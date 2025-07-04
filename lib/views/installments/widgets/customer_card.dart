import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/validators/validation.dart';

class CustomerCard extends StatelessWidget {
  final String hintText;

  final cardTitle;

  final userNameTextController;
  final addressTextController;
  final cnicTextController;
  final phoneNoTextController;
  final readOnly;

  const CustomerCard(
      {super.key,
      required this.cardTitle,
      required this.hintText,
      required this.readOnly,
      required this.userNameTextController,
      required this.cnicTextController,
      required this.phoneNoTextController,
      required this.addressTextController});

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      backgroundColor: TColors.primaryBackground,

      //  height: 500,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            cardTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(
            height: TSizes.spaceBtwItems,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                // height: 80,
                child: TextFormField(
                  controller: userNameTextController,
                  validator: (value) =>
                      TValidator.validateEmptyText('Customer Name', value),
                  readOnly: true,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(labelText: 'Customer Name'),
                ),
              ),
              const SizedBox(
                height: TSizes.spaceBtwInputFields / 2,
              ),
              SizedBox(
                width: double.infinity,
                // height: 80,
                child: TextFormField(
                  controller: phoneNoTextController,
                  readOnly: readOnly,
                  validator: (value) =>
                      TValidator.validateEmptyText('Phone Number', value),
                  keyboardType:
                      TextInputType.number, // Ensure numeric keyboard is shown
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ], // Allow only digits
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),
              ),
              const SizedBox(
                height: TSizes.spaceBtwInputFields / 2,
              ),
              SizedBox(
                width: double.infinity,
                // height: 80,

                child: TextFormField(
                  controller: addressTextController,
                  validator: (value) =>
                      TValidator.validateEmptyText('Address', value),
                  readOnly: readOnly,
                  maxLines: 3,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
              ),
              const SizedBox(
                height: TSizes.spaceBtwInputFields / 2,
              ),
              SizedBox(
                width: double.infinity,
                //     height: 80,
                child: TextFormField(
                  controller: cnicTextController,
                  readOnly: readOnly,
                  validator: (value) =>
                      TValidator.validateEmptyText('CNIC', value),
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(labelText: 'CNIC'),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: TSizes.spaceBtwItems,
          ),
        ],
      ),
    );
  }
}
