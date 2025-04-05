import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';

import 'image_entity_model.dart';
import 'image_model.dart';

class CombinedImageEntityModel {
  // ImageEntityModel fields
  final int imageEntityId;
  final int? entityId;
  final String? entityCategory;
  final DateTime createdAt;
  final bool? isFeatured;

  // ImageModel fields
  final int imageId;
  final String url;
  final String? filename;
  final String? folderType;
  final DateTime? imageCreatedAt;
  final File? file;
  final Uint8List? localImageToDisplay;

  // UI
  RxBool isSelected;

  CombinedImageEntityModel({
    this.imageEntityId = -1,
    required this.imageId,
    required this.url,
    this.filename,
    this.folderType,
    this.entityId,
    this.entityCategory,
    DateTime? createdAt,
    DateTime? imageCreatedAt,
    this.isFeatured,
    this.file,
    this.localImageToDisplay,
    RxBool? isSelected,
  })  : createdAt = createdAt ?? DateTime.now(),
        imageCreatedAt = imageCreatedAt ?? DateTime.now(),
        isSelected = isSelected ?? false.obs;

  /// Convert to JSON (for logging or sending, optional)
  Map<String, dynamic> toJson() {
    return {
      'image_entity_id': imageEntityId,
      'image_id': imageId,
      'image_url': url,
      'filename': filename,
      'folderType': folderType,
      'entity_id': entityId,
      'entity_category': entityCategory,
      'created_at': createdAt.toIso8601String(),
      'image_created_at': imageCreatedAt?.toIso8601String(),
      'isFeatured': isFeatured,
    };
  }

  CombinedImageEntityModel combineImageAndEntity({
    required ImageModel imageModel,
    required ImageEntityModel entityModel,
  }) {
    return CombinedImageEntityModel(
      imageEntityId: entityModel.imageEntityId,
      imageId: imageModel.imageId,
      url: imageModel.url,
      filename: imageModel.filename,
      folderType: imageModel.folderType,
      entityId: entityModel.entityId,
      entityCategory: entityModel.entityCategory,
      createdAt: entityModel.createdAt,
      imageCreatedAt: imageModel.createdAt,
      isFeatured: entityModel.isFeatured,
      file: imageModel.file,
      localImageToDisplay: imageModel.localImageToDisplay,
      isSelected: entityModel.isSelected,
    );
  }

  /// Create from JSON
  factory CombinedImageEntityModel.fromJson({
    required Map<String, dynamic> imageJson,
    required Map<String, dynamic> entityJson,
  }) {
    return CombinedImageEntityModel(
      imageEntityId: entityJson['image_entity_id'] ?? -1,
      imageId: imageJson['image_id'] ?? -1,
      url: imageJson['image_url'] ?? '',
      filename: imageJson['filename'],
      folderType: imageJson['folderType'],
      entityId: entityJson['entity_id'],
      entityCategory: entityJson['entity_category'],
      createdAt: entityJson['created_at'] != null
          ? DateTime.tryParse(entityJson['created_at']) ?? DateTime.now()
          : DateTime.now(),
      imageCreatedAt: imageJson['created_at'] != null
          ? DateTime.tryParse(imageJson['created_at'])
          : null,
      isFeatured: entityJson['isFeatured'],
      isSelected: false.obs,
    );
  }

  static CombinedImageEntityModel empty() {
    return CombinedImageEntityModel(
      imageEntityId: -1,
      imageId: -1,
      url: '',
      filename: '',
      folderType: '',
      entityId: null,
      entityCategory: '',
      createdAt: DateTime.now(),
      imageCreatedAt: DateTime.now(),
      isFeatured: false,
      file: null,
      localImageToDisplay: null,
      isSelected: false.obs,
    );
  }

  /// Convert to ImageModel
  ImageModel toImageModel() {
    return ImageModel(
      imageId: imageId,
      url: url,
      filename: filename,
      folderType: folderType,
      createdAt: imageCreatedAt,
      file: file,
      localImageToDisplay: localImageToDisplay,
    );
  }

  /// Convert to ImageEntityModel
  ImageEntityModel toImageEntityModel() {
    return ImageEntityModel(
      imageEntityId: imageEntityId,
      entityId: entityId,
      entityCategory: entityCategory,
      createdAt: createdAt,
      isFeatured: isFeatured,
      isSelected: isSelected,
    );
  }
}
