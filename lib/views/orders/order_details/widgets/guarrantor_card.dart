import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../controllers/guarantors/guarantor_controller.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';

class GuarantorCard extends StatelessWidget {
  final String title;
  final int guarantorIndex;

  const GuarantorCard({
    super.key,
    required this.title,
    required this.guarantorIndex,
  });

  @override
  Widget build(BuildContext context) {
    final GuarantorController guarantorController = Get.find<GuarantorController>();

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: TSizes.spaceBtwSections),
          Row(
            children: [
              const TRoundedImage(
                width: 120,
                height: 120,
                imageurl: TImages.user,
                padding: EdgeInsets.all(0),
                isNetworkImage: false,
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Expanded(
                child: Obx(() {
                  final guarantors = guarantorController.selectedGuarantors;
                  if (guarantors.isNotEmpty && guarantorIndex < guarantors.length) {
                    final guarantor = guarantors[guarantorIndex];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoText(context, guarantor.fullName, "No Guarantor Found"),
                        _buildInfoText(context, guarantor.cnic, "No CNIC Found"),
                        _buildInfoText(context, guarantor.phoneNumber, "No Phone Number Found"),
                        _buildInfoText(context, guarantor.address, "No Address Found"),
                      ],
                    );
                  } else {
                    return Text('No Guarantors Available', style: Theme.of(context).textTheme.titleLarge);
                  }
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoText(BuildContext context, String? value, String fallback) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TSizes.spaceBtwSections / 2),
      child: Text(
        value?.isNotEmpty == true ? value! : fallback,
        style: Theme.of(context).textTheme.titleSmall,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}
