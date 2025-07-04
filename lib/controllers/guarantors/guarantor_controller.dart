import 'package:ecommerce_dashboard/Models/guarantors/guarantors_model.dart';
import 'package:ecommerce_dashboard/Models/image/image_model.dart';
import 'package:ecommerce_dashboard/common/widgets/loaders/tloaders.dart';
import 'package:ecommerce_dashboard/repositories/guarantors/guarantor_repository.dart';
import 'package:ecommerce_dashboard/repositories/installment/installment_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../installments/installments_controller.dart';

class GuarantorController extends GetxController {
  static GuarantorController get instance => Get.find();
  final GuarantorRepository guarantorRepository =
      Get.put(GuarantorRepository());
  final InstallmentRepository installmentRepository =
      Get.find<InstallmentRepository>(); //TODO rule destroyed

  //Guarantor 1 Info
  final guraante1Name = TextEditingController();
  final guraante1PhoneNo = TextEditingController();
  final guraante1Address = TextEditingController();
  final guraante1CNIC = TextEditingController();
  GlobalKey<FormState> guraante1FormKey =
      GlobalKey<FormState>(); // Form key for form validation

  //Guarantor  2 Info
  final guraante2Name = TextEditingController();
  final guraante2PhoneNo = TextEditingController();
  final guraante2Address = TextEditingController();
  final guraante2CNIC = TextEditingController();
  GlobalKey<FormState> guraante2FormKey =
      GlobalKey<FormState>(); // Form key for form validation

  //OrderDetails
  final RxList<GuarantorsModel> selectedGuarantors = <GuarantorsModel>[].obs;
  Rx<ImageModel?> guarrantor1Image = Rx<ImageModel?>(null);
  Rx<ImageModel?> guarrantor2Image = Rx<ImageModel?>(null);

  Future<void> fetchGuarantors(int orderId) async {
    try {
      final planId = await installmentRepository.fetchPlanId(orderId);

      final list =
          await guarantorRepository.fetchSpecificOrderGuarantors(planId ?? -1);

      if (list.isNotEmpty) {
        // If the fetched list has data, assign it to selectedGuarantors
        selectedGuarantors.assignAll(list);
      } else {
        // If the fetched list is empty, reset selectedGuarantors to two empty models
        selectedGuarantors
            .assignAll([GuarantorsModel.empty(), GuarantorsModel.empty()]);
      }
      if (kDebugMode) {
        print('Selected Guarantors Length: ${selectedGuarantors.length}');
        print('Selected Guarantors: ${selectedGuarantors.toString()}');
      }

      if (kDebugMode) {
        print(selectedGuarantors);
      }
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Oh Snap! Guarantors!!',
        message: e.toString(),
      );
    }
  }

  Future<List<int>> uploadGuarantors() async {
    try {
      // Validate Form
      if ((!guraante1FormKey.currentState!.validate() &&
          !guraante2FormKey.currentState!.validate())) {
        TLoaders.errorSnackBar(
            title: "Guarantee Form Empty",
            message: 'Kindly fill all the Text fields before proceed');
        return [];
      }

      // Splitting fullname into two parts
      String fullName1 = guraante1Name.text.trim();
      List<String> nameParts1 = fullName1.split(' ');

      String firstName1 = nameParts1.isNotEmpty ? nameParts1.first : "";
      String lastName1 =
          nameParts1.length > 1 ? nameParts1.sublist(1).join(' ') : "";

      String fullName2 = guraante2Name.text.trim();
      List<String> nameParts2 = fullName2.split(' ');

      String firstName2 = nameParts2.isNotEmpty ? nameParts2.first : "";
      String lastName2 =
          nameParts2.length > 1 ? nameParts2.sublist(1).join(' ') : "";

      // Create GuarantorsModel objects
      GuarantorsModel guarantor1 = GuarantorsModel(
        guarantorId: -1, // This will be ignored during upload
        firstName: firstName1,
        lastName: lastName1,
        phoneNumber: guraante1PhoneNo.text,
        cnic: guraante1CNIC.text,
        address: guraante1Address.text,
        email: "",
      );

      GuarantorsModel guarantor2 = GuarantorsModel(
        guarantorId: -1, // This will be ignored during upload
        firstName: firstName2,
        lastName: lastName2,
        phoneNumber: guraante2PhoneNo.text,
        cnic: guraante2CNIC.text,
        address: guraante2Address.text,
        email: "",
      );

      // Upload guarantors
      final ids = await guarantorRepository.uploadGuarantors([
        guarantor1.toJson(isUpdate: true),
        guarantor2.toJson(isUpdate: true)
      ]);

      // Success Message
      return ids;
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Oh Snap! Guarantors!!', message: e.toString());
      return [];
    }
  }

  // Clear all guarantor text fields
  void clearGuarantorFields() {
    // Clear Guarantor 1 fields
    guraante1Name.clear();
    guraante1PhoneNo.clear();
    guraante1Address.clear();
    guraante1CNIC.clear();

    // Clear Guarantor 2 fields
    guraante2Name.clear();
    guraante2PhoneNo.clear();
    guraante2Address.clear();
    guraante2CNIC.clear();
  }
}
