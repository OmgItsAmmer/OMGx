import 'package:admin_dashboard_v3/Models/customer/customer_model.dart';
import 'package:admin_dashboard_v3/Models/salesman/salesman_model.dart';
import 'package:admin_dashboard_v3/Models/vendor/vendor_model.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';

class EntityModel {
  final int? id;
  final String name;
  final EntityType type;
  final String? email;
  final String? phoneNumber;
  final String? cnic;
  final dynamic additionalData; // For type-specific fields

  EntityModel({
    this.id,
    required this.name,
    required this.type,
    this.email,
    this.phoneNumber,
    this.cnic,
    this.additionalData,
  });

  // Factory method to create an EntityModel from a CustomerModel
  factory EntityModel.fromCustomer(CustomerModel customer) {
    return EntityModel(
      id: customer.customerId,
      name: customer.fullName,
      type: EntityType.customer,
      email: customer.email,
      phoneNumber: customer.phoneNumber,
      cnic: customer.cnic,
      additionalData: customer,
    );
  }

  // Factory method to create an EntityModel from a SalesmanModel
  factory EntityModel.fromSalesman(SalesmanModel salesman) {
    return EntityModel(
      id: salesman.salesmanId,
      name: salesman.fullName,
      type: EntityType.salesman,
      email: salesman.email,
      phoneNumber: salesman.phoneNumber,
      cnic: salesman.cnic,
      additionalData: salesman,
    );
  }

  // Factory method to create an EntityModel from a VendorModel
  factory EntityModel.fromVendor(VendorModel vendor) {
    return EntityModel(
      id: vendor.vendorId,
      name: vendor.fullName,
      type: EntityType.vendor,
      email: vendor.email,
      phoneNumber: vendor.phoneNumber,
      cnic: vendor.cnic,
      additionalData: vendor,
    );
  }

  // Static method to create an empty EntityModel
  static EntityModel empty() => EntityModel(
        id: null,
        name: '',
        type: EntityType.customer, // Default type
      );

  // Convert model to JSON for database insertion or API calls
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString().split('.').last,
      'email': email,
      'phone_number': phoneNumber,
      'cnic': cnic,
      'additional_data': additionalData?.toJson(),
    };
  }

  // Factory method to create an EntityModel from a JSON object
  factory EntityModel.fromJson(Map<String, dynamic> json) {
    final type = EntityType.values.firstWhere(
      (e) => e.toString().split('.').last == json['type'],
      orElse: () => EntityType.customer,
    );

    return EntityModel(
      id: json['id'] as int?,
      name: json['name'] as String,
      type: type,
      email: json['email'] as String?,
      phoneNumber: json['phone_number'] as String?,
      cnic: json['cnic'] as String?,
      additionalData: json['additional_data'],
    );
  }
}
