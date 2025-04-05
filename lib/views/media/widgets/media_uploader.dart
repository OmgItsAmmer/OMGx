import 'dart:io';

import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/images/t_rounded_image.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/animation_loader.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/loader_animation.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:file_picker/file_picker.dart';
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
    return Obx(() => (mediaController.showImagesUploaderSection.value)
        ? Column(
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
                                    const SizedBox(
                                        height: TSizes.spaceBtwItems),
                                    const Text('Drag and Drop Images here'),
                                    const SizedBox(
                                        height: TSizes.spaceBtwItems),
                                    OutlinedButton(
                                      onPressed: () async {
                                        mediaController.pickImageFromExplorer();
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
              (mediaController.droppedFiles.isNotEmpty)
                  ? TRoundedContainer(
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  const SizedBox(
                                    width: TSizes.spaceBtwItems,
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: MediaFolderDropDown(
                                      onChanged: (MediaCategory? newValue) {
                                        if (newValue != null) {
                                          mediaController.selectedPath.value =
                                              newValue;
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: TSizes.spaceBtwItems,
                              ),
                              Row(
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        mediaController.droppedFiles.clear();
                                      },
                                      child: const Text('Remove  All')),
                                  const SizedBox(
                                    width: TSizes.spaceBtwItems,
                                  ),
                                  TDeviceUtils.isMobileScreen(context)
                                      ? const SizedBox.shrink()
                                      : SizedBox(
                                          width: TSizes.buttonWidth,
                                          child: ElevatedButton(
                                              onPressed: () {
                                                if (mediaController
                                                        .selectedPath !=
                                                    MediaCategory.folders) {
                                                  //mediaController.uploadImages(mediaController.selectedPath.value.toString().split('.').last);
                                                  _openConfirmationDialog(
                                                      context);
                                                } else {
                                                  TLoader.errorSnackBar(
                                                      title: 'Select Category',
                                                      message:
                                                          'Kindly select the category first');
                                                }
                                              },
                                              child: const Text('Upload')),
                                        )
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: TSizes.spaceBtwSections,
                          ),
                          Wrap(
                            alignment: WrapAlignment.start,
                            spacing: TSizes.spaceBtwItems / 2,
                            runSpacing: TSizes.spaceBtwItems / 2,
                            children: mediaController.droppedFiles
                                .map((file) => GestureDetector(
                                      onTap: () {},
                                      child: SizedBox(
                                        width: 140,
                                        height: 180,
                                        child: Column(
                                          children: [
                                            Expanded(
                                                child: TRoundedImage(
                                              //   backgroundColor: TColors.primaryBackground,
                                              width: 150,
                                              height: 100,
                                              imageurl: file.path,
                                              isNetworkImage: false,
                                              isFileImage: true,
                                            )),
                                          ],
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(
                            height: TSizes.spaceBtwSections,
                          ),
                          TDeviceUtils.isMobileScreen(context)
                              ? SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        if (mediaController.selectedPath !=
                                            MediaCategory.folders) {
                                          mediaController.insertImagesInTableAndBucket(
                                              mediaController.selectedPath.value
                                                  .toString()
                                                  .split('.')
                                                  .last);
                                        } else {
                                          TLoader.errorSnackBar(
                                              title: 'Select Category',
                                              message:
                                                  'Kindly select the category first');
                                        }
                                      },
                                      child: const Text('Upload')),
                                )
                              : const SizedBox.shrink()
                        ],
                      ),
                    )
                  : const SizedBox.shrink()
            ],
          )
        : const SizedBox.shrink());
  }
  void _openConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Are you sure you want to proceed?',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the confirmation dialog
                _openNonClosableDialog(context); // Open the non-closable dialog
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _openNonClosableDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing when clicking outside
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 400,
            width: 200,
            child: Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  TAnimationLoaderWidget(animation: TImages.docerAnimation),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
                  Text(
                    'Sit Tight! Uploading in Progress..',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).then((_) {
      // This block will execute when the dialog is closed
      print("Dialog closed");
    });

    // Call your image upload function here
    _uploadImage(context).then((_) {
      // Close the dialog after the image is uploaded
      Navigator.of(context).pop();
    });
  }

  Future<void> _uploadImage(BuildContext context) async {
    // Simulate an image upload process (replace with your actual upload logic)
    print(mediaController.selectedPath.value.toString().split('.').last);
   mediaController.insertImagesInTableAndBucket(mediaController.selectedPath.value.toString().split('.').last);
  }

}
