import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/images/t_rounded_image.dart';
import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../../../profile/profile_detail.dart';
import '../../../profile/widgets/profile_menu.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
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
                    'Ammer Saeed',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems/2,),
                  Text(
                    'ammersaeed21@gmail.com',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),

            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems,),
          TProfilemenu(
            title: "Name",
            value: 'Ammer Saeed',
            onPressed: () {},
            isTap: false,
          ),
          const SizedBox(height: TSizes.spaceBtwItems,),
          TProfilemenu(
            title: "City",
            value: 'Chishtian',
            onPressed: () {},
            isTap: false,
          ),
          const SizedBox(height: TSizes.spaceBtwItems,),
          TProfilemenu(
            title: "Phone Number",
            value: '03236508184',
            onPressed: () {},
            isTap: false,
          ),
          const SizedBox(height: TSizes.spaceBtwItems,),
          const Divider(),
          const Row(

           // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: OUserAdvanceInfoTile(firstTile: 'Last Order', secondTile: '7 Days Ago')),
              Expanded(child: OUserAdvanceInfoTile(firstTile: 'Average Order', secondTile: '3500')),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: OUserAdvanceInfoTile(firstTile: 'Last Order', secondTile: '7 Days Ago')),
              Expanded(child: OUserAdvanceInfoTile(firstTile: 'Average Order', secondTile: '3500')),
            ],
          ),
          



        ],
      ),
    );
  }
}
