import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/images/t_rounded_image.dart';
import 'package:admin_dashboard_v3/common/widgets/shimmers/shimmer.dart';
import 'package:admin_dashboard_v3/controllers/guarantors/guarantor_image_controller.dart';
import 'package:admin_dashboard_v3/controllers/media/media_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class GuarantorImage extends StatelessWidget {
  final int guarantorId;
  final String guarantorType;
  final double width;
  final double height;
  final bool useDefaultImage;

  const GuarantorImage({
    Key? key,
    required this.guarantorId,
    required this.guarantorType,
    this.width = 150,
    this.height = 150,
    this.useDefaultImage = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaController mediaController = Get.find<MediaController>();
    final GuarantorImageController guarantorController =
        Get.find<GuarantorImageController>();

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Rounded Image
        Obx(() {
          final image =
              mediaController.getImageForOwner(guarantorId, guarantorType);

          if (image != null) {
            return FutureBuilder<String?>(
              future: mediaController.getImageFromBucket(
                guarantorType,
                image.filename ?? '',
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return TShimmerEffect(width: width, height: height);
                } else if (snapshot.hasError || snapshot.data == null) {
                  return Icon(
                    Iconsax.profile_circle,
                    size: width * 0.7,
                    color: TColors.primary,
                  );
                } else {
                  return TRoundedImage(
                    isNetworkImage: true,
                    width: width,
                    height: height,
                    imageurl: snapshot.data!,
                  );
                }
              },
            );
          }

          // If useDefaultImage is true, show default profile icon
          if (useDefaultImage) {
            return Icon(
              Iconsax.profile_circle,
              size: width * 0.7,
              color: TColors.primary,
            );
          }

          // Fallback to future-based image if no image is selected and not using default
          return FutureBuilder<String?>(
            future: mediaController.fetchImageForOwner(
              guarantorId,
              guarantorType,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return TShimmerEffect(width: width, height: height);
              } else if (snapshot.hasError || snapshot.data == null) {
                return Icon(
                  Iconsax.profile_circle,
                  size: width * 0.7,
                  color: TColors.primary,
                );
              } else {
                return TRoundedImage(
                  isNetworkImage: true,
                  width: width,
                  height: height,
                  imageurl: snapshot.data!,
                );
              }
            },
          );
        }),

        // Camera Icon for selecting image
        TRoundedContainer(
          onTap: () {
            // Use the guarantor-specific selection method
            if (guarantorId == 1) {
              guarantorController.selectGuarantor1Image();
            } else if (guarantorId == 2) {
              guarantorController.selectGuarantor2Image();
            } else {
              // Fallback to the generic method for other guarantors
              mediaController.selectImagesForOwner(
                ownerId: guarantorId,
                ownerType: guarantorType,
                allowSelection: true,
                multipleSelection: false,
              );
            }
          },
          borderColor: TColors.white,
          backgroundColor: TColors.primary,
          padding: const EdgeInsets.all(6),
          child: const Icon(
            Iconsax.camera,
            size: 25,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
