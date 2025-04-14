class SalesmanModel {
  int? salesmanId; // Made nullable
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String cnic;
  final String area;
  final String city;
  final DateTime? createdAt;
  final int? comission;

  SalesmanModel({
    this.salesmanId, // Now optional
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.cnic,
    required this.area,
    required this.city,
    this.createdAt,
    this.comission,
  });

  // Static function to create an empty salesman model
  static SalesmanModel empty() => SalesmanModel(
    salesmanId: null,
    firstName: "",
    lastName: "",
    phoneNumber: "",
    email: "",
    cnic: "",
    area: "",
    city: "",
    createdAt: null,
    comission: null,
  );

  String get fullName => "$firstName $lastName".trim();

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson({bool isUpdate = false}) {
    final Map<String, dynamic> data = {
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'email': email,
      'cnic': cnic,
      'area': area,
      'city': city,
      'comission': comission,
    };

    if (!isUpdate) {
      if (salesmanId != null) {
        data['salesman_id'] = salesmanId;
      }
    }

    return data;
  }

  // Factory method to create a SalesmanModel from a JSON object
  factory SalesmanModel.fromJson(Map<String, dynamic> json) {
    return SalesmanModel(
      salesmanId: json['salesman_id'] as int?,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String? ?? "",
      phoneNumber: json['phone_number'] as String? ?? "",
      email: json['email'] as String,
      cnic: json['cnic'] as String,
      area: json['area'] as String,
      city: json['city'] as String,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      comission: json['comission'] as int?,
    );
  }

  // Static method to create a list of SalesmanModel from a JSON list
  static List<SalesmanModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => SalesmanModel.fromJson(json)).toList();
  }
}
