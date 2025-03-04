class CustomerModel {
  int customerId;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String cnic;
  final String? pfp; // Optional profile picture field
  final DateTime? createdAt; // Optional, not required

  CustomerModel({
    required this.customerId,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.cnic,
    this.pfp,
    this.createdAt, // Optional, can be null
  });

  // Static function to create an empty user model
  static CustomerModel empty() => CustomerModel(
    customerId: 0,
    firstName: "",
    lastName: "",
    phoneNumber: "",
    email: "",
    cnic: "",
    pfp: null,
    createdAt: null, // Defaults to null
  );

  // Function to get the full name
  String get fullName => "$firstName $lastName".trim();

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'email': email,
      'cnic': cnic,
      'pfp': pfp,
      'created_at': createdAt?.toIso8601String(), // Convert DateTime to ISO string
    };
  }

  // Factory method to create a CustomerModel from Supabase response
  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      customerId: json['customer_id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      phoneNumber: json['phone_number'] as String,
      email: json['email'] as String,
      cnic: json['cnic'] as String,
      pfp: json['pfp'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null, // Parse ISO string to DateTime, or null if not present
    );
  }

  // Static method to create a list of CustomerModel from a JSON list
  static List<CustomerModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => CustomerModel.fromJson(json)).toList();
  }
}