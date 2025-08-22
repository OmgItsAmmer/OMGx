import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../controllers/product/product_controller.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';

class ProductDetailBottomBar extends StatelessWidget {
  const ProductDetailBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = Get.find<ProductController>();

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            flex: TDeviceUtils.isDesktopScreen(context) ? 4 : 0,
            child: const SizedBox(),
          ),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.cancel, size: 18, color: TColors.white),
                label: const Text('Discard (Esc)'),
                onPressed: productController.isUpdating.value
                    ? null
                    : () => productController.handleDiscard(),
              ),
            ),
          ),
          const SizedBox(width: TSizes.spaceBtwItems),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Obx(
                () => ElevatedButton.icon(
                  icon: const Icon(Icons.done_all, size: 18, color: TColors.white),
                  label: Text(
                    productController.productId.value == -1
                        ? 'Save (Ctrl+Enter)'
                        : 'Update (Ctrl+Enter)',
                  ),
                  onPressed: productController.isUpdating.value
                      ? null
                      : () async => await productController.handleSave(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primary,
                    foregroundColor: TColors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SaveIntent extends Intent {
  const SaveIntent();
}

class DiscardIntent extends Intent {
  const DiscardIntent();
}
