class CustomerModel {
  int? customerId; // Made nullable
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String cnic;
  final String? pfp; // Optional profile picture field
  final DateTime? createdAt; // Optional, not required

  CustomerModel({
    this.customerId, // nullable now
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.cnic,
    this.pfp,
    this.createdAt,
  });

  // Static function to create an empty user model
  static CustomerModel empty() => CustomerModel(
    customerId: null, // nullable now
    firstName: "",
    lastName: "",
    phoneNumber: "",
    email: "",
    cnic: "",
    pfp: null,
    createdAt: null,
  );

  // Function to get the full name
  String get fullName => "$firstName $lastName".trim();

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson({bool isUpdate = false}) {
    final Map<String, dynamic> data = {
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'email': email,
      'cnic': cnic,
      'pfp': pfp,
    };

    if (!isUpdate) {
      if (customerId != null) {
        data['customer_id'] = customerId;
      }

    }

    return data;
  }

  // Factory method to create a CustomerModel from Supabase response
  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      customerId: json['customer_id'] as int?,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      phoneNumber: json['phone_number'] as String,
      email: json['email'] as String,
      cnic: json['cnic'] as String,
      pfp: json['pfp'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  // Static method to create a list of CustomerModel from a JSON list
  static List<CustomerModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => CustomerModel.fromJson(json)).toList();
  }
}
