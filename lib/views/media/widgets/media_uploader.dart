import 'dart:io';

import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/images/t_rounded_image.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:get/get.dart';

import '../../../controllers/media/media_controller.dart';
import 'folder_dropdown.dart';

class MediaUploader extends StatelessWidget {
  MediaUploader({super.key});


  final MediaController mediaController = Get.find<MediaController>();


  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=>  (mediaController.showImagesUploaderSection.value)?
          Column(
        children: [
          // Drag and drop area
          TRoundedContainer(
            showBorder: true,
            height: 250,
            borderColor: TColors.borderPrimary,
            backgroundColor: TColors.primaryBackground,
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // DropZone using desktop_drop
                      DropTarget(
                        onDragEntered: (val) {
                          print(val);
                        },
                        onDragDone: (details) {
                          for (var file in details.files) {
                            mediaController.addDroppedFile(File(file.path));
                          }
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(TImages.productImage1,
                                    width: 50, height: 50),
                                const SizedBox(height: TSizes.spaceBtwItems),
                                const Text('Drag and Drop Images here'),
                                const SizedBox(height: TSizes.spaceBtwItems),
                                OutlinedButton(
                                  onPressed: () {
                                    // Implement file picker logic here
                                  },
                                  child: const Text('Select Images'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: TSizes.spaceBtwItems,
          ),
          // Locally selected Images
          TRoundedContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        //Folders DropDown
                        Text(
                          'Select Folder',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(
                          width: TSizes.spaceBtwItems,
                        ),
                        MediaFolderDropDown(
                          onChanged: (MediaCategory? newValue) {
                            if (newValue != null) {
                              mediaController.selectedPath.value = newValue;
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: TSizes.spaceBtwItems,
                    ),
                    Row(
                      children: [
                        TextButton(
                            onPressed: () {}, child: const Text('Remove  All')),
                        const SizedBox(
                          width: TSizes.spaceBtwItems,
                        ),
                        TDeviceUtils.isMobileScreen(context) ? const SizedBox.shrink() :
                        SizedBox(
                          width: TSizes.buttonWidth,
                          child: ElevatedButton(
                              onPressed: () {}, child: const Text('Upload')),
                        )
                      ],
                    ),


                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwSections,),
                const Wrap(
                  alignment: WrapAlignment.start,
                  spacing: TSizes.spaceBtwItems/2,
                  runSpacing: TSizes.spaceBtwItems/2,
                  children: [
                    TRoundedImage(imageurl: TImages.productImage1,
                      width: 90,
                      height: 90,
                      padding:EdgeInsets.all( TSizes.sm),
                      backgroundColor: TColors.primaryBackground,

                    ),
                      TRoundedImage(imageurl: TImages.productImage1,
                        width: 90,
                        height: 90,
                        padding:EdgeInsets.all( TSizes.sm),
                        backgroundColor: TColors.primaryBackground,

                      ),
                      TRoundedImage(imageurl: TImages.productImage1,
                        width: 90,
                        height: 90,
                        padding:EdgeInsets.all( TSizes.sm),
                        backgroundColor: TColors.primaryBackground,

                      ),
                      TRoundedImage(imageurl: TImages.productImage1,
                        width: 90,
                        height: 90,
                        padding:EdgeInsets.all( TSizes.sm),
                        backgroundColor: TColors.primaryBackground,

                      ),
                      TRoundedImage(imageurl: TImages.productImage1,
                        width: 90,
                        height: 90,
                        padding:EdgeInsets.all( TSizes.sm),
                        backgroundColor: TColors.primaryBackground,

                      ), TRoundedImage(imageurl: TImages.productImage1,
                        width: 90,
                        height: 90,
                        padding:EdgeInsets.all( TSizes.sm),
                        backgroundColor: TColors.primaryBackground,

                      ), TRoundedImage(imageurl: TImages.productImage1,
                        width: 90,
                        height: 90,
                        padding:EdgeInsets.all( TSizes.sm),
                        backgroundColor: TColors.primaryBackground,

                      ), TRoundedImage(imageurl: TImages.productImage1,
                        width: 90,
                        height: 90,
                        padding:EdgeInsets.all( TSizes.sm),
                        backgroundColor: TColors.primaryBackground,

                      ), TRoundedImage(imageurl: TImages.productImage1,
                      width: 90,
                      height: 90,
                      padding:EdgeInsets.all( TSizes.sm),
                      backgroundColor: TColors.primaryBackground,

                    ),
                    TRoundedImage(imageurl: TImages.productImage1,
                      width: 90,
                      height: 90,
                      padding:EdgeInsets.all( TSizes.sm),
                      backgroundColor: TColors.primaryBackground,

                    ),




                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwSections,),
                TDeviceUtils.isMobileScreen(context) ? SizedBox(width: double.infinity,child: ElevatedButton(onPressed: (){}, child: const Text('Upload')),): const SizedBox.shrink()
              ],
            ),
          )
        ],
      )
      : const SizedBox.shrink()
    );
  }
}
