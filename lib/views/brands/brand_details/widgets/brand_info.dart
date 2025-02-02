import 'package:admin_dashboard_v3/Models/brand/brand_model.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../controllers/brands/brand_controller.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/validators/validation.dart';

class BrandInfo extends StatelessWidget {
  const BrandInfo({super.key, required this.brandModel});
  final BrandModel brandModel;

  @override
  Widget build(BuildContext context) {
    final BrandController brandController = Get.find<BrandController>();
    final bool isMobile = TDeviceUtils.isMobileScreen(context);

    return Form(
      key: brandController.brandDetail,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Header
          Text(
            'Brand Details',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          // Brand name text field
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: brandController.brandName,
                  validator: (value) =>
                      TValidator.validateEmptyText('Brand Name', value),
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(labelText: 'Brand Name'),
                ),
              ),
            ],
          ),

          const SizedBox(height: TSizes.spaceBtwSections),

          // Image
          InkWell(
            onTap: () {
              // Handle image tap
            },
            child: TRoundedImage(
              height: isMobile ? 80 : 100, // Adjust image size for mobile
              width: isMobile ? 80 : 100,
              imageurl: TImages.productImage1,
              isNetworkImage: false,
            ),
          ),

          const SizedBox(height: TSizes.spaceBtwSections),

          // Save button
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle save button press
                    brandController.saveOrUpdate(brandModel.brandID);
                  },
                  child: Text(
                    'Save',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .apply(color: TColors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}