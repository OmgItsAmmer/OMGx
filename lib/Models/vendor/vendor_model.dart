class VendorModel {
  int? vendorId;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String cnic;
  final String email;
  final DateTime? createdAt;

  VendorModel({
    this.vendorId,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.cnic,
    required this.email,
    this.createdAt,
  });

  static VendorModel empty() => VendorModel(
        vendorId: null,
        phoneNumber: '',
        firstName: '',
        lastName: '',
        cnic: '',
        email: '',
        createdAt: null,
      );

  String get fullName => '$firstName $lastName'.trim();

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      vendorId: json['vendor_id'] as int?,
      phoneNumber: json['phone_number'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      cnic: json['cnic'] as String,
      email: json['email'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson({bool isUpdate = false}) {
    final data = <String, dynamic>{
      'phone_number': phoneNumber,
      'first_name': firstName,
      'last_name': lastName,
      'cnic': cnic,
      'email': email,
    };
    if (!isUpdate && vendorId != null) {
      data['vendor_id'] = vendorId;
    }
    return data;
  }
}
