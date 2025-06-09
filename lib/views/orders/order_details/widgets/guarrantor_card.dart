import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../common/widgets/shimmers/shimmer.dart';
import '../../../../controllers/guarantors/guarantor_controller.dart';
import '../../../../controllers/media/media_controller.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';

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
    final GuarantorController guarantorController =
        Get.find<GuarantorController>();
    final MediaController mediaController = Get.find<MediaController>();
    final entityType = MediaCategory.guarantors.toString().split('.').last;

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: TSizes.spaceBtwSections),
          Row(
            children: [
              Obx(() {
                // Get the guarantor ID based on index
                final guarantors = guarantorController.selectedGuarantors;
                if (guarantors.isEmpty || guarantorIndex >= guarantors.length) {
                  return const TRoundedImage(
                    width: 120,
                    height: 120,
                    imageurl: TImages.user,
                    padding: EdgeInsets.all(0),
                    isNetworkImage: false,
                  );
                }

                final guarantorId = guarantors[guarantorIndex].guarantorId;
                if (guarantorId == null || guarantorId <= 0) {
                  return const TRoundedImage(
                    width: 120,
                    height: 120,
                    imageurl: TImages.user,
                    padding: EdgeInsets.all(0),
                    isNetworkImage: false,
                  );
                }

                return FutureBuilder<String?>(
                  future: mediaController.fetchImageForOwner(
                    guarantorId,
                    entityType,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const TShimmerEffect(width: 120, height: 120);
                    } else if (snapshot.hasError || snapshot.data == null) {
                      return const TRoundedImage(
                        width: 120,
                        height: 120,
                        imageurl: TImages.user,
                        padding: EdgeInsets.all(0),
                        isNetworkImage: false,
                      );
                    } else {
                      return TRoundedImage(
                        isNetworkImage: true,
                        width: 120,
                        height: 120,
                        imageurl: snapshot.data!,
                      );
                    }
                  },
                );
              }),
              const SizedBox(width: TSizes.spaceBtwItems),
              Expanded(
                child: Obx(() {
                  final guarantors = guarantorController.selectedGuarantors;
                  if (guarantors.isNotEmpty &&
                      guarantorIndex < guarantors.length) {
                    final guarantor = guarantors[guarantorIndex];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoText(
                            context, guarantor.fullName, "No Guarantor Found",isBold: true),
                        _buildInfoText(
                            context, guarantor.cnic, "No CNIC Found"),
                        _buildInfoText(context, guarantor.phoneNumber,
                            "No Phone Number Found"),
                        _buildInfoText(
                            context, guarantor.address, "No Address Found"),
                      ],
                    );
                  } else {
                    return Text('No Guarantors Available',
                        style: Theme.of(context).textTheme.titleLarge);
                  }
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
Widget _buildInfoText(BuildContext context, String? value, String fallback, {bool isBold = false}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: TSizes.spaceBtwSections / 2),
    child: Text(
      value?.isNotEmpty == true ? value! : fallback,
      style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    ),
  );
}

}
