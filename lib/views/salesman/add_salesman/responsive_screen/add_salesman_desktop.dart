import 'package:ecommerce_dashboard/Models/salesman/salesman_model.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import '../widgets/add_salesman_bottom_bar.dart';
import '../widgets/salesman_basic_info.dart';
import '../widgets/salesman_thumbnaiil_info.dart';

// Import Material.dart for buttons and other Material Design widgets

class AddSalesmanDesktop extends StatelessWidget {
  const AddSalesmanDesktop({super.key, required this.salesmanModel});

  final SalesmanModel salesmanModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    SalesmanBasicInfo(),
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
                    SalesmanThumbnailInfo(),

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
      bottomNavigationBar: AddSalesmanBottomBar(
        salesmanModel: salesmanModel,
      ),
    );
  }
}
