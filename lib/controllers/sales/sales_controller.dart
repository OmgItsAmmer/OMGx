import 'dart:ffi';

import 'package:admin_dashboard_v3/Models/products/product_model.dart';
import 'package:admin_dashboard_v3/Models/sales/sale_model.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/controllers/user/user_controller.dart';
import 'package:admin_dashboard_v3/repositories/products/product_repository.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../Models/orders/order_item_model.dart';
import '../../common/widgets/dropdown_search/drop_down_searchbar.dart';
import '../../repositories/order/order_repository.dart';
import '../address/address_controller.dart';
import '../customer/customer_controller.dart';

class SalesController extends GetxController {
  static SalesController get instance => Get.find();

  // Other Controllers Interaction
  final OrderRepository orderRepository = Get.put(OrderRepository());

  final CustomerController customerController = Get.find<CustomerController>();
 // final AddressController addressController = Get.find<AddressController>();
 final UserController userController = Get.find<UserController>();


//making order
  RxList<SaleModel> allSales = <SaleModel>[].obs;



  // Loading state for fetching products
  final isLoading = false.obs;

  //Variables
  Rx<String> selectedProductName = ''.obs;
  Rx<UnitType> selectedUnit = UnitType.item.obs;
  Rx<int> selectedProductId = (-1).obs;
  RxDouble netTotal = (0.0).obs;
  Rx<String> discount = ''.obs;


  //TextForm Controllers
  final unitPrice = TextEditingController().obs;
  final unit = TextEditingController();
  final quantity = TextEditingController();
  final totalPrice = TextEditingController().obs;
  final discountController = TextEditingController(); // to reset field to zero
  final dropdownController = TextEditingController(); // to reset field to zero

  //Customer Info fields
  final customerNameController = TextEditingController();
  final customerPhoneNoController = TextEditingController().obs;
  final customerAddressController = TextEditingController().obs;
  int? selectedAddressId = -1;
  final customerCNICController = TextEditingController().obs;

 // final customerCNICController = TextEditingController().obs;


  //Cashier Info
  final adminNameController = TextEditingController(text: 'Ammer');
  final selectedSaleType = SaleType.Cash.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;


  //Salesman Info
  final salesmanNameController = TextEditingController();
  final salesmanCityController = TextEditingController().obs;
  final salesmanAreaController = TextEditingController().obs;
  int selectedSalesmanId = 0;



  //checkout pop up
  final paidAmount = TextEditingController(text: "0.0");
  final remainingAmount = TextEditingController().obs;





  GlobalKey<FormState> addUnitPriceAndQuantityKey = GlobalKey<FormState>(); // Form key for form validation
  GlobalKey<FormState> addUnitTotalKey = GlobalKey<FormState>(); // Form key for form validation
  GlobalKey<FormState> cashierFormKey = GlobalKey<FormState>(); // Form key for form validation
  GlobalKey<FormState> customerFormKey = GlobalKey<FormState>(); // Form key for form validation
  GlobalKey<FormState> salesmanFormKey = GlobalKey<FormState>(); // Form key for form validation



  // Reactive variable to track expansion state
  var isExpanded = true.obs;





  @override
  void onInit() {
    super.onInit();
  }

  void addProduct() {
   try{
     if ((!addUnitTotalKey.currentState!.validate() && !addUnitPriceAndQuantityKey.currentState!.validate()) ||
         selectedProductId == -1    ) {
       TLoader.errorSnackBar(title: "Empty",message: 'Kindly fill all the Text fields before proceed');
       return;
     }

     final sale = SaleModel(
         productId: selectedProductId.value,
         name: dropdownController.text.trim(),
         salePrice: unitPrice.value.text.trim(),
         unit: selectedUnit.toString().trim(),
         quantity: quantity.text,
         totalPrice: totalPrice.value.text);
     //Adding in netTotal
     netTotal.value += double.parse(totalPrice.value.text);

     allSales.add(sale);
     dropdownController.clear();
     unitPrice.value.clear();
     unit.clear();
     quantity.clear();
     totalPrice.value.clear();
     //searchDropDownKey.currentState?.resetToHint();
     TLoader.successSnackBar(title: 'Added');

   }
   catch(e)
    {
      TLoader.errorSnackBar(title: 'Adding Data',message: e.toString());
    }
  }


  Future<int> checkOut() async {
    try {
      // Validate that there are sales to checkout
      if (allSales.isEmpty) {
        TLoader.errorSnackBar(title: 'Checkout Error', message: 'No products added to checkout.');
        return -1;
      }
      if ((!salesmanFormKey.currentState!.validate() && !customerFormKey.currentState!.validate() && !cashierFormKey.currentState!.validate()) ||
           customerNameController.text == "" || selectedDate.value == 'Select Date' || salesmanNameController.text == ""  )  {
        TLoader.errorSnackBar(title: 'Checkout Error', message: 'Fill all the fields.');
        return -1;
      }

      // Validate paid amount
      double paidAmountValue = double.tryParse(paidAmount.text.trim()) ?? 0.0;
      if (paidAmountValue < 0) {
        TLoader.errorSnackBar(title: 'Payment Error', message: 'Enter a valid paid amount.');
        return -1;
      }
  //    String formattedDate = DateTime.parse(selectedDate.value).toUtc().toIso8601String();


      // Create an OrderModel instance
      OrderModel order = OrderModel(
        orderId: -1, // will not count
        orderDate: selectedDate.value.toIso8601String(),
        totalPrice: netTotal.value,
        status: statusCheck(), // Default status
        saletype: selectedSaleType.value.toString().split('.').last, // Convert enum to string
        addressId: selectedAddressId, // Add as needed
        userId: 1, // Add as needed userController.current_user?.value['user_id']
        salesmanId: selectedSalesmanId, // Add as needed
        paidAmount: paidAmountValue,
        customerId: customerController.selectedCustomer.value.customerId, // Add as needed
        orderItems: allSales.map((sale) => OrderItemModel(
          variantId: 1,
          quantity: int.tryParse(sale.quantity) ?? 0,
          price: double.tryParse(sale.totalPrice) ?? 0.0,
          unit: sale.unit.toString().split('.').last,
        )).toList(),
      );

      // Convert order to JSON for database or further processing
     // final orderJson = order.toJson(isUpdate: true);

     int orderId = await orderRepository.uploadOrder(order);

      // Reset fields after checkout
      allSales.clear();
      netTotal.value = 0.0;
      paidAmount.clear();
      remainingAmount.value = TextEditingController(); // Optional if needed
      return orderId;
    } catch (e) {
      TLoader.errorSnackBar(title: 'Checkout Error', message: e.toString());
      return -1;
    }
  }

  String statusCheck() {
  try {
    if('0' == remainingAmount.value.text)
      {
        return 'PAID';
      }
    else {
      return 'PENDING';
    }

  }
  catch(e) {
    TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    return '';

  }

  }



  // int findAddressId(String address) {
  //     try{
  //
  //       return
  //
  //     }
  //     catch(e)
  //   {
  //     TLoader.errorsnackBar(title: 'Oh Snap!', message: e.toString());
  //
  //   }
  // }




  // Toggle the expansion state in sale desktop
  void toggleExpanded() {
    isExpanded.value = !isExpanded.value;
  }
}
