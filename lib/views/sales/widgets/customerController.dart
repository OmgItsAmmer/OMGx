import 'package:get/get.dart';

class SaleCustomerController extends GetxController {
  // Rx to store the selected customer
  var selectedCustomer = Rx<String?>(null);

  // Method to update the selected customer
  void updateCustomer(String customer) {
    selectedCustomer.value = customer;
  }
}
