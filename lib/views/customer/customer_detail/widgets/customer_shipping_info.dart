import 'package:ecommerce_dashboard/Models/customer/customer_model.dart';
import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/address/address_controller.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../profile/old/widgets/profile_menu.dart';

class CustomerShippingInfo extends StatelessWidget {
  const CustomerShippingInfo({super.key, required this.customerModel});
  final CustomerModel customerModel;

  @override
  Widget build(BuildContext context) {
    final AddressController addressController = Get.find<AddressController>();

    return TRoundedContainer(
      width: 400,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          Text(
            'Shipping Information',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(
            height: TSizes.spaceBtwItems,
          ),

          TProfilemenu(
            title: "Name",
            value: customerModel.fullName,
            onPressed: () {},
            isTap: false,
          ),
          const SizedBox(
            height: TSizes.spaceBtwItems,
          ),

          TProfilemenu(
            title: "Phone Number",
            value: customerModel.phoneNumber,
            onPressed: () {},
            isTap: false,
          ),
          const SizedBox(
            height: TSizes.spaceBtwItems,
          ),
          TProfilemenu(
            title: "Address",
            value: addressController.allCustomerAddresses[0].location ?? '',
            onPressed: () {},
            isTap: false,
          ),
        ],
      ),
    );
  }
}
