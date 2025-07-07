class AddressModel {
  final int? addressId;
  final String? shippingAddress;
  final String? phoneNumber;
  final String? postalCode;
  final String? city;
  final String? country;
  final String? userId;
  final String? fullName;
  final int? customerId;
  final int? salesmanId;
  final int? vendorId;

  AddressModel({
    this.addressId,
    this.shippingAddress = '',
    this.phoneNumber = '',
    this.postalCode = '',
    this.city = '',
    this.country = '',
    this.userId,
    this.fullName,
    this.customerId,
    this.salesmanId,
    this.vendorId,
  });

  // Static function to create an empty address model
  static AddressModel empty() => AddressModel(fullName: '');

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson({bool isInsert = false}) {
    final Map<String, dynamic> data = {
      'shipping_address': shippingAddress,
      'phone_number': phoneNumber,
      'postal_code': postalCode,
      'city': city,
      'country': country,
      'user_id': userId,
      'full_name': fullName,
      'customer_id': customerId,
      'salesman_id': salesmanId,
      'vendor_id': vendorId,
    };

    if (!isInsert) {
      data['address_id'] = addressId;
    }

    return data;
  }

  // Factory method to create an AddressModel from JSON
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      addressId: json['address_id'] as int?,
      shippingAddress: json['shipping_address'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? '',
      postalCode: json['postal_code'] as String? ?? '',
      city: json['city'] as String? ?? '',
      country: json['country'] as String? ?? '',
      userId: json['user_id'] as String?,
      fullName: json['full_name'] as String? ?? '',
      customerId: json['customer_id'] as int?,
      salesmanId: json['salesman_id'] as int?,
      vendorId: json['vendor_id'] as int?,
    );
  }

  // Static method to create a list of AddressModel from a JSON list
  static List<AddressModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => AddressModel.fromJson(json)).toList();
  }

  AddressModel copyWith({
    int? addressId,
    String? shippingAddress,
    String? phoneNumber,
    String? postalCode,
    String? city,
    String? country,
    String? userId,
    String? fullName,
    int? customerId,
    int? salesmanId,
    int? vendorId,
  }) {
    return AddressModel(
      addressId: addressId ?? this.addressId,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      postalCode: postalCode ?? this.postalCode,
      city: city ?? this.city,
      country: country ?? this.country,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      customerId: customerId ?? this.customerId,
      salesmanId: salesmanId ?? this.salesmanId,
      vendorId: vendorId ?? this.vendorId,
    );
  }
}
