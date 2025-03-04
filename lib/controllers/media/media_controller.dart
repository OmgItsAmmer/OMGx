import 'dart:io';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:get/get.dart';

import '../../Models/image/image_model.dart';
import '../../repositories/media/media_repository.dart';
import '../../views/media/widgets/media_content.dart';
import '../../views/media/widgets/media_uploader.dart';

class MediaController extends GetxController {
  static MediaController get instance => Get.find();
  final MediaRepository mediaRepository = Get.put(MediaRepository());

  // Reactive variables
  var droppedFiles = <File>[].obs;
  RxList<ImageModel> allImages = <ImageModel>[].obs;
  Rx<ImageModel>? currentImage = ImageModel.empty().obs;
  RxList<ImageModel> selectedImages = <ImageModel>[].obs; // Checkboxed images
  final Rx<MediaCategory> selectedPath = MediaCategory.folders.obs;
  final RxBool showMediaUploaderSection = false.obs;
  final RxBool showImagesUploaderSection = false.obs;
  final RxBool isLoading = false.obs;

  // Pagination (lazy loading)
  int offset = 0;
  final int limit = 10;

  late DropzoneViewController dropzoneViewController;

  //==========================================================================
  // FILE DROPZONE AND SELECTION FUNCTIONS
  //==========================================================================

  void addDroppedFile(File file) {
    droppedFiles.add(file);
  }

  void clearDroppedFiles() {
    droppedFiles.clear();
  }

  /// Pick image from file explorer
  Future<void> pickImageFromExplorer() async {
    try {
      // Open file explorer and allow only image selection
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image, // Restrict to image files
        allowMultiple: false, // Allow only single file selection
      );

      // Check if a file was selected
      if (result != null) {
        // Get the file path
        PlatformFile file = result.files.first;

        // Pass the file to the mediaController
        addDroppedFile(File(file.path!));
      } else {
        // User canceled the picker
        print('No file selected.');
      }
    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap!', message: 'Didn\'t get the image from explorer');
    }
  }

  //==========================================================================
  // IMAGE SELECTION AND MEDIA CONTENT FUNCTIONS
  //==========================================================================

  /// Function to display a bottom sheet for image selection
  Future<List<ImageModel>> selectImagesFromMedia({
    List<String>? selectedUrls,
    bool allowSelection = true,
    bool multipleSelection = false,
  }) async {
    // List to store selected images
    final selectedImages = <ImageModel>[].obs;
    showImagesUploaderSection.value = true;

    // Show the bottom sheet
    await Get.bottomSheet<List<ImageModel>>(
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

  //==========================================================================
  // IMAGE FETCHING AND PAGINATION FUNCTIONS
  //==========================================================================

  /// Fetch images for the selected folder
  Future<void> getSelectedFolderImages(MediaCategory folder) async {
    if (isLoading.value) return;

    isLoading.value = true;
    selectedPath.value = folder;

    try {
      final images = await mediaRepository.fetchImagesTable(
        folder: folder.toString().split('.').last,
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

  /// Clear all images and reset pagination
  void clearImages() {
    allImages.clear();
    offset = 0; // Reset offset when changing folders
  }

  //==========================================================================
  // IMAGE UPLOAD FUNCTIONS
  //==========================================================================

  /// Upload images to the specified bucket
  Future<void> uploadImages(String bucketName) async {
    try {
      // Change to your table name
      List<Map<String, dynamic>> jsonData = [];

      // Loop through each dropped file
      for (var file in droppedFiles) {
        // Create ImageModel instance (filename is null initially)
        ImageModel imageModel = ImageModel(
          image_id: -1, // Not uploading
          url: file.path,
          filename: '',
          file: file,
          mediaCategory: bucketName,
        );

        // Convert model to JSON (without filename)
        jsonData.add(imageModel.toJson(isUpdate: true));
      }

      await mediaRepository.uploadImagesWithMetadata(
        bucketName: bucketName,
        jsonDataList: jsonData,
        files: droppedFiles,
      );

      // Show success message
      TLoader.successSnackBar(title: 'Success', message: 'All files uploaded successfully!');
    } catch (e) {
      // Show error message
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  //==========================================================================
  // IMAGE BUCKET AND ENTITY ID FUNCTIONS
  //==========================================================================

  /// Fetch image URL from the bucket
  Future<String?> getImageFromBucket(String bucketName, String fileName) async {
    try {
      final response = mediaRepository.fetchImageFromBucket(fileName, bucketName);
      return response;
    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
    return null;
  }

  /// Update entity ID for a specific image
  Future<void> updateEntityId(int entityId, int imageId) async {
    try {
      await mediaRepository.updateEntityIdRepo(entityId, imageId);
      TLoader.successSnackBar(title: 'Entity Id Added', message: 'Media Controller updateEntityId');
    } catch (e) {
      TLoader.errorSnackBar(title: e.toString());
      if (kDebugMode) {
        print(e);
      }
    }
  }
}