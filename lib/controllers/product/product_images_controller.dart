import 'package:admin_dashboard_v3/Models/image/image_model.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/controllers/media/media_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../repositories/media/media_repository.dart';
import '../../utils/constants/enums.dart';

class ProductImagesController extends GetxController {
  static ProductImagesController get instance => Get.find();
  final MediaRepository mediaRepository = Get.put(MediaRepository());


  // Rx Observables for the selected thumbnail image
  Rx<String?> selectedThumbnailImageUrl = Rx<String?>(null);
  Rx<ImageModel?> selectedImage = Rx<ImageModel?>(null);

  // Lists to store additional product images
  final RxList<String> additionalProductImagesUrls = <String>[].obs;

  /// Pick Thumbnail Image from Media
  void selectThumbnailImage() async {
    try{
      final mediaController = Get.put(MediaController());
      List<ImageModel>? selectedImages =
      await mediaController.selectImagesFromMedia();

      if (selectedImages.isNotEmpty) {
        //Set the selected image to the main image or perform any other action
        selectedImage.value = selectedImages.first;

        selectedThumbnailImageUrl.value = selectedImage.value?.filename;
      }
      print(selectedThumbnailImageUrl.value);

    }
    catch(e){
      TLoader.errorSnackBar(title: 'Oh Snap!',message: e.toString());
    }

  }

  /// Pick Multiple Images from Media
  void selectMultipleProductImages() async {
    try{
      final mediaController = Get.put(MediaController());
      List<ImageModel>? selectedImages =
      await mediaController.selectImagesFromMedia(
          multipleSelection: true, selectedUrls: additionalProductImagesUrls);

      if (selectedImages.isNotEmpty) {
        additionalProductImagesUrls.assignAll(selectedImages.map((e) => e.url));
      }

    }
    catch(e){
      TLoader.errorSnackBar(title: 'Oh Snap!',message: e.toString());
    }

  }

  /// Function to remove Product image
  Future<void> removeImage(int index) async {
    additionalProductImagesUrls.removeAt(index);
  }

  Future<void> getSpecificImage(MediaCategory folder, int entityId) async {

    try {
      final image = await mediaRepository.fetchSpecificImageRow(
          folder: folder
              .toString()
              .split('.')
              .last,
          entityId: entityId
      );

      selectedImage.value = image;

    } catch (e) {
      if (kDebugMode) {
        print('Error fetching images: $e');
      }
    }
  }

void setDesiredImage(MediaCategory mediaCategory,int imageId) async {
  try{
    final mediaController = Get.put(MediaController());


    await mediaController.getSelectedFolderImages(mediaCategory);

    print(imageId);
   // print(mediaController.allImages[1]);

    if (mediaController.allImages.isNotEmpty && imageId != -1) {
      final filteredValue = mediaController.allImages.firstWhere(
            (image) => image.entity_id == imageId,
        orElse: () => ImageModel.empty(),
      );

      selectedImage.value = filteredValue;
      print(selectedImage.value?.image_id);

      selectedThumbnailImageUrl.value = filteredValue.filename;
    }

    if (kDebugMode) {
      print(selectedThumbnailImageUrl.value);
    }

  }
  catch(e){
    TLoader.errorSnackBar(title: 'Oh Snap!',message: e.toString());
  }

}


}



