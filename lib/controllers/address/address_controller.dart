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
              .map((address) => address.location)
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
              .map((address) => address.location)
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

  Future<void> saveAddress(int entityId, EntityType entityType) async {
    try {
      //   final entityName = entityType.toString().split('.').last;
      AddressModel addressModel = AddressModel.empty();

      switch (entityType) {
        case EntityType.customer:
          addressModel =
              AddressModel(location: address.text, customerId: entityId);
          break;

        case EntityType.salesman:
          addressModel =
              AddressModel(location: address.text, salesmanId: entityId);
          break;

        case EntityType.vendor:
          addressModel =
              AddressModel(location: address.text, vendorId: entityId);
          break;

        case EntityType.user:
          break;
      }

      final json = addressModel.toJson(isUpdate: true);
      await addressRepository.updateAddressTable(json);
    } catch (e) {
      if (kDebugMode) {
        TLoaders.errorSnackBar(title: e.toString());
        print(e);
      }
    }
  }
}
