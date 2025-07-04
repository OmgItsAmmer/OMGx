import 'dart:io';
import 'package:ecommerce_dashboard/Models/image/image_entity_model.dart';
import 'package:ecommerce_dashboard/common/widgets/loaders/tloaders.dart';
import 'package:ecommerce_dashboard/utils/constants/enums.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../Models/image/image_model.dart';
import '../../repositories/media/media_repository.dart';
import '../../views/media/widgets/media_content.dart';
import '../../views/media/widgets/media_uploader.dart';
import 'package:path/path.dart' as p;

class MediaOwnerImage {
  int ownerId;
  String ownerType;
  ImageModel image;

  MediaOwnerImage({
    required this.ownerId,
    required this.ownerType,
    required this.image,
  });
}

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

  final RxnString displayImageOwner = RxnString();
  Rx<ImageModel?> displayImage = Rx<ImageModel?>(null);

  // Pagination (lazy loading)
  int offset = 0;
  final int limit = 10;

  late DropzoneViewController dropzoneViewController;

  // For multiple images on the same screen (e.g., guarantors)
  RxList<MediaOwnerImage> multipleDisplayImages = <MediaOwnerImage>[].obs;

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
      TLoaders.errorSnackBar(
          title: 'Oh Snap!', message: 'Didn\'t get the image from explorer');
    }
  }

  //==========================================================================
  // IMAGE SELECTION AND ASSIGNING/REASSIGNING FUNCTIONS
  //==========================================================================

  /// Function to display a bottom sheet for image selection for multiple owner scenarios
  Future<void> selectImagesForOwner({
    required int ownerId,
    required String ownerType,
    List<String>? selectedUrls,
    bool allowSelection = true,
    bool multipleSelection = false,
  }) async {
    // Store current state to restore later
    final previousSelectedImages = List<ImageModel>.from(selectedImages);

    // Clear selected images for this operation
    selectedImages.clear();
    showImagesUploaderSection.value = true;

    // Show the bottom sheet
    await Get.bottomSheet<List<ImageModel>>(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      ClipRRect(
        borderRadius: BorderRadius.zero,
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
                      selectedImages.value = images;
                      if (images.isNotEmpty) {
                        // Find existing item with the same owner ID and type
                        int existingIndex = multipleDisplayImages.indexWhere(
                            (element) =>
                                element.ownerId == ownerId &&
                                element.ownerType == ownerType);

                        // Update or add the new image for this owner
                        if (existingIndex >= 0) {
                          multipleDisplayImages[existingIndex] =
                              MediaOwnerImage(
                            ownerId: ownerId,
                            ownerType: ownerType,
                            image: images.first,
                          );
                        } else {
                          multipleDisplayImages.add(MediaOwnerImage(
                            ownerId: ownerId,
                            ownerType: ownerType,
                            image: images.first,
                          ));
                        }
                      }
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

  /// Function to display a bottom sheet for image selection (Original method for backwards compatibility)
  Future<void> selectImagesFromMedia({
    List<String>? selectedUrls,
    bool allowSelection = true,
    bool multipleSelection = false,
  }) async {
    // List to store selected images
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
                      displayImage.value = selectedImages.first;
                      displayImageOwner.value = displayImage.value?.folderType;
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

  //Call when stuff needs to be confirmed (Original method for backwards compatibility)
  Future<void> imageAssigner(
      int entityId, String entityType, bool isFeatured) async {
    try {
      if (selectedImages.isEmpty) {
        return;
      }

      if (isFeatured) {
        // Make sure only one image is selected
        if (selectedImages.length > 1) {
          TLoaders.warningSnackBar(
              title: 'Warning',
              message: 'Please select exactly one image for Main Image.');
          return;
        }

        final isAlreadyAssigned =
            await mediaRepository.checkAssigned(entityId, entityType);

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
      TLoaders.errorSnackBar(
          title: 'Image Assigner Issue', message: e.toString());
    } finally {
      for (var image in allImages) {
        image.isSelected.value = false; // ✅ Reset checkbox state
      }
      selectedImages.clear();
      displayImage.value = null;
    }
  }

  // Get image for a specific owner
  ImageModel? getImageForOwner(int ownerId, String ownerType) {
    final ownerImage = multipleDisplayImages.firstWhereOrNull((element) =>
        element.ownerId == ownerId && element.ownerType == ownerType);
    return ownerImage?.image;
  }

  // Method to assign images for multiple owners like guarantors
  Future<void> assignImagesForMultipleOwners(
      List<MediaOwnerImage> ownersWithImages) async {
    try {
      for (var ownerImage in ownersWithImages) {
        final isAlreadyAssigned = await mediaRepository.checkAssigned(
            ownerImage.ownerId, ownerImage.ownerType);

        if (isAlreadyAssigned == true) {
          // Replace the existing featured image
          await mediaRepository.reAssignNewImage(
            ownerImage.ownerId,
            ownerImage.ownerType,
            ownerImage.image.imageId,
          );
        } else {
          // Assign the image for the first time
          final imageEntityModel = ImageEntityModel(
            imageEntityId: -1,
            imageId: ownerImage.image.imageId,
            isFeatured: true,
            entityId: ownerImage.ownerId,
            entityCategory: ownerImage.ownerType,
          );
          final json = imageEntityModel.toJson(isUpdate: true);
          await mediaRepository.assignNewImage(json);
        }
      }
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Image Assigner Issue', message: e.toString());
    }
  }

  // Fetch image URL for a specific owner
  Future<String?> fetchImageForOwner(int ownerId, String ownerType) async {
    try {
      isFetching.value = true;
      final ImageModel image =
          await mediaRepository.getMainImage(ownerId, ownerType);
      if (image.filename == null || image.filename!.isEmpty) {
        return null;
      } else {
        String imageUrl = await mediaRepository.fetchImageFromBucket(
                image.filename ?? '', ownerType) ??
            '';

        // Update the local cache for this owner
        int existingIndex = multipleDisplayImages.indexWhere((element) =>
            element.ownerId == ownerId && element.ownerType == ownerType);

        if (existingIndex >= 0) {
          multipleDisplayImages[existingIndex] = MediaOwnerImage(
            ownerId: ownerId,
            ownerType: ownerType,
            image: image,
          );
        } else {
          multipleDisplayImages.add(MediaOwnerImage(
            ownerId: ownerId,
            ownerType: ownerType,
            image: image,
          ));
        }

        return imageUrl;
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error fetching image for owner $ownerId ($ownerType): $e');
        print('Stack trace: $stackTrace');
      }
      return null;
    } finally {
      isFetching.value = false;
    }
  }

  // Clear images for specific owners
  void clearOwnerImages(List<int> ownerIds, String ownerType) {
    multipleDisplayImages.removeWhere((element) =>
        ownerIds.contains(element.ownerId) && element.ownerType == ownerType);
  }

  // Update owner IDs in the multipleDisplayImages list
  void updateOwnerIds(int oldOwnerId, int newOwnerId, String ownerType) {
    final index = multipleDisplayImages.indexWhere((element) =>
        element.ownerId == oldOwnerId && element.ownerType == ownerType);

    if (index >= 0) {
      final image = multipleDisplayImages[index].image;
      // Remove the old entry
      multipleDisplayImages.removeAt(index);
      // Add with the new ID
      multipleDisplayImages.add(MediaOwnerImage(
        ownerId: newOwnerId,
        ownerType: ownerType,
        image: image,
      ));
    }
  }

  //==========================================================================
  // IMAGE INSERTION FUNCTIONS
  //==========================================================================

  RxBool isInserting = false.obs;
  Future<void> insertImagesInTableAndBucket(String bucketName) async {
    try {
      isInserting.value = true;
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

      TLoaders.successSnackBar(
          title: 'Success', message: 'All files uploaded successfully!');
      droppedFiles.clear();

      // Reset selectedPath back to default after successful upload
      selectedPath.value = MediaCategory.folders;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      isInserting.value = false;
    }
  }

  //==========================================================================
  // IMAGE BUCKET AND ENTITY ID FUNCTIONS
  //==========================================================================

  /// Fetch image URL from the bucket
  Future<String?> getImageFromBucket(String bucketName, String fileName) async {
    try {
      final response =
          mediaRepository.fetchImageFromBucket(fileName, bucketName);
      return response;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
    return null;
  }

  /// Update entity ID for a specific image
  Future<void> updateEntityId(
      int entityId, int imageId, String mediaCategory) async {
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
        TLoaders.errorSnackBar(
            title: 'Error updating entity ID', message: e.toString());
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

  Future<String?> fetchMainImage(int entityId, String entityType) async {
    try {
      isFetching.value = true;
      final ImageModel image =
          await mediaRepository.getMainImage(entityId, entityType);
      if (image.filename == null || image.filename!.isEmpty) {
        //  TLoader.warningSnackBar(title: 'No Image Found!',message: 'There is No image in table');
        return null;
      } else {
        String imageUrl = await mediaRepository.fetchImageFromBucket(
                image.filename ?? '', entityType) ??
            '';
        return imageUrl;
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error fetching Main Picture: $e');
        print('Stack trace: $stackTrace'); // <-- this is key
        TLoaders.errorSnackBar(
            title: ' Controller Error fetching Main Picture',
            message: e.toString());
      }
      return null;
    } finally {
      isFetching.value = false;
    }
  }

  //==========================================================================
  // EXTRA FUNCTIONS(SIdeBAR)
  //==========================================================================
  var cachedSidebarImage = Rxn<String>(); // ✅ New cache for Sidebar

  Future<String?> fetchAndCacheSidebarImage(int shopId, String category) async {
    if (cachedSidebarImage.value != null) return cachedSidebarImage.value;

    final url = await fetchMainImage(shopId, category);
    cachedSidebarImage.value = url;
    return url;
  }

  void clearSidebarImageCache() {
    cachedSidebarImage.value = null;
  }

  var cachedProfileImage = Rxn<String>(); // ✅ New cache for Sidebar
  final userIdTracker = RxInt(-1); // Track current user ID for profile image

  Future<String?> fetchAndCacheProfileImage(int userId, String category) async {
    // If cached profile exists and is for the same user, return it
    if (cachedProfileImage.value != null && userIdTracker.value == userId) {
      return cachedProfileImage.value;
    }

    // If user changed or no cache exists, fetch the image
    userIdTracker.value = userId;
    final url = await fetchMainImage(userId, category);
    cachedProfileImage.value = url;
    return url;
  }

  void clearProfileImageCache() {
    cachedProfileImage.value = null;
    userIdTracker.value = -1;
  }

  // Call this when user changes (in login controller or when changing users)
  void refreshUserImage() {
    clearProfileImageCache();
  }
}
