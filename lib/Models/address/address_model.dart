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
  final double? latitude;
  final double? longitude;
  final String? placeId;
  final String? formattedAddress;

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
    this.latitude,
    this.longitude,
    this.placeId,
    this.formattedAddress,
  });

  // Static function to create an empty address model
  static AddressModel empty() => AddressModel(fullName: '');

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson({bool isInsert = false}) {
    // Convert empty strings to null for fields checked by database constraint
    // The constraint requires: ^[a-zA-Z0-9\s\.\-\,]+$ which doesn't match empty strings
    // Postal code defaults to '62350' if empty to satisfy chk_postal_code_length constraint
    final postalCodeValue = postalCode?.trim();
    final finalPostalCode = (postalCodeValue == null || postalCodeValue.isEmpty) ? '62350' : postalCodeValue;
    
    final Map<String, dynamic> data = {
      'shipping_address': shippingAddress?.trim().isEmpty == true ? null : shippingAddress?.trim(),
      'phone_number': phoneNumber?.trim().isEmpty == true ? null : phoneNumber?.trim(),
      'postal_code': finalPostalCode,
      'city': city?.trim().isEmpty == true ? null : city?.trim(),
      'country': country?.trim().isEmpty == true ? null : country?.trim(),
      'user_id': userId,
      'full_name': fullName?.trim().isEmpty == true ? null : fullName?.trim(),
      'customer_id': customerId,
      'salesman_id': salesmanId,
      'vendor_id': vendorId,
      'latitude': latitude,
      'longitude': longitude,
      'place_id': placeId,
      'formatted_address': formattedAddress,
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
      latitude: json['latitude'] != null 
          ? (json['latitude'] is num 
              ? (json['latitude'] as num).toDouble() 
              : double.tryParse(json['latitude'].toString()))
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] is num
              ? (json['longitude'] as num).toDouble()
              : double.tryParse(json['longitude'].toString()))
          : null,
      placeId: json['place_id'] as String?,
      formattedAddress: json['formatted_address'] as String?,
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
    double? latitude,
    double? longitude,
    String? placeId,
    String? formattedAddress,
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
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      placeId: placeId ?? this.placeId,
      formattedAddress: formattedAddress ?? this.formattedAddress,
    );
  }
}
