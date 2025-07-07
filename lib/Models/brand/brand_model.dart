class BrandModel {
  final String? brandname;
  final bool isVerified;
  final bool? isFeatured;
   int brandID; // 👈 Now non-nullable
  final int productCount; // 👈 Renamed and non-nullable

  BrandModel({
    this.brandname,
    this.isVerified = false,
    this.isFeatured,
    required this.brandID, // 👈 Required
    this.productCount = 0, // 👈 Default value
  });

  // Static function to create an empty brand model
  static BrandModel empty() => BrandModel(
        brandID: -1, // 👈 Default value for empty
        brandname: null,
        isVerified: false,
        isFeatured: null,
        productCount: 0,
      );

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson({bool isUpdate = false}) {
    final Map<String, dynamic> data = {
      'brandname': brandname,
      'isVerified': isVerified,
      'isFeatured': isFeatured,
      'product_count': productCount,
    };

    if (!isUpdate) {
      data['brandID'] = brandID;
    }

    return data;
  }

  // Factory method to create a BrandModel from Supabase response
  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      brandname: json['brandname'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      isFeatured: json['isFeatured'] as bool?,
      brandID: json['brandID'] as int, // 👈 Non-nullable
      productCount: json['product_count'] as int? ?? 0, // 👈 Default value
    );
  }
}
