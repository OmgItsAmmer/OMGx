class UserModel {
  final int userId;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final DateTime? dob;
  final DateTime? createdAt;
  final String? gender;
  final String? authUid;
  // Removed pfp field as it's not in the new schema

  UserModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    this.dob,
    this.createdAt,
    this.gender,
    this.authUid,
  });

  // Static function to create an empty user model
  static UserModel empty() => UserModel(
        userId: 0,
        firstName: "",
        lastName: "",
        phoneNumber: "",
        email: "",
        dob: null,
        createdAt: null,
        gender: null,
        authUid: null,
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
      'dob': dob?.toIso8601String(),
      'gender': gender,
      'auth_uid': authUid,
    };

    if (!isUpdate) {
      data['user_id'] = userId;
    }

    return data;
  }

  // Factory method to create a UserModel from Supabase response
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? '',
      email: json['email'] as String,
      dob: json['dob'] != null ? DateTime.parse(json['dob'] as String) : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      gender: json['gender'] as String?,
      authUid: json['auth_uid'] as String?,
    );
  }

  // Static method to create a list of UserModel from a JSON list
  static List<UserModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => UserModel.fromJson(json)).toList();
  }
}
