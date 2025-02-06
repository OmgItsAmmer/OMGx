import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart'; // For RxBool

/// Model class representing image data.
class ImageModel {
  String id;
  final String url;
  final String folder;
  final String filename;
  final int? sizeBytes;
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
    this.id = '',
    required this.url,
    required this.folder,
    required this.filename,
    this.sizeBytes,
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
    id: '',
    url: '',
    folder: '',
    filename: '',
    mediaCategory: '',
  );

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'folder': folder,
      'filename': filename,
      'size_bytes': sizeBytes,
      'full_path': fullPath,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'content_type': contentType,
      'media_category': mediaCategory,
      // Note: `file`, `localImageToDisplay`, and `isSelected` are not included in JSON
    };
  }

  // Factory method to create an ImageModel from a JSON response
  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'] as String? ?? '',
      url: json['url'] as String? ?? '',
      folder: json['folder'] as String? ?? '',
      filename: json['filename'] as String? ?? '',
      sizeBytes: json['size_bytes'] as int?,
      fullPath: json['full_path'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      contentType: json['content_type'] as String?,
      mediaCategory: json['media_category'] as String? ?? '',
    );
  }

  // Helper method to toggle the selection state
  void toggleSelection() {
    isSelected.toggle(); // Toggle the observable boolean
  }

  // Helper method to copy the model with updated fields
  ImageModel copyWith({
    String? id,
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
      id: id ?? this.id,
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