import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../controllers/media/media_controller.dart';
import '../../../../controllers/product/product_controller.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';

class ProductDetailBottomBar extends StatelessWidget {
  const ProductDetailBottomBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find<ProductController>();


    return TRoundedContainer(

      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
              flex: TDeviceUtils.isDesktopScreen(context) ? 4 : 0,
              child: const SizedBox()),
          Expanded(
            child: SizedBox(
              width: double.infinity,

              child: OutlinedButton(
                onPressed: () {
                  // Handle Discard action
                  productController.cleanProductDetail();
                  Navigator.of(context).pop();

                },
                child: const Text('Discard'),
              ),
            ),
          ),
          const SizedBox(width: TSizes.spaceBtwItems),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle Save action


                  productController.saveOrUpdateProduct();
                  Navigator.of(context).pop();


                },
                child: const Text('Save/Update'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}