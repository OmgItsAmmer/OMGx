import 'dart:io';
import 'package:admin_dashboard_v3/Models/image/combined_image_model.dart';
import 'package:admin_dashboard_v3/Models/image/image_entity_model.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uuid/uuid.dart';

import '../../Models/image/image_model.dart';
import '../../repositories/media/media_repository.dart';
import '../../views/media/widgets/media_content.dart';
import '../../views/media/widgets/media_uploader.dart';
import 'package:path/path.dart' as p;

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
  final RxBool isFetching = false.obs;
  Rx<ImageModel?> displayImage = Rx<ImageModel?>(null);

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
  // IMAGE SELECTION AND ASSIGNING/REASSIGNING FUNCTIONS
  //==========================================================================

  /// Function to display a bottom sheet for image selection
  Future<void> selectImagesFromMedia({
    List<String>? selectedUrls,
    bool allowSelection = true,
    bool multipleSelection = false,
  }) async {
    // List to store selected images
   // final selectedImages = <ImageModel>[].obs;
    selectedImages.clear();
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
                      print(selectedImages.length);

                      displayImage.value = selectedImages.first;
                     // displayImage.refresh();
                      print(displayImage.value?.url);
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

  }

//Call when stuff needs to be confirmed
  Future<void> imageAssigner(int entityId, String entityType, bool isFeatured) async {
    try {
      if (isFeatured) {
        // Make sure only one image is selected
        if (selectedImages.length > 1) {
          TLoader.warningSnackBar(title: 'Warning', message: 'Please select exactly one image for Main Image.');
          return;
        }

        final isAlreadyAssigned = await mediaRepository.checkAssigned(entityId, entityType);

        if (isAlreadyAssigned == true) {
          // Replace the existing featured image
          await mediaRepository.reAssignNewImage(
            entityId,
            entityType,
            selectedImages.first.imageId,
          );
        } else {
          // Assign the image for the first time
          final imageEntityModel = ImageEntityModel(
            imageEntityId: -1,
            imageId: selectedImages.first.imageId,
            isFeatured: true,
            entityId: entityId,
            entityCategory: entityType,
          );
          final json = imageEntityModel.toJson(isUpdate: true);
          await mediaRepository.assignNewImage(json);
        }
      } else {
        // Assign multiple non-featured images
        for (var item in selectedImages) {
          final imageEntityModel = ImageEntityModel(
            imageEntityId: -1,
            imageId: item.imageId,
            isFeatured: false,
            entityId: entityId,
            entityCategory: entityType,
          );
          final json = imageEntityModel.toJson(isUpdate: true);
          await mediaRepository.assignNewImage(json);
        }
      }
    } catch (e) {
      TLoader.errorSnackBar(title: 'Image Assigner Issue', message: e.toString());
    } finally {
      selectedImages.clear();
    }
  }



  //==========================================================================
  // IMAGE INSERTION FUNCTIONS
  //==========================================================================



  Future<void> insertImagesInTableAndBucket(String bucketName) async {
    try {
      List<Map<String, dynamic>> jsonData = [];
      var uuid = const Uuid();

      for (var file in droppedFiles) {
        // Get the file extension (e.g., .jpg, .png)
        String ext = p.extension(file.path);
        // Generate a unique filename with extension
        String uniqueFilename = '${uuid.v4()}$ext';

        ImageModel imageModel = ImageModel(
          imageId: -1,
          url: file.path,
          filename: uniqueFilename, // ✅ assign unique filename here
          file: file,
          folderType: bucketName,
        );

        jsonData.add(imageModel.toJson(isUpdate: true));
      }

      await mediaRepository.insertImagesTableAndBucket(
        bucketName: bucketName,
        jsonDataList: jsonData,
        files: droppedFiles,
      );

      TLoader.successSnackBar(title: 'Success', message: 'All files uploaded successfully!');
      droppedFiles.clear();
    } catch (e) {
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
  Future<void> updateEntityId(int entityId, int imageId, String mediaCategory) async {
    try {
      // // Step 1: Call the repository function to update the database
      // await mediaRepository.updateEntityIdRepo(entityId, imageId, mediaCategory);
      //
      // // Step 2: Update the local allImages array
      // // Find the previous image with the same entityId and mediaCategory
      // final previousImage = allImages.firstWhere(
      //       (image) => image.entityId == entityId && image.mediaCategory == mediaCategory,
      //   orElse: () => ImageModel.empty(), // Return null if no matching image is found
      // );
      //
      // if (previousImage != ImageModel.empty()) {
      //   // Set the previous image's entityId to null
      //   previousImage.entityId = null;
      // }
      //
      // // Find the new image by imageId and update its entityId
      // final newImage = allImages.firstWhere(
      //       (image) => image.imageId == imageId,
      //   orElse: () => ImageModel.empty(), // Return null if no matching image is found
      // );
      //
      // if (newImage != ImageModel.empty()) {
      //   newImage.entityId = entityId;
      // }


      if (kDebugMode) {
        print('Entity ID updated successfully for image ID: $imageId');
      }
    } catch (e) {
      // Handle errors
      if (kDebugMode) {
        TLoader.errorSnackBar(title: 'Error updating entity ID', message: e.toString());
        print('Error updating entity ID: $e');
      }
      rethrow; // Rethrow the error if needed
    }
  }

  //==========================================================================
  // IMAGE FETCHING AND PAGINATION FUNCTIONS
  //==========================================================================

  /// Fetch images for the selected folder
  Future<void> getSelectedFolderImages(MediaCategory folder) async {
    // if (isLoading.value) return;

    isLoading.value = true;
    selectedPath.value = folder;

    try {
      final images = await mediaRepository.fetchFolderImagesFromImagesTable(
        folderType: folder.toString().split('.').last,
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


  Future<String?> fetchMainImage(int entityId , String entityType) async {
    try {
      isFetching.value = true;
     final ImageModel image = await mediaRepository.getMainImage(entityId,entityType);
     if(image.filename == null || image.filename!.isEmpty){
       TLoader.warningSnackBar(title: 'No Image Found!',message: 'There is No image in table');
       return null;
     }
     else{
       String imageUrl =   await mediaRepository.fetchImageFromBucket(image.filename ?? '', entityType) ?? '';
        return imageUrl;
     }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error fetching Main Picture: $e');
        print('Stack trace: $stackTrace'); // <-- this is key
        TLoader.errorSnackBar(title:  ' Controller Error fetching Main Picture', message: e.toString());
      }
      return null;
    }
    finally {
      isFetching.value = false;

    }
  }

  //==========================================================================
  // EXTRA FUNCTIONS(SIdeBAR)
  //==========================================================================
  var cachedSidebarImage = Rxn<String>();   // ✅ New cache for Sidebar

  Future<String?> fetchAndCacheSidebarImage(int shopId, String category) async {
    if (cachedSidebarImage.value != null) return cachedSidebarImage.value;

    final url = await fetchMainImage(shopId, category);
    cachedSidebarImage.value = url;
    return url;
  }

  void clearSidebarImageCache() {
    cachedSidebarImage.value = null;
  }

  var cachedProfileImage = Rxn<String>();   // ✅ New cache for Sidebar

  Future<String?> fetchAndCacheProfileImage(int shopId, String category) async {
    if (cachedProfileImage.value != null) return cachedProfileImage.value;

    final url = await fetchMainImage(shopId, category);
    cachedProfileImage.value = url;
    return url;
  }

  void clearProfileImageCache() {
    cachedProfileImage.value = null;
  }

}