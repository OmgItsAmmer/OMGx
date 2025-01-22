class CustomerModel {
  final int userId;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String? pfp; // Optional profile picture field

  CustomerModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    this.pfp,
  });

  // Static function to create an empty user model
  static CustomerModel empty() => CustomerModel(
    userId: 0,
    firstName: "",
    lastName: "",
    phoneNumber: "",
    email: "",
    pfp: null,
  );

  // Function to get the full name
  String get fullName => "$firstName $lastName".trim();

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'email': email,
      'pfp': pfp,
    };
  }

  // Factory method to create a UserModel from Supabase response
  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      userId: json['user_id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      phoneNumber: json['phone_number'] as String,
      email: json['email'] as String,
      pfp: json['pfp'] as String?,
    );
  }

  // Static method to create a list of UserModel from a JSON list
  static List<CustomerModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => CustomerModel.fromJson(json)).toList();
  }
}
