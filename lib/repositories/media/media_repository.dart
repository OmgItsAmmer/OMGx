import 'dart:io';

import 'package:admin_dashboard_v3/Models/image/combined_image_model.dart';
import 'package:admin_dashboard_v3/Models/image/image_entity_model.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../Models/image/image_model.dart';
import '../../main.dart';


class MediaRepository extends GetxController {
  static MediaRepository get instance => Get.find();

  Future<List<ImageModel>> fetchFolderImagesFromImagesTable({
    required String folderType,
    required int offset,
    required int limit,
  }) async {
    try {
      // Step 1: Fetch image-entity table data
      // final List<Map<String, dynamic>> entityJsonList = await supabase
      //     .from("image_entity")
      //     .select()
      //     .eq('entity_category', folderType)
      //     .range(offset, offset + limit - 1);

      // // Step 2: Extract image IDs
      // final List<int> imageIds = entityJsonList
      //     .map((json) => json['image_id'])
      //     .whereType<int>()
      //     .toList();
      //
      // if (imageIds.isEmpty) return [];

      // Step 3: Fetch corresponding images using image IDs
      final List<Map<String, dynamic>> imageJsonList = await supabase
          .from('images')
          .select()
          .eq('folderType', folderType);

      final List<ImageModel> imageModels = imageJsonList
          .map((json) => ImageModel.fromJson(json))
          .toList();




      // // Step 4: Build a map for faster lookup
      // final Map<int, Map<String, dynamic>> imageJsonMap = {
      //   for (var img in imageJsonList) img['image_id'] as int: img
      // };



      // Step 5: Combine using factory method
      // final List<CombinedImageEntityModel> combinedList = entityJsonList.map((entityJson) {
      //   final int imageId = entityJson['image_id'];
      //   final imageJson = imageJsonMap[imageId];
      //
      //   if (imageJson != null) {
      //     return CombinedImageEntityModel.fromJson(
      //       imageJson: imageJson,
      //       entityJson: entityJson,
      //     );
      //   } else {
      //     throw Exception("Image not found for image_id: $imageId");
      //   }
      // }).toList();

      return imageModels;
    } catch (e) {
      TLoader.errorSnackBar(
        title: 'fetchFolderImagesFromImagesTable',
        message: e.toString(),
      );
      return [];
    }
  }


  Future<ImageModel> fetchSpecificImageRow({
    required String folder,
    required int entityId,
  }) async {
    try {
      List<Map<String, dynamic>>? data;
      data = await supabase
          .from("images") // Replace with your table name
          .select()
          .eq('mediacategory', folder)
          .eq('entity_id', entityId); // Pagination

      final imageList = data.map((item) {
        return ImageModel.fromJson(item);
      }).toList();

      return imageList[0];
    } catch (e) {
      TLoader.errorSnackBar(title: 'Media Repo', message: e.toString());
      return ImageModel.empty();
    }
  }

  Future<String?>   fetchImageFromBucket(String filePath,
      String bucketName) async {
    try {
      // return await supabase.storage.from(bucketName).download(filePath);
      return supabase.storage.from(bucketName).getPublicUrl(filePath);
      //return response; // response is of type Uint8List
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching image: $e");
      }
      return null; // Return null in case of an error
    }
  }

