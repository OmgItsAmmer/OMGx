import 'package:ecommerce_dashboard/Models/address/address_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../common/widgets/loaders/tloaders.dart';
import '../../repositories/address/address_repository.dart';
import '../../utils/constants/enums.dart';

class AddressController extends GetxController {
  static AddressController get instance => Get.find();
  // final userController = Get.put(UserController());
  final addressRepository = Get.put(AddressRepository());

  RxList<AddressModel> allAddresses = <AddressModel>[].obs;
  RxList<AddressModel> allCustomerAddresses = <AddressModel>[].obs;
  RxList<AddressModel> allSalesmanAddresses = <AddressModel>[].obs;
  RxList<AddressModel> allVendorAddresses = <AddressModel>[].obs;
  RxList<AddressModel> currentAddresses = <AddressModel>[].obs;

  // only locations for dopdown
  // RxList<AddressModel> allAddresses = <AddressModel>[].obs;
  RxList<String> allCustomerAddressesLocation = <String>[].obs;
  RxList<String> allVendorAddressesLocation = <String>[].obs;
  // RxList<AddressModel> allSalesmanAddresses = <AddressModel>[].obs;

  //Current user addresses
  Rx<AddressModel>? currentUserAddress;
  Rx<AddressModel> selectedCustomerAddress = AddressModel.empty().obs;
  Rx<AddressModel> selectedVendorAddress = AddressModel.empty().obs;
  Rx<AddressModel>? currentSalesmanAddress;

  RxMap<String, dynamic>? selectedAddress;
  RxInt selectedIndex = (-1).obs;

  final isLoading = false.obs; // Indicates whether a loading process is active

  final address = TextEditingController();
  final postalCode = TextEditingController(text: '62350'); // Default postal code

  Future<void> fetchEntityAddresses(int entityId, EntityType entityType) async {
    try {
      isLoading.value = true;
      allCustomerAddresses.clear();
      allCustomerAddressesLocation.clear();

      //   final entityName = entityType.toString().split('.').last;

      switch (entityType) {
        case EntityType.customer:
          final customerAddress = await addressRepository
              .fetchAddressTableForSpecificEntity(entityId, entityType);
          allCustomerAddresses.assignAll(customerAddress);

          final locations = allCustomerAddresses
              .map((address) => address.shippingAddress)
              .whereType<String>()
              .toList();
          allCustomerAddressesLocation.assignAll(locations);
          break;

        case EntityType.salesman:
          final salesmanAddress = await addressRepository
              .fetchAddressTableForSpecificEntity(entityId, entityType);
          allSalesmanAddresses.assignAll(salesmanAddress);
          break;

        case EntityType.vendor:
          final vendorAddress = await addressRepository
              .fetchAddressTableForSpecificEntity(entityId, entityType);
          allVendorAddresses.assignAll(vendorAddress);

          final locations = allVendorAddresses
              .map((address) => address.shippingAddress)
              .whereType<String>()
              .toList();
          allVendorAddressesLocation.assignAll(locations);
          break;

        case EntityType.user:
          break;
      }
    } catch (e) {
      if (kDebugMode) {
        TLoaders.errorSnackBar(title: e.toString());
        print(e);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveAddress(AddressModel addressModel, EntityType entityType ) async {
    try {
      // Trim address text to match database constraint
      final trimmedAddress = address.text.trim();
      final trimmedPostalCode = postalCode.text.trim().isEmpty ? '62350' : postalCode.text.trim();
      final trimmedFullName = addressModel.fullName?.trim() ?? '';
      final trimmedCity = addressModel.city?.trim() ?? '';
      final trimmedCountry = addressModel.country?.trim() ?? '';

      switch (entityType) {
        case EntityType.customer:
          addressModel =
              AddressModel(shippingAddress: trimmedAddress, customerId: addressModel.customerId , postalCode: trimmedPostalCode , city: trimmedCity , country: trimmedCountry , fullName: trimmedFullName , phoneNumber: addressModel.phoneNumber , userId: addressModel.userId , vendorId: addressModel.vendorId , salesmanId: addressModel.salesmanId );
          break;

        case EntityType.salesman:
          addressModel =
              AddressModel(shippingAddress: trimmedAddress, salesmanId: addressModel.salesmanId , postalCode: trimmedPostalCode , city: trimmedCity , country: trimmedCountry , fullName: trimmedFullName , phoneNumber: addressModel.phoneNumber , userId: addressModel.userId , vendorId: addressModel.vendorId , customerId: addressModel.customerId );
          break;

        case EntityType.vendor:
          addressModel =
              AddressModel(shippingAddress: trimmedAddress, vendorId: addressModel.vendorId , postalCode: trimmedPostalCode , city: trimmedCity , country: trimmedCountry , fullName: trimmedFullName , phoneNumber: addressModel.phoneNumber , userId: addressModel.userId , salesmanId: addressModel.salesmanId , customerId: addressModel.customerId );
          break;

        case EntityType.user:
          break;
      }

      final json = addressModel.toJson(isInsert: true);
      await addressRepository.updateAddressTable(json);
    } catch (e) {
      if (kDebugMode) {
        TLoaders.errorSnackBar(title: e.toString());
        print(e);
      }
    }
  }
}
