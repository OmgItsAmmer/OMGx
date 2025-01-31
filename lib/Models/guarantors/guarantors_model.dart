class GuarantorsModel {
  final int guarantorId;
  final String firstName;
  final String lastName;
  final String phoneNumber;

  final String cnic;
  final String? pfp; // Optional profile picture field

  GuarantorsModel({
    required this.guarantorId,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.cnic,
    this.pfp,
  });

  // Static function to create an empty user model
  static GuarantorsModel empty() => GuarantorsModel(
    guarantorId: 0,
    firstName: "",
    lastName: "",
    phoneNumber: "",
    cnic: "",
    pfp: null,
  );

  // Function to get the full name
  String get fullName => "$firstName $lastName".trim();

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson() {
    return {
      'guarantor_id': guarantorId,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'cnic': cnic,
      'pfp': pfp,
    };
  }

  // Factory method to create a UserModel from Supabase response
  factory GuarantorsModel.fromJson(Map<String, dynamic> json) {
    return GuarantorsModel(
      guarantorId: json['guarantor_id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      phoneNumber: json['phone_number'] as String,

      cnic: json['cnic'] as String,
      pfp: json['pfp'] as String?,
    );
  }

  // Static method to create a list of UserModel from a JSON list
  static List<GuarantorsModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => GuarantorsModel.fromJson(json)).toList();
  }
}
