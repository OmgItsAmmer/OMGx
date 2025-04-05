import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';

/// Model class representing image data as per updated PostgreSQL schema.
class ImageModel {
  final int imageId;
  final String url;
  final String? filename;
  final DateTime? createdAt;
  final String? folderType;

  // Local only (not mapped to DB)
  final File? file;
  final Uint8List? localImageToDisplay;
  RxBool isSelected;

  /// Constructor
  ImageModel({
    this.imageId = -1,
    required this.url,
    this.filename,
    this.createdAt,
    this.folderType,
    this.file,
    this.localImageToDisplay,
    RxBool? isSelected,
  }) : isSelected = isSelected ?? false.obs;

  /// Empty instance factory
  static ImageModel empty() => ImageModel(url: '');

  /// Convert model to JSON
  Map<String, dynamic> toJson({bool isUpdate = false}) {
    final data = <String, dynamic>{
      'image_url': url,
      'filename': filename,
      'folderType': folderType,
    };
    if (!isUpdate) {
      data['image_id'] = imageId;
    }
    return data;
  }

  /// Create model from JSON
  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      imageId: json['image_id'] ?? -1,
      url: json['image_url'] ?? '',
      filename: json['filename'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      folderType: json['folderType'],
    );
  }

  /// Toggle selection state
  void toggleSelection() {
    isSelected.toggle();
  }

  /// Copy with updated fields
  ImageModel copyWith({
    int? imageId,
    String? imageUrl,
    String? filename,
    DateTime? createdAt,
    String? folderType,
    File? file,
    Uint8List? localImageToDisplay,
    bool? isSelected,
  }) {
    return ImageModel(
      imageId: imageId ?? this.imageId,
      url: imageUrl ?? this.url,
      filename: filename ?? this.filename,
      createdAt: createdAt ?? this.createdAt,
      folderType: folderType ?? this.folderType,
      file: file ?? this.file,
      localImageToDisplay: localImageToDisplay ?? this.localImageToDisplay,
      isSelected: (isSelected != null) ? isSelected.obs : this.isSelected,
    );
  }
}
