import 'package:admin_dashboard_v3/repositories/salesman/salesman_repository.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../Models/salesman/salesman_model.dart';
import '../../common/widgets/loaders/tloaders.dart';
import '../address/address_controller.dart';
import '../media/media_controller.dart';

class SalesmanController extends GetxController {
  static SalesmanController get instance => Get.find();
  final  SalesmanRepository salesmanRepository = Get.put(SalesmanRepository());
  final AddressController addressController = Get.put(AddressController());
  final MediaController mediaController = Get.put(MediaController());





  final profileLoading = false.obs;
  final isLoading = false.obs;
  final isUpdating = false.obs;

  RxList<SalesmanModel> allSalesman = <SalesmanModel>[].obs;
  RxList<String> allSalesmanNames = <String>[].obs;

  Rx<SalesmanModel>? selectedSalesman = SalesmanModel.empty().obs;


  //Add Customer
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final cnic = TextEditingController();
  final phoneNumber = TextEditingController();
  final commission = TextEditingController();
  final area = TextEditingController();
  final city = TextEditingController();
  RxInt entityId = (-1).obs;
  GlobalKey<FormState> addSalesmanKey =
  GlobalKey<FormState>();

  RxInt salesmanId = (-1).obs;





  @override
  void onInit() {
    super.onInit();

    fetchAllSalesman();
  }



  Future<void> fetchAllSalesman() async {
    try {

      final salesman = await salesmanRepository.fetchAllSalesman();
      allSalesman.assignAll(salesman);

      //filter names
      final names = allSalesman.map((user) => user.fullName).toList();
      allSalesmanNames.assignAll(names);

      if (kDebugMode) {
        print(allSalesmanNames);
      }


    } catch (e) {
      TLoader.errorSnackBar(title: "Oh Snap!", message: e.toString());
    }
  }

