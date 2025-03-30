import 'dart:io';

import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../Models/image/image_model.dart';
import '../../main.dart';

import 'package:path/path.dart' as p;

class MediaRepository extends GetxController {
  static MediaRepository get instance => Get.find();

  Future<List<ImageModel>> fetchImagesTable({
    required String folder,
    required int offset,
    required int limit,
  }) async {
    try {
      List<Map<String, dynamic>>? data;
      data = await supabase
          .from("images") // Replace with your table name
          .select()
          .eq('mediacategory', folder)
          .range(offset, offset + limit - 1); // Pagination

      final imageList = data.map((item) {
        return ImageModel.fromJson(item);
      }).toList();

      return imageList;
    } catch (e) {
      TLoader.errorSnackBar(title: 'Media Repo', message: e.toString());
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

  Future<String?> fetchImageFromBucket(
      String filePath, String bucketName) async {
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

///////////////////////UPLOAD SECTION//////////////////////////////

  Future<void> uploadImagesWithMetadata({
    required String bucketName,
    required List<Map<String, dynamic>> jsonDataList,
    required List<File> files,
  }) async {
    if (files.length != jsonDataList.length) {
      if (kDebugMode) {
        print("❌ Error: Number of files and JSON metadata entries must match.");
      }
      return;
    }
    if (kDebugMode) {
      print(jsonDataList);
    }
    for (int i = 0; i < files.length; i++) {
      File file = files[i];
      Map<String, dynamic> jsonData = jsonDataList[i];
      if (kDebugMode) {
        print(jsonData);
      }

      try {
        // ✅ Step 1: Insert metadata (DO NOT pass `image_id`, it auto-increments)
        final response = await supabase
            .from('images')
            .insert({...jsonData, 'filename': null})
            .select('image_id')
            .single(); // Fetch the newly created image_id

        int imageId = response['image_id']; // Fetch auto-generated image_id
        if (kDebugMode) {
          print("✅ Inserted into DB with image_id: $imageId");
        }

        // ✅ Step 2: Generate a unique filename using image_id
        String fileExtension = p.extension(file.path);
        String newFileName = '$imageId$fileExtension';

        // ✅ Step 3: Update the filename in the database
        await supabase.from('images').update({
          'filename': newFileName,
        }).eq('image_id', imageId);
        if (kDebugMode) {
          print("✅ Updated DB with filename: $newFileName");
        }

        final user = supabase.auth.currentUser;

        if (user == null) {
          if (kDebugMode) {
            print("❌ User is not authenticated.");
          }
          return;
        }

        // ✅ Step 4: Upload the file to Supabase Storage
        await supabase.storage.from(bucketName).upload(newFileName, file);
        if (kDebugMode) {
          print("✅ File uploaded successfully: $newFileName");
        }
      } catch (e) {
        if (kDebugMode) {
          print("❌ Error in upload process: $e");
        }
        TLoader.errorSnackBar(
            title: 'Image Upload Failed', message: e.toString());
      }
    }
  }

  Future<void> updateEntityIdRepo(int entityId, int imageId, String mediaCategory) async {
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
      TLoader.errorSnackBar(title: 'Error updating entity ID', message: e.toString());
      if (kDebugMode) {
        print('Error updating entity ID: $e');
      }
      rethrow; // Rethrow the error if needed
    }
  }
}
