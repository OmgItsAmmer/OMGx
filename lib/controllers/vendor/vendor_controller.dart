import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:admin_dashboard_v3/repositories/vendor/vendor_repository.dart';
import '../../Models/vendor/vendor_model.dart';
import '../../common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/controllers/media/media_controller.dart';

class VendorController extends GetxController {
  static VendorController get instance => Get.find();

  final VendorRepository vendorRepository = Get.put(VendorRepository());
  final MediaController mediaController = Get.put(MediaController());

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
      await mediaController.imageAssigner(id, 'vendors', true);
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
      await mediaController.imageAssigner(newId, 'vendors', true);
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
    firstName.clear();
    lastName.clear();
    email.clear();
    cnic.clear();
    phoneNumber.clear();
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
