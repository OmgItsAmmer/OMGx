import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/address/address_controller.dart';

class AddressInfo extends StatelessWidget {
  const   AddressInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final AddressController addressController = Get.find<AddressController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TRoundedContainer(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

            ]
          ),
        ),




        TRoundedContainer(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Obx(
                  () { 
                    
                    if(addressController.currentAddresses.isEmpty){
                      return const Text('No Addresses');
                    }
                return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) =>
                const SizedBox(height: TSizes.spaceBtwInputFields,),
                itemCount: addressController.currentAddresses.length,
                itemBuilder: (_, index) {
                  return TRoundedContainer(
                      backgroundColor: TColors.primaryBackground,
                      padding: const EdgeInsets.all(TSizes.defaultSpace),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Expanded(child: Text('Address#$index', style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium,)),
                          const SizedBox(width: TSizes.spaceBtwInputFields,),

                          Expanded(child: Text(addressController
                              .currentAddresses[index].location ?? '', style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium,)),
                          const SizedBox(width: TSizes.spaceBtwInputFields,),

                        
                        ],
                      )
                  );
                },);
              }
          ),
        )

      ],
    );
  }
}
