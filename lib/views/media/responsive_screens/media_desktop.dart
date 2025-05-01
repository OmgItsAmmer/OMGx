
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/views/media/widgets/media_uploader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../controllers/media/media_controller.dart';
import '../widgets/media_content.dart';

class MediaDesktopScreen extends StatelessWidget {
  const MediaDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MediaController mediaController = Get.find<MediaController>();

    return  Expanded(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(
              TSizes.defaultSpace,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Bread Crumbs
                    Text('Media',style: Theme.of(context).textTheme.headlineMedium,),
                    //Upload Button
                    SizedBox(
                      width: TSizes.buttonWidth*1.5,
                      child: ElevatedButton.icon(
                        onPressed: () {

                          mediaController.showImagesUploaderSection.value = !mediaController.showImagesUploaderSection.value;
                        },
                        label: const Text('Upload Images'),
                        icon: const Icon(Iconsax.cloud_add,color: TColors.white,),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: TSizes.spaceBtwSections,
                ),
                //Upload Area
                 MediaUploader(),
                const SizedBox(height: TSizes.spaceBtwSections,),
                //Media
                MediaContent(
                  allowMultipleSelection: false,
                  allowSelection: false,
                  onSelectedImage: (val){

                 //   mediaController.selectedImages.value = val; //do it but its useless

                  },

                ),
      
              ],
            ),
          ),
        ),
      ),
    );
  }
}
