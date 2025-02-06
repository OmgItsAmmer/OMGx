import 'dart:io';

import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:get/get.dart';

import '../../Models/image/image_model.dart';
import '../../views/media/widgets/media_content.dart';

class MediaController extends GetxController {
  static MediaController get instance => Get.find();
//  final productRepository = Get.put(ProductRepository());

  var droppedFiles = <File>[].obs;

  late DropzoneViewController dropzoneViewController;
  final Rx<MediaCategory> selectedPath = MediaCategory.folders.obs;
  final RxBool showMediaUploaderSection = false.obs;
  final RxBool showImagesUploaderSection = false.obs;

  void addDroppedFile(File file) {
    droppedFiles.add(file);
  }

  void clearDroppedFiles() {
    droppedFiles.clear();
  }

  // Function to display a bottom sheet for image selection
  Future<List<ImageModel>> selectImagesFromMedia({
    required List<String> selectedUrls,
    bool allowSelection = true,
    bool multipleSelection = false,
  }) async {
    // List to store selected images
    List<ImageModel> selectedImages = [];

    // Show the bottom sheet
    await Get.bottomSheet<List<ImageModel>>(
      isScrollControlled: true,
      backgroundColor: Colors.white, // Replace with your theme color
      FractionallySizedBox(
        heightFactor: 0.9, // Adjust height as needed
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Replace with your theme padding
            child: Column(
              children: [
                const Text(
                  'Select Images',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                MediaContent(
                  allowSelection: allowSelection,
                  alreadySelectedUrls: selectedUrls,
                  allowMultipleSelection: multipleSelection,

                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Get.back(result: selectedImages); // Close the bottom sheet and return selected images
                  },
                  child: const Text('Done'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return selectedImages;
  }

}
