import 'package:admin_dashboard_v3/Models/address/address_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../common/widgets/loaders/tloaders.dart';
import '../../repositories/address/address_repository.dart';

class AddressController extends GetxController {
  static AddressController get instance => Get.find();
  // final userController = Get.put(UserController());
  final addressRepository = Get.put(AddressRepository());

  RxList<AddressModel> allAddresses = <AddressModel>[].obs;
  RxList<AddressModel> allCustomerAddresses = <AddressModel>[].obs;
  RxList<AddressModel> allSalesmanAddresses = <AddressModel>[].obs;
  RxList<AddressModel> currentAddresses = <AddressModel>[].obs;

  // only locations for dopdown
  // RxList<AddressModel> allAddresses = <AddressModel>[].obs;
  RxList<String> allCustomerAddressesLocation = <String>[].obs;
  // RxList<AddressModel> allSalesmanAddresses = <AddressModel>[].obs;

  //Current user addresses
  Rx<AddressModel>? currentUserAddress;
  Rx<AddressModel> selectedCustomerAddress = AddressModel.empty().obs;
  Rx<AddressModel>? currentSalesmanAddress;

  RxMap<String, dynamic>? selectedAddress;
  RxInt selectedIndex = (-1).obs;

  final isLoading = false.obs; // Indicates whether a loading process is active

  final address = TextEditingController();

  Future<void> fetchEntityAddresses(int entityId, String entityName) async {
    try {
      isLoading.value = true;
      allCustomerAddresses.clear();
      allCustomerAddressesLocation.clear();

      if (entityName == 'Customer') {
        // Fetch addresses for Customer
        final customerAddress = await addressRepository
            .fetchAddressTableForSpecificEntity(entityId,entityName);
        allCustomerAddresses.assignAll(customerAddress);

        // Extract locations and filter out null values
        final locations = allCustomerAddresses
            .map((address) => address.location)
            .whereType<String>() // This removes null values
            .toList();

        allCustomerAddressesLocation.assignAll(locations);
      } else if (entityName == 'User') {
        // TODO: Fetch addresses for User
        // Logic will be similar to Customer but tailored for User entity
        // Example:
        // final userAddress = await addressRepository.fetchAddressTableForUser(entityId);
        // allCustomerAddresses.assignAll(userAddress);
        // final locations = allCustomerAddresses.map((address) => address.location).whereType<String>().toList();
        // allCustomerAddressesLocation.assignAll(locations);
      } else if (entityName == 'Salesman') {
        final salesmanAddress = await addressRepository
            .fetchAddressTableForSpecificEntity(entityId,entityName);
        allSalesmanAddresses.assignAll(salesmanAddress);
      } else {
        throw Exception('Invalid entity name: $entityName');
      }
    } catch (e) {
      if (kDebugMode) {
        TLoader.errorSnackBar(title: e.toString()); // TODO: Remove it
        print(e);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveAddress(int entityId,String entityName) async {
    try {
      AddressModel addressModel = AddressModel.empty();
     if(entityName == 'Customer'){
        addressModel = AddressModel(
          // addressId: 0,
           location: address.text,
           customerId: entityId,
           phoneNumber: '',
           street: '',
           postalCode: '',
           city: '',
           state: '',
           country: '');
     }
     else if(entityName == 'User')
       {
         addressModel = AddressModel(
           //  addressId: 0,
             location: address.text,
             userId: entityId,
             phoneNumber: '',
             street: '',
             postalCode: '',
             city: '',
             state: '',
             country: '');
       }
     else if(entityName == 'Salesman'){
       addressModel = AddressModel(
         //  addressId: 0,
           location: address.text,
           salesmanId: entityId,
           phoneNumber: '',
           street: '',
           postalCode: '',
           city: '',
           state: '',
           country: '');

     }

      final json = addressModel.toJson(isUpdate: true);


      await addressRepository.updateAddressTable(json);


    } catch (e) {
      if (kDebugMode) {
        TLoader.errorSnackBar(title: e.toString());
        print(e);
      }
    }
  }

  // void saveAddress() async {
  //
  //   try
  //   {
  //
  //     //Check Internet Connectivity
  //     final isConnected = await NetworkManager.instance.isConnected();
  //     if (!isConnected) {
  //       TLoader.errorSnackBar(title: "Network Issue" , message: "Try again later");
  //       return;
  //     }
  //     //Form validation
  //     if (!addressFormKey.currentState!.validate()) {
  //       TFullScreenLoader.stopLoading();
  //       TLoader.errorSnackBar(title: "Invalid Data");
  //       return;
  //     }
  //
  //     Map<String, dynamic> addressMap = {
  //       'location': location.text,
  //       'street': street.text,
  //       'postal_code': postal_code.text,
  //       'city': city.text,
  //       'state': state.text,
  //       'country': country.text,
  //       'phone_number': phoneNumber.text,
  //       'user_id' : userController.current_user?.value['user_id']
  //     };
  //     addressRepository.updateAddressTable(addressMap);
  //
  //
  //   }
  //   catch(e)
  //   {
  //     TFullScreenLoader.stopLoading();
  //     TLoader.errorsnackBar(title: e.toString());
  //
  //   }
  //
  //
  //
  // }
}
