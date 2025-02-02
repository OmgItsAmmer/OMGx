class GuarantorsModel {
  final int guarantorId;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String cnic;
  final String? pfp; // Optional profile picture field
  final String? address; // Optional address field

  GuarantorsModel({
    required this.guarantorId,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.cnic,
    this.pfp,
    this.address,
  });

  // Static function to create an empty guarantor model
  static GuarantorsModel empty() => GuarantorsModel(
    guarantorId: 0,
    firstName: "",
    lastName: "",
    phoneNumber: "",
    email: "",
    cnic: "",
    pfp: null,
    address: null,
  );

  // Function to get the full name
  String get fullName => "$firstName $lastName".trim();

  // Convert model to JSON for database insertion (exclude guarantor_id)
  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'email': email,
      'cnic': cnic,
      'pfp': pfp,
      'address': address,
    };
  }

  // Factory method to create a GuarantorsModel from Supabase response
  factory GuarantorsModel.fromJson(Map<String, dynamic> json) {
    return GuarantorsModel(
      guarantorId: json['guarantor_id'] as int? ?? 0,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? '',
      email: json['email'] as String? ?? '',
      cnic: json['cnic'] as String? ?? '',
      pfp: json['pfp'] as String?,
      address: json['address'] as String?,
    );
  }

  // Static method to create a list of GuarantorsModel from a JSON list
  static List<GuarantorsModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => GuarantorsModel.fromJson(json)).toList();
  }
}