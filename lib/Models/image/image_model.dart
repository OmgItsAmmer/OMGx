import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart'; // For RxBool

/// Model class representing image data.
class ImageModel {
  int image_id;
  final String url;
  String folder;
  final String filename;
  final int? sizeBytes;
  final int? entity_id;
  final String? fullPath;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? contentType;
  String mediaCategory;

  // Not Mapped
  final File? file;
  final Uint8List? localImageToDisplay;
  RxBool isSelected = false.obs; // Observable boolean for selection state

  /// Constructor for ImageModel.
  ImageModel({
    required this.image_id,
    required this.url,
    this.folder = 'default',
    required this.filename,
    this.sizeBytes,
    this.entity_id,
    this.fullPath,
    this.createdAt,
    this.updatedAt,
    this.contentType,
    this.file,
    this.localImageToDisplay,
    this.mediaCategory = '',
  });

  // Static function to create an empty image model
  static ImageModel empty() => ImageModel(
    image_id: -1,
    url: '',
    folder: '',
    filename: '',
    mediaCategory: '',
  );

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson({bool isUpdate = false}) {
    final Map<String, dynamic> data = {
      'entity_id': entity_id,
      'mediacategory': mediaCategory,
      'image_url': url,
      'filename': filename,
      'created_at': createdAt?.toIso8601String(),
    };
    if (!isUpdate) {
      data['image_id'] = image_id;
    }
    return data;
  }

  // Factory method to create an ImageModel from a JSON response
  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      image_id: json['image_id'],
      entity_id: json['entity_id'] as int?,
      mediaCategory: json['mediacategory'] as String? ?? '',
      url: json['image_url'] as String? ?? '',
      filename: json['filename'] as String? ?? '',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      // folder: json['folder'] as String? ?? '',
      // sizeBytes: json['size_bytes'] as int?,
      // fullPath: json['full_path'] as String?,
      // updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      // contentType: json['content_type'] as String?,
    );
  }

  // Helper method to toggle the selection state
  void toggleSelection() {
    isSelected.toggle(); // Toggle the observable boolean
  }

  // Helper method to copy the model with updated fields
  ImageModel copyWith({
    int? id,
    String? url,
    String? folder,
    String? filename,
    int? sizeBytes,
    String? fullPath,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? contentType,
    String? mediaCategory,
    File? file,
    Uint8List? localImageToDisplay,
    bool? isSelected,
  }) {
    return ImageModel(
      image_id: id ?? image_id,
      url: url ?? this.url,
      folder: folder ?? this.folder,
      filename: filename ?? this.filename,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      fullPath: fullPath ?? this.fullPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      contentType: contentType ?? this.contentType,
      mediaCategory: mediaCategory ?? this.mediaCategory,
      file: file ?? this.file,
      localImageToDisplay: localImageToDisplay ?? this.localImageToDisplay,
    )..isSelected.value = isSelected ?? this.isSelected.value;
  }
}