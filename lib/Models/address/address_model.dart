class AddressModel {
  final int addressId;
  final String location;
  final String phoneNumber;
  final String street;
  final String postalCode;
  final String city;
  final String state;
  final String country;
  final int? userId; // Optional field for linking to a user
  final int? customerId; // Optional field for linking to a customer
  final int? salesmanId; // Optional field for linking to a salesman

  AddressModel({
    required this.addressId,
    required this.location,
    required this.phoneNumber,
    required this.street,
    required this.postalCode,
    required this.city,
    required this.state,
    required this.country,
    this.userId,
    this.customerId,
    this.salesmanId,
  });

  // Static function to create an empty address model
  static AddressModel empty() => AddressModel(
    addressId: 0,
    location: "",
    phoneNumber: "",
    street: "",
    postalCode: "",
    city: "",
    state: "",
    country: "",
    userId: null,
    customerId: null,
    salesmanId: null,
  );

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson() {
    return {
      'address_id': addressId,
      'location': location,
      'phone_number': phoneNumber,
      'street': street,
      'postal_code': postalCode,
      'city': city,
      'state': state,
      'country': country,
      'user_id': userId,
      'customer_id': customerId,
      'salesman_id': salesmanId,
    };
  }

  // Factory method to create an AddressModel from JSON
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      addressId: json['address_id'] as int,
      location: json['location'] as String,
      phoneNumber: json['phone_number'] as String,
      street: json['street'] as String,
      postalCode: json['postal_code'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      country: json['country'] as String,
      userId: json['user_id'] as int?,
      customerId: json['customer_id'] as int?,
      salesmanId: json['salesman_id'] as int?,
    );
  }

  // Static method to create a list of AddressModel from a JSON list
  static List<AddressModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => AddressModel.fromJson(json)).toList();
  }
}
