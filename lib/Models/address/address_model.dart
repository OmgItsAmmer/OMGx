class AddressModel {
  final int? addressId;
  final String location;
  final String? phoneNumber;
  final String? postalCode;
  final String? city;
  final String? country;
  final String fullName;
  final int? userId;
  final int? customerId;
  final int? salesmanId;
  final int? vendorId;

  AddressModel({
    this.addressId,
    this.location = '',
    this.phoneNumber,
    this.postalCode,
    this.city,
    this.country,
    this.fullName = '',
    this.userId,
    this.customerId,
    this.salesmanId,
    this.vendorId,
  });

  // Static function to create an empty address model
  static AddressModel empty() => AddressModel();

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson({bool isUpdate = false}) {
    final Map<String, dynamic> data = {
      'shipping_address': location,
      'phone_number': phoneNumber,
      'postal_code': postalCode,
      'city': city,
      'country': country,
      'full_name': fullName,
      'user_id': userId,
      'customer_id': customerId,
      'salesman_id': salesmanId,
      'vendor_id': vendorId,
    };

    if (!isUpdate) {
      data['address_id'] =
          addressId; // Only include `address_id` if it's not an update
    }

    return data;
  }

  // Factory method to create an AddressModel from JSON
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      addressId: json['address_id'] as int?,
      location: json['shipping_address'] as String? ?? '',
      phoneNumber: json['phone_number'] as String?,
      postalCode: json['postal_code'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      fullName: json['full_name'] as String? ?? '',
      userId: json['user_id'] as int?,
      customerId: json['customer_id'] as int?,
      salesmanId: json['salesman_id'] as int?,
      vendorId: json['vendor_id'] as int?,
    );
  }

  // Static method to create a list of AddressModel from a JSON list
  static List<AddressModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => AddressModel.fromJson(json)).toList();
  }
}
