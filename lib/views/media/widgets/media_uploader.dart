import 'dart:io';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/images/t_rounded_image.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/animation_loader.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
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
                              // print(val);
                            },
                            onDragDone: (details) {
                              for (var file in details.files) {
                                mediaController.addDroppedFile(File(file.path));
                              }
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Center(
                                child: Obx(() {
                                  if (mediaController.isInserting.value) {
                                    return TAnimationLoaderWidget(
                                      animation: TImages.docerAnimation,
                                      height: 80,
                                      width: 80,
                                      text: 'Uploading...',
                                    );
                                  }

                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TAnimationLoaderWidget(
                                        animation: TImages.imageUploading,
                                        height: 80,
                                        width: 80,
                                        text: (TDeviceUtils.isMobileScreen(
                                                context))
                                            ? ''
                                            : 'Drag and Drop Images here',
                                      ),
                                      // const SizedBox(
                                      //     height: TSizes.spaceBtwItems),
                                      // const Text('Drag and Drop Images here'),
                                      const SizedBox(
                                          height: TSizes.spaceBtwItems),
                                      OutlinedButton(
                                        onPressed: () async {
                                          mediaController
                                              .pickImageFromExplorer();
                                        },
                                        child: const Text('Select Images'),
                                      ),
                                    ],
                                  );
                                }),
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
                                        // Add confirmation dialog before removing all
                                        Get.defaultDialog(
                                          title: 'Confirm Removal',
                                          middleText:
                                              'Are you sure you want to remove all images?',
                                          textConfirm: 'Yes',
                                          textCancel: 'No',
                                          onConfirm: () {
                                            mediaController.droppedFiles
                                                .clear();
                                            Navigator.of(context).pop();
                                          },
                                          onCancel: () {
                                            Navigator.of(context).pop();
                                          },
                                        );
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
                                                // Step 1: Confirmation dialog
                                                Get.defaultDialog(
                                                  title: 'Confirm Upload',
                                                  middleText:
                                                      'Are you sure you want to upload?',
                                                  textConfirm: 'Yes',
                                                  textCancel: 'No',
                                                  onConfirm: () {
                                                    Navigator.of(context).pop();

                                                    mediaController
                                                        .insertImagesInTableAndBucket(
                                                      mediaController
                                                          .selectedPath.value
                                                          .toString()
                                                          .split('.')
                                                          .last,
                                                    );
                                                  },
                                                  onCancel: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                );
                                              } else {
                                                TLoaders.errorSnackBar(
                                                  title: 'Select Category',
                                                  message:
                                                      'Kindly select the category first',
                                                );
                                              }
                                            },
                                            child: const Text('Upload'),
                                          ))
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
                                .asMap()
                                .entries
                                .map((entry) {
                              final index = entry.key;
                              final file = entry.value;
                              return Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: SizedBox(
                                      width: 140,
                                      height: 180,
                                      child: Column(
                                        children: [
                                          Expanded(
                                              child: TRoundedImage(
                                            width: 150,
                                            height: 100,
                                            imageurl: file.path,
                                            isNetworkImage: false,
                                            isFileImage: true,
                                          )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Cross icon to remove individual images
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        mediaController.droppedFiles
                                            .removeAt(index);
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        child: const Icon(
                                          Icons.close,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                          const SizedBox(
                            height: TSizes.spaceBtwSections,
                          ),
                          TDeviceUtils.isMobileScreen(context)
                              ? Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        if (mediaController.selectedPath !=
                                            MediaCategory.folders) {
                                          // Step 1: Confirmation dialog
                                          Get.defaultDialog(
                                            title: 'Confirm Upload',
                                            middleText:
                                                'Are you sure you want to upload?',
                                            textConfirm: 'Yes',
                                            textCancel: 'No',
                                            onConfirm: () {
                                              Navigator.of(context).pop();
                                              mediaController
                                                  .insertImagesInTableAndBucket(
                                                mediaController
                                                    .selectedPath.value
                                                    .toString()
                                                    .split('.')
                                                    .last,
                                              );
                                            },
                                            onCancel: () {
                                              Navigator.of(context).pop();
                                            },
                                          );
                                        } else {
                                          TLoaders.errorSnackBar(
                                            title: 'Select Category',
                                            message:
                                                'Kindly select the category first',
                                          );
                                        }
                                      },
                                      child: const Text('Upload'),
                                    ),
                                    const SizedBox(
                                      height: TSizes.spaceBtwItems,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Add confirmation dialog before removing all
                                        Get.defaultDialog(
                                          title: 'Confirm Removal',
                                          middleText:
                                              'Are you sure you want to remove all images?',
                                          textConfirm: 'Yes',
                                          textCancel: 'No',
                                          onConfirm: () {
                                            mediaController.droppedFiles
                                                .clear();
                                            Navigator.of(context).pop();
                                          },
                                          onCancel: () {
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      },
                                      child: const Text('Remove All'),
                                    ),
                                  ],
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
}
