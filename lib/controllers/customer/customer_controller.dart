

import 'package:admin_dashboard_v3/controllers/address/address_controller.dart';
import 'package:admin_dashboard_v3/controllers/media/media_controller.dart';
import 'package:admin_dashboard_v3/repositories/customer/customer_repository.dart';
import 'package:admin_dashboard_v3/repositories/media/media_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';


import '../../Models/customer/customer_model.dart';
import '../../common/widgets/loaders/tloaders.dart';
import '../product/product_images_controller.dart';

class CustomerController extends GetxController {
  static CustomerController get instance => Get.find();
  final CustomerRepository customerRepository = Get.put(CustomerRepository());
  final MediaController mediaController = Get.put(MediaController());
  final ProductImagesController productImagesController = Get.put(ProductImagesController());
  final AddressController addressController = Get.put(AddressController());
 // final AddressController addressController = Get.find<AddressController>();




  final profileLoading = false.obs;

  RxList<CustomerModel> allCustomers = <CustomerModel>[].obs;
  RxList<String> allCustomerNames = <String>[].obs;

  Rx<CustomerModel> selectedCustomer = CustomerModel.empty().obs;


  //Add Customer
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final cnic = TextEditingController();
  final phoneNumber = TextEditingController();
  GlobalKey<FormState> addCustomerKey =
  GlobalKey<FormState>();
  // final alertStock = TextEditingController();
  // final brandName = TextEditingController();






  @override
  void onInit() {
    super.onInit();

    fetchAllCustomers();
  }



  Future<void> fetchAllCustomers() async {
    try {

      final customers = await customerRepository.fetchAllCustomers();
      allCustomers.assignAll(customers);

      //filter names
      final names = allCustomers.map((user) => user.fullName).toList();
      allCustomerNames.assignAll(names);
     // print(allCustomerNames);


    } catch (e) {
      TLoader.errorSnackBar(title: "Oh Snap!", message: e.toString());
    }
  }



  Future<void> saveOrUpdateCustomer() async {
    try {
      // Validate the form
      if (!addCustomerKey.currentState!.validate()) {
        TLoader.errorSnackBar(
          title: "Empty Fields",
          message: 'Kindly fill all the fields before proceeding.',
        );
        return;
      }



      final customerModel = CustomerModel(
        customerId: -1, //not uploading
        firstName: firstName.text ,
        lastName: lastName.text,
        phoneNumber: phoneNumber.text,
        email: email.text,
        cnic: cnic.text,


      );
      final json = customerModel.toJson();



      // Call the repository function to save or update the product
      int entityId = await customerRepository.saveOrUpdateCustomerRepo(json) ?? -1;
      //Update Image Table
      if(entityId != -1)
      {
        customerModel.customerId = entityId;
        await mediaController.updateEntityId(entityId, productImagesController.selectedImage.value!.image_id);
        await AddressController.instance.saveAddress(entityId, 'Customer');
        allCustomers.add(customerModel);
        allCustomerNames.add(customerModel.fullName);
      }
      else
        {
          TLoader.errorSnackBar(title: 'Cant Upload Image',message: 'Entity Id is negative');
        }




      // Clear the form after saving/updating
      cleanCustomerDetails();
    } catch (e) {
      // Handle errors
      TLoader.errorSnackBar(
        title: "Error",
        message: e.toString(),
      );
    }
  }

  void cleanCustomerDetails() {
    try {
     firstName.clear();
     lastName.clear();
     email.clear();
     cnic.clear();
     phoneNumber.clear();
     AddressController.instance.address.clear();
    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
  void setCustomerDetail(CustomerModel customer) {
    try {
      firstName.text = customer.firstName ;
      lastName.text = customer.lastName ;
      email.text = customer.email ;
      cnic.text = customer.cnic.toString();
      phoneNumber.text = customer.phoneNumber.toString();



    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }




}


