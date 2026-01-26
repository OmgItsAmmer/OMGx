class OrderAddressModel {
  final int? orderAddressId;
  final String location;
  final String? phoneNumber;
  final String? postalCode;
  final String? city;
  final String? country;
  final String fullName;
  final int? customerId;
  final int? vendorId;
  final int? salesmanId;
  final int? userId;
  final int? addressId;
  final double? latitude;
  final double? longitude;
  final String? placeId;
  final String? formattedAddress;

  String get name => fullName;

  String get displayAddress {
    return formattedAddress ?? 
        [location, city, postalCode, country]
            .where((element) => element != null && element.isNotEmpty)
            .join(', ');
  }

  /// Check if the address has valid coordinates
  bool hasValidCoordinates() {
    return latitude != null && 
           longitude != null && 
           latitude != 0.0 && 
           longitude != 0.0;
  }

  OrderAddressModel({
    this.orderAddressId,
    this.location = '',
    this.phoneNumber,
    this.postalCode,
    this.city,
    this.country,
    this.fullName = '',
    this.customerId,
    this.vendorId,
    this.salesmanId,
    this.userId,
    this.addressId,
    this.latitude,
    this.longitude,
    this.placeId,
    this.formattedAddress,
  });

  // Static function to create an empty order address model
  static OrderAddressModel empty() => OrderAddressModel();

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson({bool isInsert = false}) {
    final Map<String, dynamic> data = {
      'shipping_address': location,
      'phone_number': phoneNumber,
      'postal_code': postalCode,
      'city': city,
      'country': country,
      'full_name': fullName,
      'customer_id': customerId,
      'vendor_id': vendorId,
      'salesman_id': salesmanId,
      'user_id': userId,
      'address_id': addressId,
      'latitude': latitude,
      'longitude': longitude,
      'place_id': placeId,
      'formatted_address': formattedAddress,
    };

    if (!isInsert) {
      data['order_address_id'] = orderAddressId;
    }

    return data;
  }

  // Factory method to create an OrderAddressModel from JSON
  factory OrderAddressModel.fromJson(Map<String, dynamic> json) {
    // Parse latitude with proper type handling
    double? parseLatitude(dynamic value) {
      if (value == null) return null;
      if (value is num) {
        return value.toDouble();
      }
      return double.tryParse(value.toString());
    }

    // Parse longitude with proper type handling
    double? parseLongitude(dynamic value) {
      if (value == null) return null;
      if (value is num) {
        return value.toDouble();
      }
      return double.tryParse(value.toString());
    }

    return OrderAddressModel(
      orderAddressId: json['order_address_id'] as int?,
      location: json['shipping_address'] as String? ?? '',
      phoneNumber: json['phone_number'] as String?,
      postalCode: json['postal_code'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      fullName: json['full_name'] as String? ?? '',
      customerId: json['customer_id'] as int?,
      vendorId: json['vendor_id'] as int?,
      salesmanId: json['salesman_id'] as int?,
      userId: json['user_id'] as int?,
      addressId: json['address_id'] as int?,
      latitude: parseLatitude(json['latitude']),
      longitude: parseLongitude(json['longitude']),
      placeId: json['place_id'] as String?,
      formattedAddress: json['formatted_address'] as String?,
    );
  }

  // Static method to create a list of OrderAddressModel from a JSON list
  static List<OrderAddressModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => OrderAddressModel.fromJson(json)).toList();
  }

  // CopyWith method
  OrderAddressModel copyWith({
    int? orderAddressId,
    String? location,
    String? phoneNumber,
    String? postalCode,
    String? city,
    String? country,
    String? fullName,
    int? customerId,
    int? vendorId,
    int? salesmanId,
    int? userId,
    int? addressId,
    double? latitude,
    double? longitude,
    String? placeId,
    String? formattedAddress,
  }) {
    return OrderAddressModel(
      orderAddressId: orderAddressId ?? this.orderAddressId,
      location: location ?? this.location,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      postalCode: postalCode ?? this.postalCode,
      city: city ?? this.city,
      country: country ?? this.country,
      fullName: fullName ?? this.fullName,
      customerId: customerId ?? this.customerId,
      vendorId: vendorId ?? this.vendorId,
      salesmanId: salesmanId ?? this.salesmanId,
      userId: userId ?? this.userId,
      addressId: addressId ?? this.addressId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      placeId: placeId ?? this.placeId,
      formattedAddress: formattedAddress ?? this.formattedAddress,
    );
  }
}
