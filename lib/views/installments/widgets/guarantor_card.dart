import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/images/t_rounded_image.dart';
import 'package:admin_dashboard_v3/controllers/guarantors/guarantor_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../common/widgets/dropdown_search/searchable_text_field.dart';
import '../../../common/widgets/icons/t_circular_icon.dart';
import '../../../common/widgets/shimmers/shimmer.dart';
import '../../../controllers/media/media_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/validators/validation.dart';

class GuarrantorCard extends StatelessWidget {
  final String hintText;

  final cardTitle;
  final namesList;
  final addressList;
  final onSelectedName;
  final userNameTextController;
  final addressTextController;
  final cnicTextController;
  final phoneNoTextController;
  final readOnly;
  final int guarrantorIndex;
  final GlobalKey<FormState>? formKey;


  const GuarrantorCard(
      {super.key,
        required this.cardTitle,
        required this.hintText,
        required this.readOnly,
        required this.namesList,
        required this.onSelectedName,
        required this.userNameTextController,
        required this.cnicTextController,
        required this.phoneNoTextController,
        required this.addressList,
        this.formKey,
        required this.addressTextController, required this.guarrantorIndex});

  @override
  Widget build(BuildContext context) {
    final MediaController mediaController = Get.find<MediaController>();
    final GuarantorController guarantorController = Get.find<GuarantorController>();



    return Form(
      key: formKey,
      child: TRoundedContainer(
        backgroundColor: TColors.primaryBackground,

        //  height: 500,
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cardTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),

            Row(
              //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment
                            .bottomRight, // Align the camera icon to the bottom right
                        children: [
                          // Rounded Image
                          Obx(() {

                            final image = mediaController.displayImage.value;

                            if(guarrantorIndex == 1){
                                  guarantorController.guarrantor1Image.value = image;
                            }
                            else if(guarrantorIndex == 2){
                              guarantorController.guarrantor2Image.value = image;

                            }

                            if (image != null && mediaController.displayImageOwner == MediaCategory.guarantors.toString().split('.').last ) {
                              return FutureBuilder<String?>(
                                future: mediaController.getImageFromBucket(
                                  MediaCategory.guarantors.toString().split('.').last,
                                  image.filename ?? '',
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const TShimmerEffect(width: 120, height: 120);
                                  } else if (snapshot.hasError || snapshot.data == null) {
                                    return const Icon(Icons.error);
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
                            }
                            else{
                              return const TCircularIcon(
                                          icon: Iconsax.image,
                                          width: 120,
                                          height: 120,
                                          backgroundColor: TColors.primaryBackground,
                                        );
                            }

                            // 👇 Uses entityId directly to reactively fetch new image
                            // return FutureBuilder<String?>(
                            //   future: mediaController.fetchMainImage(
                            //     -1,
                            //     MediaCategory.guarantors.toString().split('.').last,
                            //   ),
                            //   builder: (context, snapshot) {
                            //     if (snapshot.connectionState == ConnectionState.waiting) {
                            //       return const TShimmerEffect(width: 120, height: 120);
                            //     } else if (snapshot.hasError || snapshot.data == null) {
                            //       return const TCircularIcon(
                            //         icon: Iconsax.image,
                            //         width: 120,
                            //         height: 120,
                            //         backgroundColor: TColors.primaryBackground,
                            //       );
                            //     } else {
                            //       return TRoundedImage(
                            //         isNetworkImage: true,
                            //         width: 120,
                            //         height: 120,
                            //         imageurl: snapshot.data!,
                            //       );
                            //     }
                            //   },
                            // );
                          }),



                          // Camera Icon
                          Positioned(
                            right: 0, // Adjust the position of the icon
                            bottom: 0, // Adjust the position of the icon
                            child: GestureDetector(
                              onTap: () {
                                // productImagesController
                                //     .selectThumbnailImage(); // Trigger image selection
                                mediaController.selectImagesFromMedia();
                              },
                              child: const TRoundedContainer(
                                borderColor: TColors.white,
                                backgroundColor: TColors.primary,
                                padding: EdgeInsets.all(
                                    6), // Add padding around the icon
                                child: Icon(
                                  Iconsax.camera, // Camera icon
                                  size: 25, // Icon size
                                  color: Colors.white, // Icon color
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: TSizes.spaceBtwItems,
                      ),
                      SizedBox(
                        width: double.infinity,
                        // height: 80,
                        child: TextFormField(
                          controller:
                          userNameTextController,
                          validator: (value) => TValidator.validateEmptyText(
                              'Name', value),

                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration:
                          const InputDecoration(labelText: 'Name'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: TSizes.spaceBtwSections,
                ),
                Expanded(
                  child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          // height: 80,
                          child: TextFormField(
                            controller:
                           phoneNoTextController,
                            validator: (value) => TValidator.validateEmptyText(
                                'Phone Number', value),
                            keyboardType: TextInputType
                                .number, // Ensure numeric keyboard is shown
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ], // Allow only digits
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration:
                            const InputDecoration(labelText: 'Phone Number'),
                          ),
                        ),
                        const SizedBox(
                          height: TSizes.spaceBtwInputFields / 2,
                        ),
                        SizedBox(
                          width: double.infinity,
                          // height: 80,

                          child: TextFormField(
                            controller:
                            addressTextController,
                            validator: (value) => TValidator.validateEmptyText(
                                'Address', value),
                            keyboardType: TextInputType
                                .number, // Ensure numeric keyboard is shown
                            readOnly: readOnly,
                            maxLines: 3,
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration:
                            const InputDecoration(labelText: 'Address'),
                          ),
                        ),
                        const SizedBox(
                          height: TSizes.spaceBtwInputFields / 2,
                        ),
                        SizedBox(
                          width: double.infinity,
                          //     height: 80,
                          child: TextFormField(
                            controller:
                            cnicTextController,
                            validator: (value) =>
                                TValidator.validateEmptyText('CNIC', value),
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration: const InputDecoration(labelText: 'CNIC'),
                            keyboardType: TextInputType
                                .number, // Ensure numeric keyboard is shown
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                      ],
                    ),

                )
              ],
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),

          ],
        ),
      ),
    );
  }
}
