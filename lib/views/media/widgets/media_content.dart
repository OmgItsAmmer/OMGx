import 'package:admin_dashboard_v3/Models/image/image_model.dart';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/controllers/media/media_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../common/widgets/images/t_rounded_image.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/constants/image_strings.dart';
import 'folder_dropdown.dart';

class MediaContent extends StatelessWidget {
  MediaContent(
      {super.key,
      required this.allowSelection,
      required this.allowMultipleSelection,
      this.alreadySelectedUrls,
       this.onSelectedImage});

  final bool allowSelection;
  final bool allowMultipleSelection;
  final List<String>? alreadySelectedUrls;
  final List<ImageModel> selectedImages = [];
  final List<ImageModel> images = [];
  final Function(List<ImageModel> selectedImages)? onSelectedImage;

  @override
  Widget build(BuildContext context) {
    final MediaController mediaController = Get.find<MediaController>();

    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Media Images Header
          Row(
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
              if (allowSelection) buildAddSelectedImageButton(),
            ],
          ),

          const SizedBox(
            height: TSizes.spaceBtwSections,
          ),

          //Show Media
           Wrap(
            alignment: WrapAlignment.start,
            spacing: TSizes.spaceBtwItems / 2,
            runSpacing: TSizes.spaceBtwItems / 2,
            children : images.map((image) => GestureDetector(
              onTap: () {},
              child: SizedBox(
                width: 140,
                height: 180,
                child: Column(
                  children: [
                    allowSelection ? _buildListWithCheckbox(image) : _buildListWithCheckbox(image),
                    Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
                    child: Text(image.filename,maxLines: 1,overflow: TextOverflow.ellipsis,),
                    ))
                  ],
                ),
              ),


            )).toList(),
          ),

          //Load more media buttn
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: TSizes.buttonWidth,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    label: const Text('Load More'),
                    icon: const Icon(
                      Icons.arrow_downward,
                      color: TColors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildAddSelectedImageButton() {
    return Row(
      children: [
        //Close button
        SizedBox(
          width: 120,
          child: OutlinedButton.icon(
            onPressed: () => Get.back(),
            label: const Text('Close'),
            icon: (const Icon(Iconsax.close_circle)),
          ),
        ),
        const SizedBox(
          width: TSizes.spaceBtwItems,
        ),
        SizedBox(
          width: 120,
          child: ElevatedButton.icon(
            label: const Text('Add'),
            icon: const Icon(Iconsax.image),
            onPressed: () {
              Get.back(result: selectedImages);
            },
          ),
        )
      ],
    );
  }

  Widget _buildListWithCheckbox(ImageModel image) {
    return Stack(
      children: [
        TRoundedImage(
          width: 140,
          height: 140,
          padding: const EdgeInsets.all(TSizes.sm),
          imageurl: image.url,
          backgroundColor: TColors.primaryBackground,
        ),
        Positioned(
            top: TSizes.md,
            right: TSizes.md,
            child: Obx(() => Checkbox(
                value: image.isSelected.value,
                onChanged: (selected) {
                  if (selected != null) {
                    image.isSelected.value = selected;
                    if (selected) {
                      if (!allowMultipleSelection) {
                        //if multiple not allowed then uncheck others
                        for (var otherImages in selectedImages) {
                          if (otherImages != image) {
                            otherImages.isSelected.value = false;
                          }
                        }
                        selectedImages.clear();
                      }
                      selectedImages.add(image);
                    } else {
                      selectedImages.remove(image);
                    }
                  }
                })))
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
