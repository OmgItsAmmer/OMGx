
import 'package:admin_dashboard_v3/Models/address/address_model.dart';
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






  Future<void> fetchCustomerAddresses(int customerId) async {
    allCustomerAddresses.clear();
    allCustomerAddressesLocation.clear();
    final customerAddress = await addressRepository.fetchAddressTableForSpecificCustomer(customerId);
    allCustomerAddresses.assignAll(customerAddress);
    final locations = allCustomerAddresses.map((address) => address.location).toList();
    allCustomerAddressesLocation.assignAll(locations);
   print(allCustomerAddressesLocation);



    try {

    } catch (e) {
      TLoader.errorsnackBar(title: e.toString()); //TODO remove it
      if (kDebugMode) {
        print(e);
      }

    }

  }





  // void saveAddress() async {
  //
  //   try
  //   {
  //     //Start loadin
  //     TFullScreenLoader.openLoadingDialog(
  //         "We are processing your information....", TImages.docerAnimation);
  //
  //     //Check Internet Connectivity
  //     final isConnected = await NetworkManager.instance.isConnected();
  //     if (!isConnected) {
  //       TLoader.errorsnackBar(title: "Network Issue" , message: "Try again later");
  //       return;
  //     }
  //     //Form validation
  //     if (!addressFormKey.currentState!.validate()) {
  //       TFullScreenLoader.stopLoading();
  //       TLoader.errorsnackBar(title: "Invalid Data");
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
  //     TFullScreenLoader.stopLoading();
  //     Get.to(() => const UserAddressScreen());
  //   }
  //   catch(e)
  //   {
  //     TFullScreenLoader.stopLoading();
  //     TLoader.errorsnackBar(title: e.toString());
  //
  //   }
  //
  //

  // }
}
