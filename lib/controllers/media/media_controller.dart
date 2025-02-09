import 'dart:io';

import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:get/get.dart';

import '../../Models/image/image_model.dart';
import '../../repositories/media/media_repository.dart';
import '../../views/media/widgets/media_content.dart';
import '../../views/media/widgets/media_uploader.dart';
import 'package:path/path.dart' as p;

class MediaController extends GetxController {
  static MediaController get instance => Get.find();
  final MediaRepository mediaRepository = Get.put(MediaRepository());

  var droppedFiles = <File>[].obs;
  RxList<ImageModel> allImages = <ImageModel>[].obs;
  Rx<ImageModel>? currentImage = ImageModel.empty().obs;

  late DropzoneViewController dropzoneViewController;
  final Rx<MediaCategory> selectedPath = MediaCategory.folders.obs;
  final RxBool showMediaUploaderSection = false.obs;
  final RxBool showImagesUploaderSection = false.obs;
  final RxBool isLoading = false.obs;

  //chcekboxed images
  RxList<ImageModel> selectedImages = <ImageModel>[].obs;

  //pagination(lazy loading)
  int offset = 0;
  final int limit = 10;

  void addDroppedFile(File file) {
    droppedFiles.add(file);
  }

  void clearDroppedFiles() {
    droppedFiles.clear();
  }

  // Function to display a bottom sheet for image selection
  Future<List<ImageModel>> selectImagesFromMedia({
    List<String>? selectedUrls,
    bool allowSelection = true,
    bool multipleSelection = false,
  }) async {
    // List to store selected images
    final selectedImages = <ImageModel>[].obs;

    // Show the bottom sheet
    final result = await Get.bottomSheet<List<ImageModel>>(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      ClipRRect(
        borderRadius: BorderRadius.zero, // Remove rounded corners
        child: FractionallySizedBox(
          heightFactor: 1.0,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  MediaUploader(),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  const Text(
                    'Select Images',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  MediaContent(
                    allowSelection: allowSelection,
                    alreadySelectedUrls: selectedUrls,
                    allowMultipleSelection: multipleSelection,
                    onSelectedImage: (List<ImageModel> images) {
                      // Update the selectedImages list
                      selectedImages.value = images;
                    },
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    print(selectedImages);
    // Return the selected images
    return selectedImages;
  }



  Future<void> getSelectedFolderImages(MediaCategory folder) async {
    if (isLoading.value) return;

    isLoading.value = true;
    selectedPath.value = folder;

    try {
      final images = await mediaRepository.fetchImagesTable(
        folder: folder
            .toString()
            .split('.')
            .last,
        offset: offset,
        limit: limit,
      );

      if (images.isNotEmpty) {
        allImages.assignAll(images);
        offset += limit; // Increment offset for the next batch
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching images: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  void clearImages() {
    allImages.clear();
    offset = 0; // Reset offset when changing folders
  }

  Future<String?> getImageFromBucket(String bucketName, String fileName) async {
    try {
      // print(bucketName);
      // print(fileName);
      final response = mediaRepository.fetchImageFromBucket(
          fileName, bucketName);
      return response;
    }
    catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
    return null;
  }


  ///////////////////////UPLOAD SECTION//////////////////////////////

  Future<void> uploadImages(String bucketName) async {
    try {
      // Change to your table name
      List<Map<String, dynamic>> jsonData = [];
      // Loop through each dropped file
      for (var file in droppedFiles) {


        // Create ImageModel instance (filename is null initially)
        ImageModel imageModel = ImageModel(
          image_id: -1, //not uploading
          url: file.path,
          filename: '',
          file: file,
          mediaCategory: bucketName,
        );

        // Convert model to JSON (without filename)

        jsonData.add(imageModel.toJson(isUpdate: true));
       // jsonData['filename'] = null;


        // print("✅ File uploaded successfully: $newFileName");
      }
      await mediaRepository.uploadImagesWithMetadata(bucketName: bucketName, jsonDataList: jsonData, files: droppedFiles);

      // Show success message
      TLoader.successSnackBar(
          title: 'Success', message: 'All files uploaded successfully!');
    } catch (e) {
      // Show error message
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}