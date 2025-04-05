import 'package:admin_dashboard_v3/Models/image/combined_image_model.dart';
import 'package:admin_dashboard_v3/Models/image/image_model.dart';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/loader_animation.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/common/widgets/shimmers/shimmer.dart';
import 'package:admin_dashboard_v3/controllers/media/media_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

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

    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Media Images Header
          Row(
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
                      mediaController.clearImages(); // Clear previous images
                      mediaController.getSelectedFolderImages(newValue);
                    }
                  },
                ),
              ),
              if (allowSelection) const SizedBox(width: TSizes.spaceBtwItems,),
              if (allowSelection) buildAddSelectedImageButton(),
            ],
          ),

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
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Column(
                  children: [
                    const TLoaderAnimation(),
                    Text(
                      'Select your Desired Folder',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              );
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: TSizes.spaceBtwItems / 2,
                  runSpacing: TSizes.spaceBtwItems / 2,
                  children: mediaController.allImages
                      .map((image) => GestureDetector(
                            onTap: () async {
                              // Open a dialog (pop-up)
                              buildShowDialogForImage(
                                  context, mediaController, image);
                            },
                            child: SizedBox(
                              width: 140,
                              height: 180,
                              child: Column(
                                children: [
                                  FutureBuilder<Widget>(
                                    future: _buildListWithCheckbox(image),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator(); // or any other loading widget
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        return snapshot.data!;
                                      }
                                    },
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: TSizes.sm),
                                      child: Text(
                                        image.filename ?? 'No Name Found',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
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
                    width: TSizes.buttonWidth,
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
    return showDialog(
      context: context, // Make sure you have access to the context
      builder: (BuildContext context) {
        return AlertDialog(
          content: FutureBuilder<String?>(
            future: mediaController.getImageFromBucket(
                image.folderType ?? '', image.filename ?? ''), // Fetch the image URL
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show a loader while fetching the image
                return const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [TShimmerEffect(width: 600, height: 400)],
                );
              } else if (snapshot.hasError) {
                // Show an error message if fetching fails
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                // Handle case where no image is found
                return const Text('No image available');
              } else {
                // Display the fetched image
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TRoundedImage(
                      imageurl: snapshot.data!, // Use the fetched image URL
                      width: 600,
                      height: 400,
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
                            TLoader.successSnackBar(title: 'URL Copied!',message: 'Tip: press Win+V to check Clipboard');
                          },
                        ),
                        border:
                            const OutlineInputBorder(), // Add a border to the text field
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems,),
                    TextButton(onPressed: (){


                    }, child:  Text('Delete Image',style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.red),))
                  ],
                );
              }
            },
          ),

        );
      },
    );
  }

  Future<Widget> _buildListWithCheckbox(ImageModel image,) async {
    final MediaController mediaController = Get.find<MediaController>();

    return Stack(
      children: [
        TRoundedImage(
          imageurl: await mediaController.getImageFromBucket(
                 image.folderType ?? '' , image.filename ?? '') ??
              '',
          width: 140,
          height: 140,
          padding: const EdgeInsets.all(TSizes.sm),
          backgroundColor: TColors.primaryBackground,
          isNetworkImage: true,
        ),
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

  Widget buildAddSelectedImageButton() {
    return Row(
      children: [
        // Close Button
        SizedBox(
          width: 120,
          child: OutlinedButton.icon(
            onPressed: () => Get.back(),
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
              Get.back(); // Close the bottom sheet
            },
          ),
        ),
      ],
    );
  }
}

// TRoundedImage(
// imageurl: TImages.productImage1,
// width: 90,
// height: 90,
// padding: EdgeInsets.all(TSizes.sm),
// backgroundColor: TColors.primaryBackground,
// ),
