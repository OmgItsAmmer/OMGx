import 'package:admin_dashboard_v3/Models/customer/customer_model.dart';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/images/t_rounded_image.dart';
import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/tiles/user_advance_info_tile.dart';
import '../../../../controllers/address/address_controller.dart';
import '../../../../controllers/orders/orders_controller.dart';
import '../../../profile/old/widgets/profile_menu.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key, required this.customerModel});
  final CustomerModel customerModel;

  @override
  Widget build(BuildContext context) {
    final AddressController addressController = Get.find<AddressController>();
    final OrderController orderController = Get.find<OrderController>();



    return TRoundedContainer(
      width: 400,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          Text(
            'Customer Information',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(
            height: TSizes.spaceBtwItems,
          ),
          //pfp and name&email
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const TRoundedImage(
                  width: 80,
                  height: 80,
                  imageurl: TImages.user),
              const SizedBox(width: TSizes.spaceBtwItems,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customerModel.fullName,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems/2,),
                  Text(
                    customerModel.email,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),

            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems,),
          TProfilemenu(
            title: "Name",
            value: customerModel.fullName,
            onPressed: () {},
            isTap: false,
          ),
          const SizedBox(height: TSizes.spaceBtwItems,),
          TProfilemenu(
            title: "City",
            value: addressController.allCustomerAddresses[0].city,
            onPressed: () {},
            isTap: false,
          ),
          const SizedBox(height: TSizes.spaceBtwItems,),
          TProfilemenu(
            title: "Phone Number",
            value: customerModel.phoneNumber,
            onPressed: () {},
            isTap: false,
          ),
          const SizedBox(height: TSizes.spaceBtwItems,),
          const Divider(),
           Row(

           // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: OUserAdvanceInfoTile(firstTile: 'Last Order', secondTile: orderController.recentOrderDay )),
              Expanded(child: OUserAdvanceInfoTile(firstTile: 'Average Order', secondTile: orderController.averageTotalAmount)),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: OUserAdvanceInfoTile(firstTile: ' Registered At ', secondTile: '7 Days Ago')),
              Expanded(child: OUserAdvanceInfoTile(firstTile: 'Email Marketing', secondTile: 'UnSubscribed')),
            ],
          ),




        ],
      ),
    );
  }
}
