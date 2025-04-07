import 'package:admin_dashboard_v3/Models/customer/customer_model.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widget/add_customer_bottom_bar.dart';
import '../widget/customer_basic_info.dart';
import '../widget/customer_thumbnail_info.dart'; // Import Material.dart for buttons and other Material Design widgets



class AddCustomerDesktop extends StatelessWidget {
  const AddCustomerDesktop( {super.key,
  required this.customerModel,
  });

  final CustomerModel customerModel;

  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child: Scaffold(
        body: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(TSizes.defaultSpace),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Info
                      CustomerBasicInfo(),
                      SizedBox(height: TSizes.spaceBtwSections),
                      // Variation Info
                       //VariationInfo(),
                    ],
                  ),
                ),
                SizedBox(width: TSizes.spaceBtwSections),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thumbnail Upload
                      CustomerThumbnailInfo(),

                      // Extra Images
                      // const SizedBox(height: TSizes.spaceBtwSections),
                      // const ExtraImages(),

                      // Brand & Category & visibility
                      SizedBox(height: TSizes.spaceBtwSections),
                   //   ProductBrandcCategory(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: AddCustomerBottomBar(customerModel: customerModel,),
      ),
    );
  }
}

