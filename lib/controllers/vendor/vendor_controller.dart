import 'package:admin_dashboard_v3/Models/address/address_model.dart';
import 'package:admin_dashboard_v3/controllers/address/address_controller.dart';
import 'package:admin_dashboard_v3/controllers/media/media_controller.dart';
import 'package:admin_dashboard_v3/repositories/vendor/vendor_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../Models/vendor/vendor_model.dart';
import '../../common/widgets/loaders/tloaders.dart';
import '../../utils/constants/enums.dart';
import '../../routes/routes.dart';

class VendorController extends GetxController {
  static VendorController get instance => Get.find();

  final VendorRepository vendorRepository = Get.put(VendorRepository());
  final MediaController mediaController = Get.put(MediaController());
  final AddressController addressController = Get.put(AddressController());

  final profileLoading = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isUpdating = false.obs;
  RxList<VendorModel> allVendors = <VendorModel>[].obs;
  RxList<String> allVendorNames = <String>[].obs;
  Rx<VendorModel> selectedVendor = VendorModel.empty().obs;

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final cnic = TextEditingController();
  final phoneNumber = TextEditingController();
  final address = TextEditingController();
  
  int? vendorId;
  final addVendorKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchAllVendors();
  }

  Future<void> fetchAllVendors() async {
    try {
      final vendors = await vendorRepository.fetchAllVendors();
      allVendors.assignAll(vendors);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  Future<void> refreshVendors() async {
    try {
      isLoading.value = true;
      await fetchAllVendors();
      TLoaders.successSnackBar(
        title: 'Refreshed!',
        message: 'Vendor list has been updated.',
      );
    } catch (e) {
      if (kDebugMode) print('Error refreshing vendors: $e');
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to refresh vendors: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateVendor(int id) async {
    try {
      isUpdating.value = true;
      if (!addVendorKey.currentState!.validate()) {
        TLoaders.errorSnackBar(
          title: 'Empty Fields',
          message: 'Kindly fill all fields before proceeding.',
        );
        return;
      }
      final vendor = VendorModel(
        vendorId: id,
        firstName: firstName.text,
        lastName: lastName.text,
        phoneNumber: phoneNumber.text,
        email: email.text,
        cnic: cnic.text,
        createdAt: null,
      );
      final json = vendor.toJson(isUpdate: false);
      await vendorRepository.updateVendor(json);
      await mediaController.imageAssigner(
          id, MediaCategory.shop.toString().split('.').last, true);
      await AddressController.instance.saveAddress(id, EntityType.vendor);
      cleanVendorDetails();
      TLoaders.successSnackBar(
        title: 'Vendor Updated!',
        message: '${firstName.text} updated successfully.',
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> insertVendor() async {
    try {
      isUpdating.value = true;
      if (!addVendorKey.currentState!.validate()) {
        TLoaders.errorSnackBar(
          title: 'Empty Fields',
          message: 'Kindly fill all fields before proceeding.',
        );
        return;
      }
      final vendor = VendorModel(
        firstName: firstName.text,
        lastName: lastName.text,
        phoneNumber: phoneNumber.text,
        email: email.text,
        cnic: cnic.text,
        createdAt: null,
      );
      final json = vendor.toJson(isUpdate: true);
      final newId = await vendorRepository.insertVendorInTable(json);
      await mediaController.imageAssigner(
          newId, MediaCategory.shop.toString().split('.').last, true);
      await AddressController.instance.saveAddress(newId, EntityType.vendor);

      // Locally adding to table
      allVendors.add(vendor);
      if (kDebugMode) {
        print('New vendor added. Total vendors: ${allVendors.length}');
      }
      vendor.vendorId = newId;
      cleanVendorDetails();
      TLoaders.successSnackBar(
        title: 'Vendor Added!',
        message: '${firstName.text} added successfully.',
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isUpdating.value = false;
    }
  }

  void cleanVendorDetails() {
    try {
      firstName.clear();
      lastName.clear();
      email.clear();
      cnic.clear();
      phoneNumber.clear();
      AddressController.instance.address.clear();
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  void setVendorDetail(VendorModel vendor) {
    try {
      vendorId = vendor.vendorId!;
      firstName.text = vendor.firstName;
      lastName.text = vendor.lastName;
      email.text = vendor.email;
      cnic.text = vendor.cnic.toString();
      phoneNumber.text = vendor.phoneNumber.toString();
      final matchingAddress =
          AddressController.instance.allVendorAddresses.firstWhere(
        (address) => address.vendorId == vendor.vendorId,
        orElse: () => AddressModel
            .empty(), // Return empty if no matching address is found
      );

      // Set the address text if a match is found
      AddressController.instance.address.text = matchingAddress.location ??
          ''; // Assuming `location` is the property holding the address as a String
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  void fetchVendorInfo(int vendorId) {
    try {
      // Set loading state to true
      isLoading.value = true;

      // Fetch vendor data based on vendorId
      final vendorData = allVendors.firstWhere(
        (vendor) => vendor.vendorId == vendorId,
        orElse: () => VendorModel.empty(), // Fallback if no vendor is found
      );

      // If vendor data is found, process it
      if (vendorData != VendorModel.empty()) {
        selectedVendor.value = vendorData;
      } else {
        TLoaders.warningSnackBar(
            title: 'Not Found', message: 'No vendor found for the given ID.');
      }
    } catch (e) {
      // Handle errors
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      // Set loading state to false
      isLoading.value = false;
    }
  }

  Future<void> prepareVendorDetails(dynamic vendorId) async {
    try {
      // Loading state
      isLoading.value = true;

      // Find vendor by ID
      final vendorData = allVendors.firstWhere(
        (vendor) => vendor.vendorId == vendorId,
        orElse: () => VendorModel.empty(),
      );

      // Set as selected vendor
      if (vendorData != VendorModel.empty()) {
        selectedVendor.value = vendorData;
      } else {
        TLoaders.errorSnackBar(title: 'Error', message: 'Vendor not found');
        return;
      }

      // Fetch related data
      await Get.find<AddressController>()
          .fetchEntityAddresses(vendorId, EntityType.vendor);

      // Navigate to details screen with vendor model as argument
      Get.toNamed(TRoutes.vendorDetails, arguments: vendorData);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteVendor(int id) async {
    try {
      await vendorRepository.deleteVendorFromTable(id);
      final removedVendor = allVendors.firstWhere(
        (v) => v.vendorId == id,
        orElse: () => VendorModel.empty(),
      );
      if (removedVendor.vendorId == null) throw Exception('Vendor not found');
      allVendors.removeWhere((v) => v.vendorId == id);
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting vendor: $e');
      }
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }
}
