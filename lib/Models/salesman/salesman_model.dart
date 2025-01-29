class SalesmanModel {
  final int salesmanId;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String cnic;
  final String area;
  final String city;
  final String? pfp; // Optional profile picture field

  SalesmanModel({
    required this.salesmanId,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.cnic,
    required this.area,
    required this.city,
    this.pfp,
  });

  // Static function to create an empty salesman model
  static SalesmanModel empty() => SalesmanModel(
    salesmanId: 0,
    firstName: "",
    lastName: "",
    phoneNumber: "",
    email: "",
    cnic: "",
    area: "",
    city: "",
    pfp: null,
  );

  // Function to get the full name
  String get fullName => "$firstName $lastName".trim();

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson() {
    return {
      'salesman_id': salesmanId,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'email': email,
      'cnic': cnic,
      'area': area,
      'city': city,
      'pfp': pfp,
    };
  }

  // Factory method to create a SalesmanModel from a JSON object
  factory SalesmanModel.fromJson(Map<String, dynamic> json) {
    return SalesmanModel(
      salesmanId: json['salesman_id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      phoneNumber: json['phone_number'] as String,
      email: json['email'] as String,
      cnic: json['cnic'] as String,
      area: json['area'] as String,
      city: json['city'] as String,
      pfp: json['pfp'] as String?,
    );
  }

  // Static method to create a list of SalesmanModel from a JSON list
  static List<SalesmanModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => SalesmanModel.fromJson(json)).toList();
  }
}