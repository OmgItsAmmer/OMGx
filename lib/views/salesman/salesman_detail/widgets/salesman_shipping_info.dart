import 'package:admin_dashboard_v3/Models/salesman/salesman_model.dart';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../profile/old/widgets/profile_menu.dart';

class SalesmanShippingInfo extends StatelessWidget {
  const SalesmanShippingInfo({super.key, required this.salesmanModel});
  final SalesmanModel salesmanModel;

  @override
  Widget build(BuildContext context) {
   // final AddressController addressController = Get.find<AddressController>();

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
            value: salesmanModel.fullName ,
            onPressed: () {},
            isTap: false,
          ),
          const SizedBox(height: TSizes.spaceBtwItems,),



          TProfilemenu(
            title: "Phone Number",
            value: salesmanModel.phoneNumber ,
            onPressed: () {},
            isTap: false,
          ),
          const SizedBox(height: TSizes.spaceBtwItems,),
          TProfilemenu(
            title: "Area",
            value:  salesmanModel.area,
            onPressed: () {},
            isTap: false,
          ),
          const SizedBox(height: TSizes.spaceBtwItems,),
          TProfilemenu(
            title: "City",
            value:  salesmanModel.city,
            onPressed: () {},
            isTap: false,
          ),

        ],
      ),
    );
  }
}