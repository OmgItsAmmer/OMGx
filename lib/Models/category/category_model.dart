
class CategoryModel {
  final int categoryId;
  final String categoryName;
  final int? parentCategoryId;
  final bool? isFeatured;
  final String? image;

  CategoryModel({
    required this.categoryId,
    required this.categoryName,
    this.parentCategoryId,
    this.isFeatured,
    this.image,
  });

  // Static function to create an empty category model
  static CategoryModel empty() => CategoryModel(
    categoryId: 0,
    categoryName: '',
    parentCategoryId: null,
    isFeatured: null,
    image: null,
  );

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'category_name': categoryName,
      'parent_category_id': parentCategoryId,
      'isFeatured': isFeatured,
      'image': image,
    };
  }

  // Factory method to create a CategoryModel from Supabase response
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json['category_id'] as int,
      categoryName: json['category_name'] as String,
      parentCategoryId: json['parent_category_id'] as int?,
      isFeatured: json['isFeatured'] as bool?,
      image: json['image'] as String?,
    );
  }
}