///////////////////////INSERTION SECTION//////////////////////////////

  Future<void> insertImagesTableAndBucket({
    required String bucketName,
    required List<Map<String, dynamic>> jsonDataList,
    required List<File> files,
  }) async {
    if (files.length != jsonDataList.length) {
      if (kDebugMode) {
        print("❌ Mismatch: files and metadata count must match.");
      }
      return;
    }

    for (int i = 0; i < files.length; i++) {
      final file = files[i];
      final jsonData = jsonDataList[i];

      try {
        final filename = jsonData['filename'];
        if (filename == null || filename.isEmpty) {
          throw Exception("Filename not provided in metadata.");
        }

        // ✅ Step 1: Insert metadata into DB
        await supabase.from('images').insert(jsonData);


        // final user = supabase.auth.currentUser;
        // if (user == null) {
        //   throw Exception("User not authenticated.");
        // }

        insertFileToBucket(
            bucketName: bucketName, file: file, filename: filename);
      } catch (e) {
        if (kDebugMode) print("❌ Upload error: $e");
        TLoader.errorSnackBar(
            title: 'Image Table Upload Failed', message: e.toString());
      }
    }
  }

  Future<void> insertFileToBucket({
    required String bucketName,
    required String filename,
    required File file,
  }) async {
    try {
      await supabase.storage.from(bucketName).upload(filename, file);
    } catch (e) {
      if (kDebugMode) {
        TLoader.errorSnackBar(
            title: 'Bucket Upload Failed', message: e.toString());

        print("❌ Bucket upload failed: $e");
      }
      throw Exception("Upload to bucket failed: $e");
    }
  }


  Future<void> updateEntityIdRepo(int entityId, int imageId,
      String mediaCategory) async {
    try {
      // Step 1: Find the previous image associated with the same entityId
      final previousImageResponse = await supabase
          .from('images')
          .select('image_id')
          .eq('entity_id', entityId)
          .eq('mediacategory', mediaCategory)
          .maybeSingle(); // Use maybeSingle to handle cases where no row is found

      if (previousImageResponse != null) {
        // Step 2: Set the previous image's entity_id to null
        await supabase
            .from('images')
            .update({'entity_id': null})
            .eq('image_id', previousImageResponse['image_id']);
      }

      // Step 3: Update the new image with the entityId
      await supabase
          .from('images')
          .update({'entity_id': entityId})
          .eq('image_id', imageId);

      if (kDebugMode) {
        print('Entity ID updated successfully for image ID: $imageId');
      }
    } catch (e) {
      // Handle errors
      TLoader.errorSnackBar(
          title: 'Error updating entity ID', message: e.toString());
      if (kDebugMode) {
        print('Error updating entity ID: $e');
      }
      rethrow; // Rethrow the error if needed
    }
  }

  Future<bool?> checkAssigned(int entityId, String entityType) async {
    try {
      final response = await supabase
          .from('image_entity')
          .select('image_entity_id')
          .eq('entity_id', entityId)
          .eq('entity_category', entityType)
          .eq('isFeatured', true)
          .maybeSingle();

      return response != null;
    } catch (e) {
      if (kDebugMode) {
        TLoader.errorSnackBar(
            title: 'Check Assigned Error', message: e.toString());
        print("❌ checkAssigned failed: $e");
      }
      return null; // null means failure to determine
    }
  }

  Future<void> reAssignNewImage(int entityId, String entityType,
      int imageId) async {
    try {
      try {
        final existingRow = await supabase
            .from('image_entity')
            .select('image_entity_id')
            .eq('entity_id', entityId)
            .eq('entity_category', entityType)
            .maybeSingle();

        if (existingRow != null && existingRow['image_entity_id'] != null) {
          final imageEntityId = existingRow['image_entity_id'];

          await supabase
              .from('image_entity')
              .update({'image_id': imageId})
              .eq('image_entity_id', imageEntityId);

          if (kDebugMode) {
            print("✅ Image updated for entity: $entityId");
          }
        } else {
          if (kDebugMode) {
            print("⚠️ No existing row to update for entity: $entityId");
          }
        }
      } catch (e) {
        if (kDebugMode) {
          TLoader.errorSnackBar(title: 'Update Error', message: e.toString());
          print("❌ updateImageAssignment failed: $e");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        TLoader.errorSnackBar(
            title: 'reAssignNewImage Error', message: e.toString());
        print("❌ reAssignNewImage failed: $e");
      }
    }
  }

  Future<void> assignNewImage(Map<String, dynamic> json) async {
    try {
      await supabase.from('image_entity').insert(json);
    } catch (e) {
      if (kDebugMode) {
        TLoader.errorSnackBar(title: 'Insert Error', message: e.toString());
        print("❌ assignNewImage failed: $e");
      }
    }
  }

  Future<ImageModel> getMainImage(int entityId, String entityType) async {
    try {
      final imageId = await fetchMainImageFromTable(entityId, entityType);

     final model =  await fetchImageFromImageTable(imageId);

    return model;
    } catch (e) {
      if (kDebugMode) {
        print("❌ fetchMainImageFromTable failed: $e");
      }
      // If an error occurs, return null
      return ImageModel.empty();
    }
  }

  Future<int> fetchMainImageFromTable(int entityId, String entityType) async {
    try {
      // Fetch the image_id where isFeatured is true
      final response = await supabase
          .from('image_entity')
          .select('image_id')
          .eq('entity_id', entityId)
          .eq('entity_category', entityType)
          .eq('isFeatured', true)
          .single();

      final imageId = ImageEntityModel
          .fromJson(response)
          .imageId;


      return imageId ?? -1;
    } catch (e) {
      if (kDebugMode) {
        TLoader.errorSnackBar(
            title: 'Main Image Table Fetching Error', message: e.toString());
        print("❌ fetchMainImageFromTable failed: $e");
      }
      // If an error occurs, return null
      return -1;
    }
  }

  Future<ImageModel> fetchImageFromImageTable(int imageId) async {
    try {
      final response = await supabase
          .from('images') // Access the 'images' table
          .select('*')
          .eq('image_id', imageId) // Filter by image_id
          .single(); // We are expecting a single record.


      final image = ImageModel.fromJson(response);

      return image; // Return the ImageModel
    } catch (e) {
      if (kDebugMode) {
        print("❌ fetchImageFromImageTable failed: $e");
      }
      return ImageModel.empty(); // Return null if any error occurs
    }
  }
}