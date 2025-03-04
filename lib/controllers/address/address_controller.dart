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

  Future<void> fetchCustomerAddresses(int customerId) async {
    try {
      if (kDebugMode) {
        print(customerId);
      }
      isLoading.value = true;
      allCustomerAddresses.clear();
      allCustomerAddressesLocation.clear();
      final customerAddress = await addressRepository
          .fetchAddressTableForSpecificCustomer(customerId);
      allCustomerAddresses.assignAll(customerAddress);
      final locations = allCustomerAddresses
          .map((address) => address.location)
          .whereType<String>() // This removes null values
          .toList();

      allCustomerAddressesLocation.assignAll(locations);

      if (kDebugMode) {
        print(allCustomerAddresses[0].location);
      }
    } catch (e) {
      if (kDebugMode) {
        TLoader.errorSnackBar(title: e.toString()); //TODO remove it
        print(e);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveAddress(int entitiyId,String entityName) async {
    try {
      AddressModel addressModel = AddressModel.empty();
     if(entityName == 'Customer'){
        addressModel = AddressModel(
          // addressId: 0,
           location: address.text,
           customerId: entitiyId,
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
             userId: entitiyId,
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
           salesmanId: entitiyId,
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
