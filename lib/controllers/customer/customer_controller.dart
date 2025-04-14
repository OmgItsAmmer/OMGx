import 'package:admin_dashboard_v3/Models/address/address_model.dart';
import 'package:admin_dashboard_v3/controllers/address/address_controller.dart';
import 'package:admin_dashboard_v3/controllers/media/media_controller.dart';
import 'package:admin_dashboard_v3/repositories/customer/customer_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../Models/customer/customer_model.dart';
import '../../common/widgets/loaders/tloaders.dart';
import '../../utils/constants/enums.dart';
import '../product/product_images_controller.dart';

class CustomerController extends GetxController {
  static CustomerController get instance => Get.find();
  final CustomerRepository customerRepository = Get.put(CustomerRepository());
  final MediaController mediaController = Get.put(MediaController());

  final AddressController addressController = Get.put(AddressController());
 // final AddressController addressController = Get.find<AddressController>();





  final profileLoading = false.obs;
  final isLoading = false.obs;
  final isUpdating = false.obs;
  RxList<CustomerModel> allCustomers = <CustomerModel>[].obs;
 RxList<String> allCustomerNames = <String>[].obs;

  Rx<CustomerModel> selectedCustomer = CustomerModel.empty().obs;


  //Add Customer
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final cnic = TextEditingController();
  final phoneNumber = TextEditingController();
  int customerId = -1;
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
      // final names = allCustomers.map((user) => user.fullName).toList();
      // allCustomerNames.assignAll(names);
     // print(allCustomerNames);


    } catch (e) {
      TLoader.errorSnackBar(title: "Oh Snap!", message: e.toString());
    }
  }

  Future<void> updateCustomer(int customerId) async {
    try {
      // Validate the form
      isUpdating.value = true;
      if (!addCustomerKey.currentState!.validate()) {
        TLoader.errorSnackBar(
          title: "Empty Fields",
          message: 'Kindly fill all the fields before proceeding.',
        );
        return;
      }
      final customerModel = CustomerModel(
        customerId: customerId,
        firstName: firstName.text ,
        lastName: lastName.text,
        phoneNumber: phoneNumber.text,
        email: email.text,
        cnic: cnic.text,);


      final json = customerModel.toJson(isUpdate: false); // we need id for updating


        // Call the repository function to save or update the product
       await customerRepository.updateCustomer(json);

       await mediaController.imageAssigner(customerId, MediaCategory.customers.toString().split('.').last ,true);

        await AddressController.instance.saveAddress(customerId, 'Customer');

      customerModel.customerId = customerId;








      // Clear the form after saving/updating
      cleanCustomerDetails();
      TLoader.successSnackBar(title: 'Customer Added!',message: '${firstName.text} added to Database ');

      // TLoader.successSnackBar(title: 'Customer Added!');
    } catch (e) {
      // Handle errors
      TLoader.errorSnackBar(
        title: "Error",
        message: e.toString(),
      );
    }
    finally {
      isUpdating.value = false;
    }
  }

  Future<void> insertCustomer() async {
    try {
      // Validate the form
      isUpdating.value = true;
      if (!addCustomerKey.currentState!.validate()) {
        TLoader.errorSnackBar(
          title: "Empty Fields",
          message: 'Kindly fill all the fields before proceeding.',
        );
        return;
      }

      final customerModel = CustomerModel(
        customerId: null, //not uploading
        firstName: firstName.text ,
        lastName: lastName.text,
        phoneNumber: phoneNumber.text,
        email: email.text,
        cnic: cnic.text,


      );
      final json = customerModel.toJson(isUpdate: true); // we need id for updating


      // Call the repository function to save or update the product
      final  customerId = await customerRepository.insertCustomerInTable(json);

      await mediaController.imageAssigner(customerId, MediaCategory.customers.toString().split('.').last ,true);

      await AddressController.instance.saveAddress(customerId, 'Customer');
      //locally adding in table
      allCustomers.add(customerModel);
      //allCustomerNames.add(customerModel.fullName);


      customerModel.customerId = customerId; // idk why

      // Clear the form after saving/updating
      cleanCustomerDetails();

      TLoader.successSnackBar(title: 'Customer Added!',message: '${firstName.text} added to Database ');
    } catch (e) {
      // Handle errors
      TLoader.errorSnackBar(
        title: "Error",
        message: e.toString(),
      );
    }
    finally {
      isUpdating.value = false;}
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
      customerId = customer.customerId!;
      firstName.text = customer.firstName ;
      lastName.text = customer.lastName ;
      email.text = customer.email ;
      cnic.text = customer.cnic.toString();
      phoneNumber.text = customer.phoneNumber.toString();
      final matchingAddress = AddressController.instance.allCustomerAddresses.firstWhere(
            (address) => address.customerId == customer.customerId,
        orElse: () => AddressModel.empty(), // Return null if no matching address is found
      );

      // Set the address text if a match is found
      AddressController.instance.address.text = matchingAddress.location ?? ''; // Assuming `addressText` is the property holding the address as a String




    } catch (e) {
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  Future<void> deleteCustomer(int customerId) async {
    try {


      // Call the repository function to delete from the database
      await customerRepository.deleteCustomerFromTable(customerId);

      // Find the customer in allCustomers to get the name
      final customerToRemove = allCustomers.firstWhere(
            (customer) => customer.customerId == customerId,
        orElse: () => CustomerModel.empty(), // Default to avoid error
      );

      if (customerToRemove.customerId == -1) {
        throw Exception("Customer not found in the list");
      }

      // Remove customer from lists
      allCustomers.removeWhere((customer) => customer.customerId == customerId);
      //allCustomerNames.removeWhere((name) => name == customerToRemove.firstName);



    } catch (e) {
      if (kDebugMode) {
        print("Error deleting customer: $e");
        TLoader.errorSnackBar(title: 'Error', message: e.toString());
      }
    }
  }

  void fetchCustomerInfo(int customerId) {
    try {
      // Set loading state to true
      isLoading.value = true;

      // Fetch customer data based on orderId
      final customerData = allCustomers.firstWhere(
            (customer) => customer.customerId == customerId,
        orElse: () => CustomerModel.empty(), // Fallback if no customer is found
      );

      // If customer data is found, process it
      if (customerData != CustomerModel.empty()) {
        selectedCustomer.value = customerData;
      } else {
        TLoader.warningSnackBar(
            title: 'Not Found',
            message: 'No customer found for the given order ID.');
      }
    } catch (e) {
      // Handle errors
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      // Set loading state to false
      isLoading.value = false;
    }
  }




}


