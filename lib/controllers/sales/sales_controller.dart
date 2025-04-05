import 'package:admin_dashboard_v3/Models/image/image_model.dart';
import 'package:admin_dashboard_v3/Models/sales/sale_model.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/controllers/product/product_controller.dart';
import 'package:admin_dashboard_v3/controllers/user/user_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
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
  RxInt entityId = (-1).obs;


  // final customerCNICController = TextEditingController().obs;

  //Cashier Info
  final cashierNameController = TextEditingController().obs;
  final selectedSaleType = SaleType.cash.obs;
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
            title: 'Checkout Error',
            message: 'No products added to checkout.'
        );
        return -1;
      }

      // Validate required fields
      if ((!salesmanFormKey.currentState!.validate() ||
          !customerFormKey.currentState!.validate() ||
          !cashierFormKey.currentState!.validate()) ||
          customerNameController.text.isEmpty ||
          selectedDate.value == 'Select Date' ||
          salesmanNameController.text.isEmpty) {
        TLoader.errorSnackBar(
            title: 'Checkout Error',
            message: 'Fill all the fields.'
        );
        return -1;
      }

      if (selectedAddressId == null || selectedAddressId == -1) {
        TLoader.errorSnackBar(
            title: 'Address Error',
            message: 'Select a valid address.'
        );
        return -1;
      }

      // Validate paid amount
      double paidAmountValue = double.tryParse(paidAmount.text.trim()) ?? 0.0;
      if (paidAmountValue < 0) {
        TLoader.errorSnackBar(
            title: 'Payment Error',
            message: 'Enter a valid paid amount.'
        );
        return -1;
      }

      // Create an OrderModel instance
      OrderModel order = OrderModel(
        orderId: -1, // Placeholder, will be updated later
        orderDate: (selectedDate.value is DateTime)
            ? selectedDate.value.toIso8601String()
            : DateTime.now().toIso8601String(),
        totalPrice: netTotal.value,
        buyingPrice: buyingPriceTotal,
        status: statusCheck(),
        saletype: selectedSaleType.value.toString().split('.').last,
        addressId: selectedAddressId,
        userId: 1, // Modify as needed
        salesmanId: selectedSalesmanId,
        paidAmount: paidAmountValue,
        customerId: customerController.selectedCustomer.value.customerId,
        orderItems: allSales.map((sale) => OrderItemModel(
          productId: sale.productId,
          orderId: -1, // Will be updated later
          quantity: int.tryParse(sale.quantity) ?? 0,
          price: double.tryParse(sale.totalPrice) ?? 0.0,
          unit: sale.unit.toString().split('.').last,
        )).toList(),
      );

      // Upload order to repository
      int orderId = await orderRepository.uploadOrder(
          order.toJson(isUpdate: true),
          order.orderItems ?? []
      );

      // Ensure orderId is valid before proceeding
      if (orderId > 0) {
        // Assign actual orderId to each order item
        for (var item in order.orderItems ?? []) {
          item.orderId = orderId;
        }

        final ProductController productController = Get.find<ProductController>();

        // Update stock quantities
        await productController.updateStockQuantities(order.orderItems);

        // Check for low stock notifications
        List<int> productIds = allSales.map((sale) => sale.productId).toList();
        await productController.checkLowStock(productIds);

        // Print thermal invoice
     //   await _generateReceipt(order);

        // Reset fields after successful checkout
        resetField();
        return orderId;
      } else {
        throw Exception("Order upload failed, checkout aborted.");
      }
    } catch (e) {
      TLoader.errorSnackBar(title: 'Checkout Error', message: e.toString());
      return -1;
    }
  }

  // Future<List<int>> _generateReceipt(OrderModel order) async {
  //   final profile = await CapabilityProfile.load();
  //   final generator = Generator(PaperSize.mm80, profile);
  //   List<int> bytes = [];
  //
  //   // Header Section
  //   bytes += generator.text(
  //     "Test Network Print",
  //     styles: const PosStyles(
  //       bold: true,
  //       height: PosTextSize.size3,
  //       width: PosTextSize.size3,
  //     ),
  //   );
  //
  //   // Order Information
  //   bytes += generator.text("Order ID: ${order.orderId}");
  //   bytes += generator.text("Date: ${order.orderDate}");
  //   if (order.saletype != null) {
  //     bytes += generator.text("Sale Type: ${order.saletype!}");
  //   }
  //   bytes += generator.text("--------------------------------");
  //
  //   // Order Items
  //   if (order.orderItems != null && order.orderItems!.isNotEmpty) {
  //     for (var item in order.orderItems!) {
  //       final itemTotal = item.quantity * item.price;
  //       final productLine = item..padRight(20);
  //       final priceLine = "x${item.quantity}".padLeft(5) +
  //           "\$${itemTotal.toStringAsFixed(2)}".padLeft(10);
  //       bytes += generator.text("$productLine$priceLine");
  //     }
  //   } else {
  //     bytes += generator.text("No items in this order");
  //   }
  //
  //   bytes += generator.text("--------------------------------");
  //
  //   // Calculations
  //   final subtotal = order.orderItems?.fold<double>(
  //       0.0,
  //           (sum, item) => sum + (item.quantity * item.price)
  //   ) ?? 0.0;
  //
  //   // Payment Summary
  //   bytes += _buildRightAlignedText(generator, "Subtotal:", subtotal);
  //
  //   if (order.discount > 0) {
  //     bytes += _buildRightAlignedText(generator, "Discount:", -order.discount);
  //   }
  //
  //   bytes += _buildRightAlignedText(generator, "Tax:", order.tax);
  //   bytes += _buildRightAlignedText(generator, "Shipping:", order.shippingFee);
  //
  //   if (order.salesmanComission > 0) {
  //     bytes += _buildRightAlignedText(
  //         generator,
  //         "Commission:",
  //         order.salesmanComission.toDouble()
  //     );
  //   }
  //
  //   bytes += generator.text(
  //     "Total: \$${order.totalPrice.toStringAsFixed(2)}",
  //     styles: const PosStyles(bold: true, align: PosAlign.right),
  //   );
  //
  //   bytes += generator.cut();
  //   return bytes;
  // }

  List<int> _buildRightAlignedText(Generator generator, String label, double value) {
    return generator.text(
      "$label \$${value.toStringAsFixed(2)}",
      styles: const PosStyles(align: PosAlign.right),
    );
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

  void deleteItem(SaleModel saleItem, int index) {
    try {
      // Ensure totalPrice is a valid number
      double? totalPrice = double.tryParse(
          saleItem.totalPrice.replaceAll(RegExp(r'[^0-9.]'), ''));

      // Clean the remainingAmount string to ensure it's a valid number
      String cleanedRemaining =
      remainingAmount.value.text.replaceAll(RegExp(r'[^0-9.]'), '');

      // Extract only the first valid number (up to the first decimal point)
      if (cleanedRemaining.contains('.')) {
        List<String> parts = cleanedRemaining.split('.');
        if (parts.length > 1) {
          // Take the integer part and the first two decimal places
          cleanedRemaining =
          '${parts[0]}.${parts[1].substring(0, parts[1].length > 2 ? 2 : parts[1].length)}';
        }
      }

      // Parse the cleaned remaining amount
      double? remaining = double.tryParse(cleanedRemaining);

      if (totalPrice == null) {
        throw Exception("Invalid totalPrice: ${saleItem.totalPrice}");
      }

      if (remaining == null) {
        throw Exception(
            "Invalid remainingAmount: ${remainingAmount.value.text}");
      }

      // Update netTotal and remainingAmount
      double currentOriginalTotal = originalNetTotal.value;
      netTotal.value = (netTotal.value - totalPrice).abs() < 1e-10
          ? 0
          : netTotal.value - totalPrice;
      remainingAmount.value.text = (remaining - totalPrice)
          .toStringAsFixed(2); // Format to 2 decimal places

      // Update original total to reflect item removal
      originalNetTotal.value = currentOriginalTotal - totalPrice;

      // Remove the item from the list
      allSales.removeAt(index);
    } catch (e) {
      print("Error: $e"); // Debugging
      TLoader.errorSnackBar(title: e.toString());
    }
  }


  void restoreDiscount() {
    try {
      // If no discount is selected, do nothing
      if (selectedChipIndex.value == -1 || selectedChipValue.value.isEmpty) return;

      // Reset netTotal to the original value
      netTotal.value = originalNetTotal.value;

      // Clear the selected chip value and index
      selectedChipValue.value = '';
      selectedChipIndex.value = -1;

      // Show success message
      // TLoader.successSnackBar(
      //   title: "Discount Restored",
      //   message: 'Discount restored successfully.',
      // );
    } catch (e) {
      TLoader.errorSnackBar(title: e.toString());
    }
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
  void applyDiscountInChips(String discountText) {
    try {
      // If the same chip is clicked again, deselect it and restore the original value
      if (selectedChipIndex.value != -1 && selectedChipValue.value == discountText) {
        restoreDiscount();
        return;
      }

      // Reset any existing discount from the field
      if (discount.value.isNotEmpty) {
        restoreDiscount();
        discountController.clear(); // Clear the text field
      }

      // Extract the numeric value from discountText (e.g., "10%" -> 10)
      String percentageString = discountText.replaceAll('%', '');
      double? discountPercentage = double.tryParse(percentageString);

      // Validate the discount percentage
      if (discountPercentage == null || discountPercentage < 0 || discountPercentage > 100) {
        TLoader.errorSnackBar(
          title: "Invalid Discount",
          message: 'Please select a valid discount percentage (0% to 100%).',
        );
        return;
      }

      // Calculate the discount amount based on the original net total
      double discountAmount = (originalNetTotal.value * discountPercentage) / 100;

      // Apply discount
      netTotal.value = originalNetTotal.value - discountAmount;

      // Update the selected chip value and index
      selectedChipValue.value = discountText;
      selectedChipIndex.value = _getChipIndex(discountText);

    } catch (e) {
      TLoader.errorSnackBar(title: e.toString());
    }
  }

  void applyDiscountInField(String value) {
    // Reset any existing discount from chips
    if (selectedChipIndex.value != -1) {
      restoreDiscount();
    }

    // Clean the input to extract only numbers and decimals
    String cleanedValue = value.replaceAll(RegExp(r'[^0-9.]'), '');

    // Ensure only one decimal point exists
    if (cleanedValue.split('.').length > 2) {
      List<String> parts = cleanedValue.split('.');
      cleanedValue = '${parts[0]}.${parts.sublist(1).join()}';
    }

    // Parse the cleaned value as a percentage
    double enteredPercentage = double.tryParse(cleanedValue) ?? 0.0;

    // Reset net total to original before applying a new discount
    double currentOriginalTotal = originalNetTotal.value;

    // Calculate discount amount
    double discountAmount = (enteredPercentage / 100) * currentOriginalTotal;

    // Validate the discount percentage (should not exceed 100%)
    if (enteredPercentage > 100) {
      discountController.text = "0.0";
      discount.value = "0.0";
      netTotal.value = currentOriginalTotal;

      TLoader.errorSnackBar(
        title: "Invalid Discount",
        message: "Discount cannot exceed 100%.",
      );
    } else {
      discount.value = "$cleanedValue%"; // Ensure percentage format
      netTotal.value = currentOriginalTotal - discountAmount;
    }
  }











}
