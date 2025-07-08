class BrandModel {
  final String? brandName;
  final bool isVerified;
  final bool? isFeatured;
  int? brandID; // 👈 Made nullable
  final int? productsCount;

  BrandModel({
    this.brandName,
    this.isVerified = false,
    this.isFeatured,
    this.brandID, // 👈 Removed required
    this.productsCount,
  });

  // Static function to create an empty brand model
  static BrandModel empty() => BrandModel(
        brandID: null,
        brandName: null,
        isVerified: false,
        isFeatured: null,
        productsCount: null,
      );

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson({bool isUpdate = false}) {
    final Map<String, dynamic> data = {
      'brandname': brandName,
      'isVerified': isVerified,
      'isFeatured': isFeatured,
      'product_count': productsCount,
    };

    if (!isUpdate && brandID != null) {
      data['brandID'] = brandID;
    }

    return data;
  }

  // Factory method to create a BrandModel from Supabase response
  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      brandName: json['brandname'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      isFeatured: json['isFeatured'] as bool?,
      brandID: json['brandID'] as int?, // 👈 Made nullable
      productsCount: json['product_count'] as int?,
    );
  }
}
