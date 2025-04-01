import 'package:admin_dashboard_v3/Models/image/image_model.dart';
import 'package:admin_dashboard_v3/Models/sales/sale_model.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/controllers/user/user_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../Models/orders/order_item_model.dart';
import '../../repositories/order/order_repository.dart';
import '../../routes/routes.dart';
import '../customer/customer_controller.dart';
import '../installments/installments_controller.dart';
import '../product/product_images_controller.dart';
import '../shop/shop_controller.dart';

class SalesController extends GetxController {
  static SalesController get instance => Get.find();

  // Other Controllers Interaction
  final OrderRepository orderRepository = Get.put(OrderRepository());
  final ProductImagesController productImagesController =
      Get.find<ProductImagesController>();
  final  shopController =  Get.put(ShopController());


  final CustomerController customerController = Get.find<CustomerController>();
  // final InstallmentController installmentController = Get.find<InstallmentController>();


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
  RxDouble originalNetTotal = (0.0).obs;
  double buyingPriceIndividual  = 0.0;
  double buyingPriceTotal  = 0.0;
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
  final cashierNameController = TextEditingController().obs;
  final selectedSaleType = SaleType.Cash.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  //Salesman Info
  final salesmanNameController = TextEditingController();
  final salesmanCityController = TextEditingController().obs;
  final salesmanAreaController = TextEditingController().obs;
  int selectedSalesmanId = 0;

  //checkout pop up
  final paidAmount = TextEditingController();
  final remainingAmount = TextEditingController().obs;

  GlobalKey<FormState> addUnitPriceAndQuantityKey =
      GlobalKey<FormState>(); // Form key for form validation
  GlobalKey<FormState> addUnitTotalKey =
      GlobalKey<FormState>(); // Form key for form validation
  GlobalKey<FormState> cashierFormKey =
      GlobalKey<FormState>(); // Form key for form validation
  GlobalKey<FormState> customerFormKey =
      GlobalKey<FormState>(); // Form key for form validation
  GlobalKey<FormState> salesmanFormKey =
      GlobalKey<FormState>(); // Form key for form validation

  // Reactive variable to track expansion state
  var isExpanded = true.obs;
//Choice Chip logic
  RxInt selectedChipIndex = (-1).obs;
  RxString selectedChipValue = ''.obs;


  // @override
  // void onInit() {
  //   setupUserDetails();
  //   super.onInit();
  // }

  void setupUserDetails() {
    try{
     cashierNameController.value.text = userController.currentUser.value.firstName;
    }
    catch(e){
      if(kDebugMode)
        {
          TLoader.errorSnackBar(title: e.toString());
          print(e);

        }
    }
}

