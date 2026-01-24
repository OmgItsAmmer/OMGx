class CollectionModel {
  final int collectionId;
  final String name;
  final String? description;
  final String? imageUrl;
  final bool isActive;
  final bool isFeatured;
  final bool isPremium;
  final int displayOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CollectionModel({
    required this.collectionId,
    required this.name,
    this.description,
    this.imageUrl,
    required this.isActive,
    required this.isFeatured,
    required this.isPremium,
    required this.displayOrder,
    this.createdAt,
    this.updatedAt,
  });

  factory CollectionModel.fromJson(Map<String, dynamic> json) {
    return CollectionModel(
      collectionId: json['collection_id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      imageUrl: json['image_url'],
      isActive: json['is_active'] ?? false,
      isFeatured: json['is_featured'] ?? false,
      isPremium: json['is_premium'] ?? false,
      displayOrder: json['display_order'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson({bool isUpdate = false}) {
    final Map<String, dynamic> json = {
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'is_active': isActive,
      'is_featured': isFeatured,
      'is_premium': isPremium,
      'display_order': displayOrder,
    };

    // Always include collection_id for updates (needed by repository)
    if (isUpdate) {
      json['collection_id'] = collectionId;
      json['updated_at'] = DateTime.now().toIso8601String();
    } else {
      // For inserts, include collection_id if not -1, and timestamps
      if (collectionId != -1) {
        json['collection_id'] = collectionId;
      }
      json['created_at'] = createdAt?.toIso8601String();
      json['updated_at'] = updatedAt?.toIso8601String();
    }

    return json;
  }

  CollectionModel copyWith({
    int? collectionId,
    String? name,
    String? description,
    String? imageUrl,
    bool? isActive,
    bool? isFeatured,
    bool? isPremium,
    int? displayOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CollectionModel(
      collectionId: collectionId ?? this.collectionId,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      isFeatured: isFeatured ?? this.isFeatured,
      isPremium: isPremium ?? this.isPremium,
      displayOrder: displayOrder ?? this.displayOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static CollectionModel empty() {
    return CollectionModel(
      collectionId: -1,
      name: '',
      description: '',
      imageUrl: '',
      isActive: true,
      isFeatured: false,
      isPremium: false,
      displayOrder: 0,
    );
  }
}
