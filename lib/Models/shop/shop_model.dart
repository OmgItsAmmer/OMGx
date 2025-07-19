class ShopModel {
  final int shopId;
  final String shopname;
  final double taxrate;
  final double shippingPrice;
  final double? thresholdFreeShipping; // Optional field
  final String? softwareCompanyName; // Software company name
  final String? softwareWebsiteLink; // Software website link
  final String? softwareContactNo; // Software contact number

  ShopModel({
    required this.shopId,
    required this.shopname,
    required this.taxrate,
    required this.shippingPrice,
    this.thresholdFreeShipping,
    this.softwareCompanyName,
    this.softwareWebsiteLink,
    this.softwareContactNo,
  });

  // Static function to create an empty ShopModel
  static ShopModel empty() => ShopModel(
        shopId: 0,
        shopname: "",
        taxrate: 0.0,
        shippingPrice: 0.0,
        thresholdFreeShipping: null,
        softwareCompanyName: null,
        softwareWebsiteLink: null,
        softwareContactNo: null,
      );

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson() {
    return {
      'shop_id': shopId,
      'shopname': shopname,
      'taxrate': taxrate,
      'shipping_price': shippingPrice,
      'threshold_free_shipping': thresholdFreeShipping,
      'software_company_name': softwareCompanyName,
      'software_website_link': softwareWebsiteLink,
      'software_contact_no': softwareContactNo,
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
      softwareCompanyName: json['software_company_name'] as String?,
      softwareWebsiteLink: json['software_website_link'] as String?,
      softwareContactNo: json['software_contact_no'] as String?,
    );
  }

  // Static method to create a list of ShopModel from a JSON list
  static List<ShopModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ShopModel.fromJson(json)).toList();
  }
}