  void addProduct() {
    try {
      if ((!addUnitTotalKey.currentState!.validate() &&
              !addUnitPriceAndQuantityKey.currentState!.validate()) ||
          selectedProductId == -1) {
        TLoader.errorSnackBar(
            title: "Empty",
            message: 'Kindly fill all the Text fields before proceed');
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
      originalNetTotal.value += double.parse(totalPrice.value.text);
      buyingPriceTotal += buyingPriceIndividual * double.parse(quantity.text);
      // Parse the current remainingAmount and totalPrice as doubles
      double currentRemaining =
          double.tryParse(remainingAmount.value.text) ?? 0.0;
      double totalPriceValue = double.tryParse(totalPrice.value.text) ?? 0.0;

      // Perform the addition
      double newRemaining = currentRemaining + totalPriceValue;

      // Update the remainingAmount with the new value
      remainingAmount.value.text = newRemaining.toStringAsFixed(2);

      allSales.add(sale);
      dropdownController.clear();
      unitPrice.value.clear();
      unit.clear();
      quantity.clear();
      totalPrice.value.clear();
      //searchDropDownKey.currentState?.resetToHint();
    } catch (e) {
      TLoader.errorSnackBar(title: 'Adding Data', message: e.toString());
    }
  }

  Future<int> checkOut() async {
    try {
      // Validate that there are sales to checkout
      if (allSales.isEmpty) {
        TLoader.errorSnackBar(
            title: 'Checkout Error', message: 'No products added to checkout.');
        return -1;
      }
      if ((!salesmanFormKey.currentState!.validate() &&
              !customerFormKey.currentState!.validate() &&
              !cashierFormKey.currentState!.validate()) ||
          customerNameController.text == "" ||
          selectedDate.value == 'Select Date' ||
          salesmanNameController.text == "") {
        TLoader.errorSnackBar(
            title: 'Checkout Error', message: 'Fill all the fields.');
        return -1;
      }

      if(selectedAddressId == -1){
        TLoader.errorSnackBar(
            title: 'Address Error', message: 'Select Valid Address.');
        return -1;
      }

      // Validate paid amount
      double paidAmountValue = double.tryParse(paidAmount.text.trim()) ?? 0.0;
      if (paidAmountValue < 0) {
        TLoader.errorSnackBar(
            title: 'Payment Error', message: 'Enter a valid paid amount.');
        return -1;
      }
      //    String formattedDate = DateTime.parse(selectedDate.value).toUtc().toIso8601String();

      // Create an OrderModel instance
      OrderModel order = OrderModel(
        orderId: -1,
        // will not count
        orderDate: selectedDate.value.toIso8601String(),
        totalPrice: netTotal.value,
        buyingPrice: buyingPriceTotal,
        status: statusCheck(),
        // Default status
        saletype: selectedSaleType.value.toString().split('.').last,
        // Convert enum to string
        addressId: selectedAddressId,
        // Add as needed
        userId: 1,
        // Add as needed userController.current_user?.value['user_id']
        salesmanId: selectedSalesmanId,
        // Add as needed
        paidAmount: paidAmountValue,
        customerId: customerController.selectedCustomer.value.customerId,
        // Add as needed
        orderItems: allSales
            .map((sale) => OrderItemModel(
                  variantId: 1,
                  quantity: int.tryParse(sale.quantity) ?? 0,
                  price: double.tryParse(sale.totalPrice) ?? 0.0,
                  unit: sale.unit.toString().split('.').last,
                ))
            .toList(),
      );



      int orderId = await orderRepository.uploadOrder(order.toJson(isUpdate: true));

      // Reset fields after checkout
      resetField();
      return orderId;
    } catch (e) {
      TLoader.errorSnackBar(title: 'Checkout Error', message: e.toString());
      return -1;
    }
  }

  void resetField() {
    allSales.clear();
    netTotal.value = 0.0;
    originalNetTotal.value = 0.0;
    paidAmount.clear();
    customerNameController.clear();
    customerPhoneNoController.value.clear();
    customerCNICController.value.clear();
    salesmanNameController.clear();
    salesmanCityController.value.clear();
    salesmanAreaController.value.clear();
    remainingAmount.value.clear(); // Optional if needed
    productImagesController.selectedImage.value = ImageModel.empty();
  }

  String statusCheck() {
    try {
      if ('0' == remainingAmount.value.text) {
        return 'PAID';
      } else {
        return 'PENDING';
      }
    } catch (e) {
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






  int _getChipIndex(String discountText) {

    // Helper function to get the chip index based on the discount text
    if (discountText == shopController.profile1.text) return 0;
    if (discountText == shopController.profile2.text) return 1;
    if (discountText == shopController.profile3.text) return 2;
    return -1; // Invalid index
  }

  bool SalesValidator() {

    try{
      if (allSales.isEmpty) {
        TLoader.errorSnackBar(
            title: 'Checkout Error', message: 'No products added to checkout.');
        return false;
      }
      if ((!salesmanFormKey.currentState!.validate() &&
          !customerFormKey.currentState!.validate() &&
          !cashierFormKey.currentState!.validate()) ||
          customerNameController.text == "" ||
          selectedDate.value == 'Select Date' ||
          salesmanNameController.text == "") {
        TLoader.errorSnackBar(
            title: 'Checkout Error', message: 'Fill all the fields.');
        return false;
      }

      if(selectedAddressId == -1){
        TLoader.errorSnackBar(
            title: 'Address Error', message: 'Select Valid Address.');
        return false;
      }

      return true;

    }
    catch(e)
    {
      if (kDebugMode) {
        print(e);
        TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      }
      return false;

    }
  }

  void deleteItem(SaleModel saleItem, int index) {
    try {
      // Clean and parse totalPrice
      double? totalPrice = double.tryParse(
          saleItem.totalPrice.replaceAll(RegExp(r'[^0-9.]'), ''));

      // Clean and parse remainingAmount
      String cleanedRemaining = remainingAmount.value.text.replaceAll(RegExp(r'[^0-9.]'), '');
      if (cleanedRemaining.contains('.')) {
        List<String> parts = cleanedRemaining.split('.');
        if (parts.length > 1) {
          cleanedRemaining = '${parts[0]}.${parts[1].substring(0, parts[1].length > 2 ? 2 : parts[1].length)}';
        }
      }
      double? remaining = double.tryParse(cleanedRemaining);

      if (totalPrice == null) throw Exception("Invalid totalPrice: ${saleItem.totalPrice}");
      if (remaining == null) throw Exception("Invalid remainingAmount: ${remainingAmount.value.text}");

      // Update values
      double currentOriginalTotal = originalNetTotal.value;
      netTotal.value = (netTotal.value - totalPrice).abs() < 1e-10 ? 0 : netTotal.value - totalPrice;
      remainingAmount.value.text = (remaining - totalPrice).toStringAsFixed(2);
      originalNetTotal.value = currentOriginalTotal - totalPrice;

      // Remove item
      allSales.removeAt(index);
    } catch (e) {
      print("Error: $e");
      TLoader.errorSnackBar(title: e.toString());
    }
  }

  void applyDiscount(String discountValue, {bool isPercentage = true}) {
    try {
      // If chip is clicked again, restore original
      if (isPercentage &&
          selectedChipIndex.value != -1 &&
          selectedChipValue.value == discountValue) {
        restoreDiscount();
        return;
      }

      // Clean the input
      String cleanedValue = discountValue.replaceAll(RegExp(r'[^0-9.]'), '');

      // Handle multiple decimal points
      if (cleanedValue.split('.').length > 2) {
        List<String> parts = cleanedValue.split('.');
        cleanedValue = '${parts[0]}.${parts.sublist(1).join()}';
      }

      // Parse the value
      double discountAmount = double.tryParse(cleanedValue) ?? 0.0;

      // For percentage discounts, convert to absolute value
      if (isPercentage) {
        // Validate percentage range
        if (discountAmount < 0 || discountAmount > 100) {
          TLoader.errorSnackBar(
            title: "Invalid Discount",
            message: 'Please enter a valid percentage (0% to 100%).',
          );
          return;
        }
        discountAmount = (originalNetTotal.value * discountAmount) / 100;

        // Update chip selection
        selectedChipValue.value = discountValue;
        selectedChipIndex.value = _getChipIndex(discountValue);
      }

      // Validate discount doesn't exceed total
      if (discountAmount > originalNetTotal.value) {
        TLoader.errorSnackBar(
          title: "Invalid Discount",
          message: "Discount cannot exceed the total amount.",
        );
        restoreDiscount();
        return;
      }

      // Apply the discount
      netTotal.value = originalNetTotal.value - discountAmount;

      // Update discount field if this was a manual entry
      if (!isPercentage) {
        discount.value = cleanedValue;
      }
    } catch (e) {
      TLoader.errorSnackBar(title: e.toString());
    }
  }

  void restoreDiscount() {
    netTotal.value = originalNetTotal.value;
    selectedChipIndex.value = -1;
    selectedChipValue.value = '';
    discount.value = "0.0";
    discountController.text = "0.0";
  }
  // void restoreDiscount() {
  //   try {
  //     // If no discount is selected, do nothing
  //     if (selectedChipIndex.value == -1 || selectedChipValue.value.isEmpty) return;
  //
  //     // Reset netTotal to the original value
  //     netTotal.value = originalNetTotal.value;
  //
  //     // Clear the selected chip value and index
  //     selectedChipValue.value = '';
  //     selectedChipIndex.value = -1;
  //
  //     // Show success message
  //     // TLoader.successSnackBar(
  //     //   title: "Discount Restored",
  //     //   message: 'Discount restored successfully.',
  //     // );
  //   } catch (e) {
  //     TLoader.errorSnackBar(title: e.toString());
  //   }
  // }




}
