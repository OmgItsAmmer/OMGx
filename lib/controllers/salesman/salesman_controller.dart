

import 'package:admin_dashboard_v3/repositories/customer/customer_repository.dart';
import 'package:admin_dashboard_v3/repositories/salesman/salesman_repository.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';


import '../../Models/address/address_model.dart';
import '../../Models/customer/customer_model.dart';
import '../../Models/salesman/salesman_model.dart';
import '../../common/widgets/loaders/tloaders.dart';
import '../address/address_controller.dart';
import '../media/media_controller.dart';
import '../product/product_images_controller.dart';

class SalesmanController extends GetxController {
  static SalesmanController get instance => Get.find();
  final  SalesmanRepository salesmanRepository = Get.put(SalesmanRepository());
  final AddressController addressController = Get.put(AddressController());
  final MediaController mediaController = Get.put(MediaController());
  final ProductImagesController productImagesController = Get.put(ProductImagesController());




  final profileLoading = false.obs;

  RxList<SalesmanModel> allSalesman = <SalesmanModel>[].obs;
  RxList<String> allSalesmanNames = <String>[].obs;

  Rx<SalesmanModel>? selectedSalesman;


  //Add Customer
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final cnic = TextEditingController();
  final phoneNumber = TextEditingController();
  final commission = TextEditingController();
  final area = TextEditingController();
  final city = TextEditingController();
  GlobalKey<FormState> addSalesmanKey =
  GlobalKey<FormState>();





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


  Future<void> saveOrUpdateSalesman() async {
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
        salesmanId: -1, //not uploading
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
        salesmanModel.salesmanId = entityId;
        if(productImagesController.selectedImage.value != null){
          await mediaController.updateEntityId(entityId, productImagesController.selectedImage.value!.image_id,MediaCategory.salesman.toString().split('.').last);
        }
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
      Get.back();
      TLoader.successSnackBar(title: 'Customer Added!');
    } catch (e) {
      // Handle errors
      TLoader.errorSnackBar(
        title: "Error",
        message: e.toString(),
      );
    }
  }
  // Future<void> deleteCustomer(int customerId) async {
  //   try {
  //
  //
  //     // Call the repository function to delete from the database
  //     await customerRepository.deleteCustomerFromTable(customerId);
  //
  //     // Find the customer in allCustomers to get the name
  //     final customerToRemove = allCustomers.firstWhere(
  //           (customer) => customer.customerId == customerId,
  //       orElse: () => CustomerModel.empty(), // Default to avoid error
  //     );
  //
  //     if (customerToRemove.customerId == -1) {
  //       throw Exception("Customer not found in the list");
  //     }
  //
  //     // Remove customer from lists
  //     allCustomers.removeWhere((customer) => customer.customerId == customerId);
  //     allCustomerNames.removeWhere((name) => name == customerToRemove.firstName);
  //
  //
  //
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print("Error deleting customer: $e");
  //       TLoader.errorSnackBar(title: 'Error', message: e.toString());
  //     }
  //   }
  // }





}


