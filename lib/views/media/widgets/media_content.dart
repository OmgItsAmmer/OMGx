import 'package:admin_dashboard_v3/Models/image/combined_image_model.dart';
import 'package:admin_dashboard_v3/Models/image/image_model.dart';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/loader_animation.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/common/widgets/shimmers/shimmer.dart';
import 'package:admin_dashboard_v3/controllers/media/media_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:path/path.dart';

import '../../../common/widgets/images/t_rounded_image.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/enums.dart';
import 'folder_dropdown.dart';

class MediaContent extends StatelessWidget {
  MediaContent({
    super.key,
    required this.allowSelection,
    required this.allowMultipleSelection,
    this.alreadySelectedUrls,
    required this.onSelectedImage,
  });

  final bool allowSelection;
  final bool allowMultipleSelection;
  final List<String>? alreadySelectedUrls;
  final Function(List<ImageModel> selectedImages) onSelectedImage;
  final List<ImageModel> selectedImages = [];

  @override
  Widget build(BuildContext context) {
    final MediaController mediaController = Get.find<MediaController>();
    bool loadedPreviousSelection = false;

    // Check if we're on a mobile device
    final isMobile = TDeviceUtils.isMobileScreen(context);

    // Determine image dimensions based on device type
    final imageWidth = isMobile ? 100.0 : 140.0;
    final imageHeight = isMobile ? 100.0 : 140.0;
    final itemHeight = isMobile ? 140.0 : 180.0;

    // Adjust spacing for mobile
    final wrapSpacing = isMobile ? TSizes.sm / 2 : TSizes.spaceBtwItems / 2;
    final horizontalPadding = isMobile ? TSizes.sm : TSizes.defaultSpace;

    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Media Images Header - Mobile-responsive layout
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Folder',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: TSizes.sm),
                    Row(
                      children: [
                        Expanded(
                          child: MediaFolderDropDown(
                            onChanged: (MediaCategory? newValue) {
                              if (newValue != null) {
                                mediaController.clearImages();
                                mediaController
                                    .getSelectedFolderImages(newValue);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    // Add extra spacing to prevent overlap with images
                    const SizedBox(height: TSizes.lg),
                    if (allowSelection) const SizedBox(height: TSizes.md),
                    if (allowSelection)
                      buildAddSelectedImageButton(context, isMobile: true),
                  ],
                )
              : Row(
                  children: [
                    // Folders DropDown
                    Text(
                      'Select Folder',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(width: TSizes.spaceBtwItems),
                    SizedBox(
                      width: 150,
                      child: MediaFolderDropDown(
                        onChanged: (MediaCategory? newValue) {
                          if (newValue != null) {
                            mediaController
                                .clearImages(); // Clear previous images
                            mediaController.getSelectedFolderImages(newValue);
                          }
                        },
                      ),
                    ),
                    if (allowSelection)
                      const SizedBox(
                        width: TSizes.spaceBtwItems,
                      ),
                    if (allowSelection) buildAddSelectedImageButton(context),

                    // "Remove All" button - only show on desktop/tablet
                    if (!TDeviceUtils.isMobileScreen(context))
                      Padding(
                        padding:
                            const EdgeInsets.only(left: TSizes.spaceBtwItems),
                        child: OutlinedButton(
                          onPressed: () {
                            // Your remove all logic here
                          },
                          child: const Text('Remove All'),
                        ),
                      ),
                  ],
                ),

          // Add clear divider on mobile to separate header from content with increased padding
          if (isMobile)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: TSizes.lg),
              child: Divider(),
            )
          else
            const SizedBox(height: TSizes.spaceBtwSections),

          // Show Media
          Obx(() {
            if (!loadedPreviousSelection &&
                alreadySelectedUrls != null &&
                alreadySelectedUrls!.isNotEmpty) {
              // Mark already selected images
              for (var image in mediaController.allImages) {
                if (alreadySelectedUrls!.contains(image.url)) {
                  image.isSelected.value = true;
                  selectedImages.add(image);
                }
              }
              loadedPreviousSelection = true;
            }

            if (mediaController.isLoading.value ||
                mediaController.allImages.isEmpty) {
              return Padding(
                padding: EdgeInsets.all(horizontalPadding),
                child: Column(
                  children: [
                    const TLoaderAnimation(),
                    Text(
                      'Select your Desired Folder',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              );
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Add a container with padding to ensure content is visibly separate
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: isMobile ? TSizes.md : 0,
                    horizontal: isMobile ? TSizes.xs : 0,
                  ),
                  margin:
                      isMobile ? const EdgeInsets.only(top: TSizes.lg) : null,
                  decoration: isMobile
                      ? BoxDecoration(
                          color: Colors.grey.withOpacity(0.05),
                          borderRadius:
                              BorderRadius.circular(TSizes.borderRadiusSm),
                        )
                      : null,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: wrapSpacing,
                    runSpacing: wrapSpacing,
                    children: mediaController.allImages.map((image) {
                      return GestureDetector(
                        onTap: () async {
                          buildShowDialogForImage(
                              context, mediaController, image);
                        },
                        child: SizedBox(
                          width: imageWidth,
                          height: itemHeight,
                          child: Column(
                            children: [
                              FutureBuilder<String?>(
                                future: mediaController.getImageFromBucket(
                                  image.folderType ?? '',
                                  image.filename ?? '',
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    return Stack(
                                      children: [
                                        TRoundedImage(
                                          imageurl: snapshot.data ?? '',
                                          width: imageWidth,
                                          height: imageHeight,
                                          padding:
                                              const EdgeInsets.all(TSizes.sm),
                                          backgroundColor:
                                              TColors.primaryBackground,
                                          isNetworkImage: true,
                                        ),
                                        // Only show checkbox when allowSelection is true
                                        if (allowSelection)
                                          Positioned(
                                            top: TSizes.sm,
                                            right: TSizes.sm,
                                            child: Obx(() => Checkbox(
                                                  value: image.isSelected.value,
                                                  onChanged: (selected) {
                                                    if (selected != null) {
                                                      image.isSelected.value =
                                                          selected;
                                                      if (selected) {
                                                        if (!allowMultipleSelection) {
                                                          for (var otherImage
                                                              in selectedImages) {
                                                            if (otherImage !=
                                                                image) {
                                                              otherImage
                                                                  .isSelected
                                                                  .value = false;
                                                            }
                                                          }
                                                          selectedImages
                                                              .clear();
                                                        }
                                                        if (!selectedImages
                                                            .contains(image)) {
                                                          selectedImages
                                                              .add(image);
                                                        }
                                                      } else {
                                                        selectedImages
                                                            .remove(image);
                                                      }
                                                    }
                                                  },
                                                )),
                                          ),
                                      ],
                                    );
                                  }
                                },
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: TSizes.xs),
                                  child: Text(
                                    image.filename ?? 'No Name Found',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          }),

          // Load More Button
          Obx(() {
            if (mediaController.isLoading.value ||
                mediaController.allImages.isEmpty) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: isMobile ? double.infinity : TSizes.buttonWidth,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        mediaController.getSelectedFolderImages(
                            mediaController.selectedPath.value);
                      },
                      label: const Text('Load More'),
                      icon: const Icon(
                        Icons.arrow_downward,
                        color: TColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Future<dynamic> buildShowDialogForImage(
      BuildContext context, MediaController mediaController, ImageModel image) {
    final isMobile = TDeviceUtils.isMobileScreen(context);
    final dialogWidth = isMobile ? 300.0 : 600.0;
    final dialogHeight = isMobile ? 250.0 : 400.0;

    return showDialog(
      context: context, // Make sure you have access to the context
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding:
              EdgeInsets.all(isMobile ? TSizes.sm : TSizes.defaultSpace),
          content: FutureBuilder<String?>(
            future: mediaController.getImageFromBucket(image.folderType ?? '',
                image.filename ?? ''), // Fetch the image URL
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show a loader while fetching the image
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TShimmerEffect(width: dialogWidth, height: dialogHeight)
                  ],
                );
              } else if (snapshot.hasError) {
                // Show an error message if fetching fails
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                // Handle case where no image is found
                return const Text('No image available');
              } else {
                // Display the fetched image
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TRoundedImage(
                        imageurl: snapshot.data!, // Use the fetched image URL
                        width: dialogWidth,
                        height: dialogHeight,
                        padding: const EdgeInsets.all(TSizes.sm),
                        backgroundColor: TColors.primaryBackground,
                        isNetworkImage: true,
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      // TextField with image URL and copy button
                      TextField(
                        readOnly: true, // Make the text field read-only
                        controller: TextEditingController(
                            text: image.url), // Set the image URL
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.copy), // Copy icon
                            onPressed: () {
                              // Copy the image URL to the clipboard
                              Clipboard.setData(ClipboardData(text: image.url));
                              TLoaders.successSnackBar(
                                  title: 'URL Copied!',
                                  message:
                                      'Tip: press Win+V to check Clipboard');
                            },
                          ),
                          border:
                              const OutlineInputBorder(), // Add a border to the text field
                        ),
                      ),
                      const SizedBox(
                        height: TSizes.spaceBtwItems,
                      ),
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            'Delete Image',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .apply(color: Colors.red),
                          ))
                    ],
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

  Future<Widget> _buildListWithCheckbox(
    ImageModel image,
  ) async {
    final MediaController mediaController = Get.find<MediaController>();

    return Stack(
      children: [
        TRoundedImage(
          imageurl: await mediaController.getImageFromBucket(
                  image.folderType ?? '', image.filename ?? '') ??
              '',
          width: 140,
          height: 140,
          padding: const EdgeInsets.all(TSizes.sm),
          backgroundColor: TColors.primaryBackground,
          isNetworkImage: true,
        ),
        // Only show checkbox when allowSelection is true
        if (allowSelection)
          Positioned(
            top: TSizes.md,
            right: TSizes.md,
            child: Obx(
              () => Checkbox(
                value: image.isSelected.value,
                onChanged: (selected) {
                  if (selected != null) {
                    image.isSelected.value = selected;
                    if (selected) {
                      if (!allowMultipleSelection) {
                        // If multiple selection is not allowed, uncheck others
                        for (var otherImage in selectedImages) {
                          if (otherImage != image) {
                            otherImage.isSelected.value = false;
                          }
                        }
                        selectedImages.clear();
                      }
                      selectedImages.add(image);
                    } else {
                      selectedImages.remove(image);
                    }
                  }
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget buildAddSelectedImageButton(BuildContext context,
      {bool isMobile = false}) {
    if (isMobile) {
      return Row(
        children: [
          // Close Button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              label: const Text('Close'),
              icon: const Icon(Iconsax.close_circle),
            ),
          ),
          const SizedBox(width: TSizes.sm),
          // Add Button
          Expanded(
            child: ElevatedButton.icon(
              label: const Text('Add'),
              icon: const Icon(Iconsax.image, color: TColors.white),
              onPressed: () {
                onSelectedImage(selectedImages);
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          // Close Button
          SizedBox(
            width: 120,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              label: const Text('Close'),
              icon: const Icon(Iconsax.close_circle),
            ),
          ),
          const SizedBox(width: TSizes.spaceBtwItems),
          // Add Button
          SizedBox(
            width: 120,
            child: ElevatedButton.icon(
              label: const Text('Add'),
              icon: const Icon(Iconsax.image, color: TColors.white),
              onPressed: () {
                // Pass the selected images back via the callback
                onSelectedImage(selectedImages);
                Navigator.of(context).pop(); // Close the bottom sheet
              },
            ),
          ),
        ],
      );
    }
  }
}
