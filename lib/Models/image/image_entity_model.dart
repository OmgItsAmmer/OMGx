import 'package:get/get.dart';

/// Model class representing image-entity mapping.
class ImageEntityModel {
  final int imageEntityId;
  final int? imageId;
  final int? entityId;
  final String? entityCategory;
  final DateTime createdAt;
  final bool? isFeatured;

  // Not mapped to DB (UI related, if needed)
  RxBool isSelected;

  /// Constructor
  ImageEntityModel({
    this.imageEntityId = -1,
    this.imageId,
    this.entityId,
    this.entityCategory,
    DateTime? createdAt,
    this.isFeatured,
    RxBool? isSelected,
  })  : createdAt = createdAt ?? DateTime.now(),
        isSelected = isSelected ?? false.obs;

  /// Factory constructor to create an instance from JSON
  factory ImageEntityModel.fromJson(Map<String, dynamic> json) {
    return ImageEntityModel(
      imageEntityId: json['image_entity_id'] ?? -1,
      imageId: json['image_id'],
      entityId: json['entity_id'],
      entityCategory: json['entity_category'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : DateTime.now(),
      isFeatured: json['isFeatured'],
    );
  }

  /// Convert model to JSON for insertion/update
  Map<String, dynamic> toJson({bool isUpdate = false}) {
    final data = {
      'image_id': imageId,
      'entity_id': entityId,
      'entity_category': entityCategory,
      'isFeatured': isFeatured,
    };
    if (!isUpdate) {
      data['image_entity_id'] = imageEntityId;
    }
    return data;
  }

  /// Create a copy with updated fields
  ImageEntityModel copyWith({
    int? imageEntityId,
    int? imageId,
    int? entityId,
    String? entityCategory,
    DateTime? createdAt,
    bool? isSelected,
    bool? isFeatured,
  }) {
    return ImageEntityModel(
      imageEntityId: imageEntityId ?? this.imageEntityId,
      imageId: imageId ?? this.imageId,
      entityId: entityId ?? this.entityId,
      entityCategory: entityCategory ?? this.entityCategory,
      createdAt: createdAt ?? this.createdAt,
      isFeatured: isFeatured ?? this.isFeatured,
      isSelected: isSelected != null ? isSelected.obs : this.isSelected,
    );
  }
}