  void cleanSalesmanDetails() {
    try {
      firstName.clear();
      lastName.clear();
      email.clear();
      cnic.clear();
      phoneNumber.clear();
      city.clear();
      area.clear();
      commission.clear();
      //AddressController.instance.address.clear();
    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
  void setSalesmanDetail(SalesmanModel salesman) {
    try {

      salesmanId.value = salesman.salesmanId!;
      firstName.text = salesman.firstName ;
      lastName.text = salesman.lastName ;
      email.text = salesman.email ;
      cnic.text = salesman.cnic.toString();
      commission.text = salesman.comission.toString();
      phoneNumber.text = salesman.phoneNumber.toString();
      area.text = salesman.area;
      city.text = salesman.city;
      // final matchingAddress = AddressController.instance.allSalesmanAddresses.firstWhere(
      //       (address) => address.salesmanId == salesman.salesmanId,
      //   orElse: () => AddressModel.empty(), // Return null if no matching address is found
      // );

      // Set the address text if a match is found
      //AddressController.instance.address.text = matchingAddress.location ?? ''; // Assuming `addressText` is the property holding the address as a String




    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }


  Future<void> saveOrUpdateSalesman(int salesmanId) async {
    try {
      // Validate the form
      if (!addSalesmanKey.currentState!.validate()) {
        TLoader.errorSnackBar(
          title: "Empty Fields",
          message: 'Kindly fill all the fields before proceeding.',
        );
        return;
      }



      final salesmanModel = SalesmanModel(
        salesmanId: salesmanId, //not uploading
        firstName: firstName.text ,
        lastName: lastName.text,
        phoneNumber: phoneNumber.text,
        email: email.text,
        cnic: cnic.text,
        area: area.text,
        city: city.text
      );
      final json = salesmanModel.toJson();


      // Call the repository function to save or update the product
      int entityId = await salesmanRepository.saveOrUpdateSalesmanRepo(json) ?? -1;
      //Update Image Table
      if(entityId != -1   )
      {
        mediaController.imageAssigner(entityId, MediaCategory.salesman.toString().split('.').last, true);

        salesmanModel.salesmanId = entityId;

        await AddressController.instance.saveAddress(entityId, 'Salesman');
        allSalesman.add(salesmanModel);
        allSalesmanNames.add(salesmanModel.fullName);
      }
      else
      {
        TLoader.errorSnackBar(title: 'Cant Upload Image',message: 'Entity Id is negative');
      }




      // Clear the form after saving/updating
      cleanSalesmanDetails();


    } catch (e) {
      // Handle errors
      TLoader.errorSnackBar(
        title: "Error",
        message: e.toString(),
      );
    }
  }
  void fetchSalesmanInfo(int salesmanId) {
    try {
      // Set loading state to true
      isLoading.value = true;

      // Fetch salesman data based on salesmanId
      final salesmanData = allSalesman.firstWhere(
            (salesman) => salesman.salesmanId == salesmanId,
        orElse: () => SalesmanModel.empty(), // Fallback if no salesman is found
      );

      // If salesman data is found, process it
      if (salesmanData != SalesmanModel.empty()) {
        selectedSalesman?.value = salesmanData;
        print(salesmanData);
        print(selectedSalesman?.value);
      } else {
        TLoader.warningSnackBar(
          title: 'Not Found',
          message: 'No salesman found for the given ID.',
        );
      }
    } catch (e) {
      // Handle errors
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      // Set loading state to false
      isLoading.value = false;
    }
  }

  Future<void> insertSalesman() async {
    try {
      isUpdating.value = true;

      // Validate the form
      if (!addSalesmanKey.currentState!.validate()) {
        TLoader.errorSnackBar(
          title: "Empty Fields",
          message: 'Kindly fill all the fields before proceeding.',
        );
        return;
      }

      // Create the SalesmanModel
      final salesmanModel = SalesmanModel(
        salesmanId: null, // Will be auto-generated by DB
        firstName: firstName.text,
        lastName: lastName.text,
        phoneNumber: phoneNumber.text,
        email: email.text,
        cnic: cnic.text,
        area: area.text,
        city: city.text,
      );

      final json = salesmanModel.toJson(isUpdate: true); // exclude ID & createdAt

      // Insert into DB
      final salesmanId = await salesmanRepository.insertSalesmanInTable(json);

      // Assign image to this salesman (optional logic like customer)
      await mediaController.imageAssigner(
        salesmanId,
        MediaCategory.salesman.toString().split('.').last,
        true,
      );

      // Save address for the salesman
      await AddressController.instance.saveAddress(salesmanId, 'Salesman');

      // Add to local lists if needed
      allSalesman.add(salesmanModel);
      allSalesmanNames.add(salesmanModel.fullName);

      // Assign the generated ID
      salesmanModel.salesmanId = salesmanId;

      // Clear the form
      cleanSalesmanDetails();

      TLoader.successSnackBar(
        title: 'Salesman Added!',
        message: '${firstName.text} added to Database',
      );
    } catch (e) {
      TLoader.errorSnackBar(
        title: "Error",
        message: e.toString(),
      );
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> updateSalesman(int salesmanId) async {
    try {
      isUpdating.value = true;

      // Validate the form
      if (!addSalesmanKey.currentState!.validate()) {
        TLoader.errorSnackBar(
          title: "Empty Fields",
          message: 'Kindly fill all the fields before proceeding.',
        );
        return;
      }

      // Build updated SalesmanModel
      final updatedSalesman = SalesmanModel(
        salesmanId: salesmanId,
        firstName: firstName.text,
        lastName: lastName.text,
        phoneNumber: phoneNumber.text,
        email: email.text,
        cnic: cnic.text,
        area: area.text,
        city: city.text,
      );

      final json = updatedSalesman.toJson(isUpdate: false);

      // Update in DB
      await salesmanRepository.updateSalesman(json);

      // Image update if needed
      await mediaController.imageAssigner(
        salesmanId,
        MediaCategory.salesman.toString().split('.').last,
        true,
      );

      // Address update
      await AddressController.instance.saveAddress(salesmanId, 'Salesman');

      // ✅ Update locally in observable list
      int index = allSalesman.indexWhere((s) => s.salesmanId == salesmanId);
      if (index != -1) {
        allSalesman[index] = updatedSalesman;
      }

      // ✅ Update fullName list too if you have a display list
      int nameIndex = allSalesmanNames.indexWhere((name) =>
      name == allSalesman[index].fullName);
      if (nameIndex != -1) {
        allSalesmanNames[nameIndex] = updatedSalesman.fullName;
      }

      // Clear fields
      cleanSalesmanDetails();

      TLoader.successSnackBar(
        title: 'Salesman Updated!',
        message: '${firstName.text} updated in Database',
      );
    } catch (e) {
      TLoader.errorSnackBar(
        title: "Error",
        message: e.toString(),
      );
    } finally {
      isUpdating.value = false;
    }
  }


  Future<void> deleteSalesman(int salesmanId) async {
    try {
      // Call the repository function to delete from the database
      await salesmanRepository.deleteSalesmanFromTable(salesmanId);

      // Find the salesman in the list to fetch the name
      final salesmanToRemove = allSalesman.firstWhere(
            (salesman) => salesman.salesmanId == salesmanId,
        orElse: () => SalesmanModel.empty(), // Default if not found
      );

      if (salesmanToRemove.salesmanId == -1) {
        throw Exception("Salesman not found in the list");
      }

      // Remove from observable lists
      allSalesman.removeWhere((salesman) => salesman.salesmanId == salesmanId);
      allSalesmanNames.removeWhere((name) => name == salesmanToRemove.fullName);

      TLoader.successSnackBar(
        title: 'Deleted!',
        message: '${salesmanToRemove.fullName} removed from database.',
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting salesman: $e");
      }
      TLoader.errorSnackBar(
        title: 'Error',
        message: e.toString(),
      );
    }
  }
}


