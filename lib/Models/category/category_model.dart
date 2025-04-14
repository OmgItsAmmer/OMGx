class CategoryModel {
  int? categoryId; // Nullable, auto-incremented in DB
  final String categoryName;
  final bool? isFeatured; // Nullable, default false in DB
  final int? productCount; // Nullable, represents product count

  CategoryModel({
    this.categoryId, // Nullable
    required this.categoryName,
    this.isFeatured = false, // Default to false
    this.productCount,
  });

  // Static function to create an empty category model
  static CategoryModel empty() => CategoryModel(
    categoryId: null, // Null, as it's auto-generated in DB
    categoryName: '',
    isFeatured: false, // Default to false
    productCount: null, // Default null
  );

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson({bool isUpdate = false}) {
    final Map<String, dynamic> data = {
      'category_name': categoryName,
      'isFeatured': isFeatured,
      'product_count': productCount,
    };

    if (isUpdate && categoryId != null) {
      data['category_id'] = categoryId; // Include category_id for update
    }

    return data;
  }

  // Factory method to create a CategoryModel from Supabase response
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json['category_id'] as int?, // Nullable
      categoryName: json['category_name'] as String,
      isFeatured: json['isFeatured'] as bool?, // Nullable
      productCount: json['product_count'] as int?, // Nullable
    );
  }
}
