class ShopModel {
  final int shopId;
  final String shopname;
  final double taxrate;
  final double shippingPrice;
  final double? thresholdFreeShipping; // Optional field
  final double? profile1; // Optional field
  final double? profile2; // Optional field
  final double? profile3; // Optional field

  ShopModel({
    required this.shopId,
    required this.shopname,
    required this.taxrate,
    required this.shippingPrice,
    this.thresholdFreeShipping,
    this.profile1,
    this.profile2,
    this.profile3,
  });

  // Static function to create an empty ShopModel
  static ShopModel empty() => ShopModel(
    shopId: 0,
    shopname: "",
    taxrate: 0.0,
    shippingPrice: 0.0,
    thresholdFreeShipping: null,
    profile1: null,
    profile2: null,
    profile3: null,
  );

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson() {
    return {
      'shop_id': shopId,
      'shopname': shopname,
      'taxrate': taxrate,
      'shipping_price': shippingPrice,
      'threshold_free_shipping': thresholdFreeShipping,
      'profile1': profile1,
      'profile2': profile2,
      'profile3': profile3,
    };
  }

  // Factory method to create a ShopModel from a JSON object
  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      shopId: json['shop_id'] as int,
      shopname: json['shopname'] as String,
      taxrate: (json['taxrate'] as num).toDouble(), // Convert num to double
      shippingPrice: (json['shipping_price'] as num).toDouble(),
      thresholdFreeShipping: json['threshold_free_shipping'] != null
          ? (json['threshold_free_shipping'] as num).toDouble()
          : null,
      profile1: json['profile1'] != null ? (json['profile1'] as num).toDouble() : null,
      profile2: json['profile2'] != null ? (json['profile2'] as num).toDouble() : null,
      profile3: json['profile3'] != null ? (json['profile3'] as num).toDouble() : null,
    );
  }

  // Static method to create a list of ShopModel from a JSON list
  static List<ShopModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ShopModel.fromJson(json)).toList();
  }
}
