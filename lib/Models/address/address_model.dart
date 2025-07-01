class AddressModel {
  final int? addressId;
  final String? location;
  final int? userId;
  final int? customerId;
  final int? salesmanId;
  final int? vendorId;

  AddressModel({
    this.addressId,
    this.location = '',
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
      'location': location,
      'user_id': userId,
      'customer_id': customerId,
      'salesmanId': salesmanId,
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
      location: json['location'] as String? ?? '',
      userId: json['user_id'] as int?,
      customerId: json['customer_id'] as int?,
      salesmanId: json['salesmanId'] as int?,
      vendorId: json['vendor_id'] as int?,
    );
  }

  // Static method to create a list of AddressModel from a JSON list
  static List<AddressModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => AddressModel.fromJson(json)).toList();
  }
}
