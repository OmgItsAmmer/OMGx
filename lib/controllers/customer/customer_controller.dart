

import 'package:admin_dashboard_v3/repositories/customer/customer_repository.dart';
import 'package:get/get.dart';


import '../../Models/customer/customer_model.dart';
import '../../common/widgets/loaders/tloaders.dart';

class CustomerController extends GetxController {
  static CustomerController get instance => Get.find();
  final CustomerRepository customerRepository = Get.put(CustomerRepository());




  final profileLoading = false.obs;

  RxList<CustomerModel> allCustomers = <CustomerModel>[].obs;
  RxList<String> allCustomerNames = <String>[].obs;

  Rx<CustomerModel> selectedCustomer = CustomerModel.empty().obs;








  @override
  void onInit() {
    super.onInit();

    fetchAllCustomers();
  }



  Future<void> fetchAllCustomers() async {
    try {

      final customers = await customerRepository.fetchallCustomers();
      allCustomers.assignAll(customers);

      //filter names
      final names = allCustomers.map((user) => user.fullName).toList();
      allCustomerNames.assignAll(names);
      print(allCustomerNames);


    } catch (e) {
      TLoader.errorSnackBar(title: "Oh Snap!", message: e.toString());
    }
  }



}


