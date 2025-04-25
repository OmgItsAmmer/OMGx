import 'package:admin_dashboard_v3/Models/products/product_variant_model.dart';
import 'package:admin_dashboard_v3/Models/sales/sale_model.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/controllers/product/product_controller.dart';
import 'package:admin_dashboard_v3/controllers/salesman/salesman_controller.dart';
import 'package:admin_dashboard_v3/controllers/user/user_controller.dart';
import 'package:admin_dashboard_v3/repositories/products/product_variants_repository.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../Models/orders/order_item_model.dart';
import '../../Models/products/product_model.dart';
import '../../repositories/order/order_repository.dart';
import '../customer/customer_controller.dart';
import '../shop/shop_controller.dart';
import '../../Models/salesman/salesman_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SalesController extends GetxController {
  static SalesController get instance => Get.find();

  // Other Controllers Interaction
  final OrderRepository orderRepository = Get.put(OrderRepository());
  final SupabaseClient supabase = Supabase.instance.client;

  final shopController = Get.put(ShopController());
  final SalesmanController salesmanController = Get.put(SalesmanController());

  final CustomerController customerController = Get.find<CustomerController>();
  // final InstallmentController installmentController = Get.find<InstallmentController>();

  // final AddressController addressController = Get.find<AddressController>();
  final UserController userController = Get.find<UserController>();

//making order
  RxList<SaleModel> allSales = <SaleModel>[].obs;

  // Loading state for fetching products
  final isLoading = false.obs;
  final isCheckingOut = false.obs;

  //Variables
  Rx<String> selectedProductName = ''.obs;
  Rx<UnitType> selectedUnit = UnitType.item.obs;
  Rx<int> selectedProductId = (-1).obs;
  RxDouble netTotal = (0.0).obs;
  RxDouble originalNetTotal = (0.0).obs;
  double buyingPriceIndividual = 0.0;
  double buyingPriceTotal = 0.0;
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
  final Rx<DateTime?> selectedDate =
      Rx<DateTime?>(DateTime.now()); // Set default to today's date

  //Salesman Info
  final salesmanNameController = TextEditingController();
  final salesmanCityController = TextEditingController().obs;
  final salesmanAreaController = TextEditingController().obs;
  int selectedSalesmanId = -1;

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

  // Add these properties at the top of the SalesController class after the other Rx variables
  RxBool isLoadingVariants = false.obs;
  RxList<ProductVariantModel> availableVariants = <ProductVariantModel>[].obs;
  RxInt selectedVariantId = (-1).obs;
  RxBool isManualTextEntry = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Refresh product data to ensure accurate stock information
    try {
      final productController = Get.find<ProductController>();
      productController.refreshProducts();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to refresh products: $e');
      }
    }

    // Initialize values
    remainingAmount.value.text = netTotal.value.toString();

    // Set current date
    selectedDate.value = DateTime.now();
  }

  void setupUserDetails() {
    try {
      cashierNameController.value.text =
          userController.currentUser.value.firstName;
    } catch (e) {
      if (kDebugMode) {
        TLoader.errorSnackBar(title: e.toString());
        print(e);
      }
    }
  }

  void addProduct() async {
    try {
      isLoading.value = true;

      // Prevent adding products when manual text entry doesn't match a valid product
      if (isManualTextEntry.value) {
        TLoader.errorSnackBar(
          title: "Invalid Product",
          message: 'Please select a valid product from the dropdown list',
        );
        return;
      }

      // Get the product to check if it's serialized
      final productController = Get.find<ProductController>();
      final product = productController.allProducts.firstWhere(
        (p) => p.productId == selectedProductId.value,
        orElse: () => ProductModel.empty(),
      );

      // For serialized products, validate selection of a variant
      if (product.hasSerialNumbers) {
        if (selectedVariantId.value == -1) {
          TLoader.errorSnackBar(
            title: "Select Serial Number",
            message: 'Please select a specific serial number for this product',
          );
          return;
        }

        // Find the selected variant
        final variant = availableVariants.firstWhere(
          (v) => v.variantId == selectedVariantId.value,
          orElse: () => ProductVariantModel.empty(),
        );

        // Check if variant is valid
        if (variant.variantId == null) {
          TLoader.errorSnackBar(
            title: "Invalid Selection",
            message: 'The selected variant is no longer available',
          );
          return;
        }

        // For serialized products, create a sale with quantity = 1
        final sale = SaleModel(
          productId: selectedProductId.value,
          name: dropdownController.text.trim(),
          salePrice: variant.sellingPrice.toString(),
          unit: selectedUnit.toString().trim(),
          quantity: "1", // Always 1 for serialized products
          totalPrice: variant.sellingPrice.toString(),
          buyPrice: variant.purchasePrice,
          variantId: variant.variantId,
        );

        // Update totals
        final double newTotalPrice = variant.sellingPrice;
        netTotal.value += newTotalPrice;
        originalNetTotal.value += newTotalPrice;
        buyingPriceTotal += variant.purchasePrice;

        // Update remaining amount
        double currentRemaining =
            double.tryParse(remainingAmount.value.text) ?? 0.0;
        remainingAmount.value.text =
            (currentRemaining + newTotalPrice).toStringAsFixed(2);

        // Add the sale and reset fields
        allSales.add(sale);

        // Remove the used variant from available list
        availableVariants.removeWhere((v) => v.variantId == variant.variantId);
        selectedVariantId.value = -1;

        // Clear input fields
        dropdownController.clear();
        unitPrice.value.clear();
        unit.clear();
        quantity.clear();
        totalPrice.value.clear();

        // Show success feedback
        TLoader.successSnackBar(
          title: "Product Added",
          message: "Serial number ${variant.serialNumber} added to sale",
        );
      } else {
        // For regular products

        // Validation for quantity and price
        if (!addUnitPriceAndQuantityKey.currentState!.validate() &&
            !addUnitTotalKey.currentState!.validate()) {
          TLoader.errorSnackBar(
            title: 'Kindly Fill the Required Field',
            message: 'Please fill all required fields to continue',
          );
          return;
        }

        // Create a regular sale
        SaleModel sale = SaleModel(
          productId: selectedProductId.value,
          name: dropdownController.text.trim(),
          salePrice: unitPrice.value.text.trim(),
          unit: selectedUnit.toString().split('.').last.trim(),
          quantity: quantity.text.trim(),
          totalPrice: totalPrice.value.text.trim(),
          buyPrice: buyingPriceIndividual,
        );

        // Update totals
        double newTotalPrice = double.tryParse(totalPrice.value.text) ?? 0.0;
        netTotal.value += newTotalPrice;
        originalNetTotal.value += newTotalPrice;
        buyingPriceTotal +=
            buyingPriceIndividual * (double.tryParse(quantity.text) ?? 0.0);

        // Update remaining amount
        double currentRemaining =
            double.tryParse(remainingAmount.value.text) ?? 0.0;
        remainingAmount.value.text =
            (currentRemaining + newTotalPrice).toStringAsFixed(2);

        // Add the sale and reset fields
        allSales.add(sale);

        // Clear input fields
        dropdownController.clear();
        unitPrice.value.clear();
        unit.clear();
        quantity.clear();
        totalPrice.value.clear();

        // Show success feedback
        TLoader.successSnackBar(
          title: "Product Added",
          message: "${sale.name} added to sale",
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in addProduct: $e');
      }
      TLoader.errorSnackBar(
        title: 'Error Adding Product',
        message: 'An error occurred while adding the product: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<int> checkOut() async {
    try {
      isCheckingOut.value = true;

      // Validate that there are sales to checkout
      if (allSales.isEmpty) {
        Get.back(); // Close loading dialog
        TLoader.errorSnackBar(
            title: 'Checkout Error', message: 'No products added to checkout.');
        return -1;
      }

      // Validate required fields
      if ((!salesmanFormKey.currentState!.validate() ||
              !customerFormKey.currentState!.validate() ||
              !cashierFormKey.currentState!.validate()) ||
          customerNameController.text.isEmpty ||
          selectedDate.value == null ||
          salesmanNameController.text.isEmpty) {
        Get.back(); // Close loading dialog
        TLoader.errorSnackBar(
            title: 'Checkout Error', message: 'Fill all the fields.');
        return -1;
      }

      if (selectedAddressId == null || selectedAddressId == -1) {
        Get.back(); // Close loading dialog
        TLoader.errorSnackBar(
            title: 'Address Error', message: 'Select a valid address.');
        return -1;
      }

      // Validate paid amount
      double paidAmountValue = double.tryParse(paidAmount.text.trim()) ?? 0.0;
      if (paidAmountValue < 0) {
        Get.back(); // Close loading dialog
        TLoader.errorSnackBar(
            title: 'Payment Error', message: 'Enter a valid paid amount.');
        return -1;
      }

      // Store serialized variants to mark as sold later
      final List<int> serializedVariantIds = [];
      for (var sale in allSales) {
        if (sale.variantId != null) {
          serializedVariantIds.add(sale.variantId!);
        }
      }

      // Create an OrderModel instance with formatted date
      OrderModel order = OrderModel(
        discount: double.tryParse(discount.value.replaceAll('%', '')) ?? 0.0,
        salesmanComission: salesmanController.allSalesman
                .firstWhere(
                  (salesman) => salesman.salesmanId == selectedSalesmanId,
                  orElse: () => SalesmanModel.empty(),
                )
                .comission ??
            0,
        shippingFee: shopController.selectedShop!.value.shippingPrice,
        tax: shopController.selectedShop!.value.taxrate,
        orderId: -1, // Using -1 as a temporary ID instead of null
        orderDate: formatDate(selectedDate.value ?? DateTime.now()),
        totalPrice: netTotal.value,
        buyingPrice: buyingPriceTotal,
        status: statusCheck(),
        saletype: selectedSaleType.value.toString().split('.').last,
        addressId: selectedAddressId,
        userId: userController.currentUser.value.userId,
        salesmanId: selectedSalesmanId,
        paidAmount: paidAmountValue,
        customerId: customerController.selectedCustomer.value.customerId,
      );

      // Create order items with the correct variant IDs
      final List<OrderItemModel> orderItems = allSales
          .map((sale) => OrderItemModel(
                productId: sale.productId,
                orderId: -1,
                quantity: int.tryParse(sale.quantity) ?? 0,
                price: double.tryParse(sale.totalPrice) ?? 0.0,
                unit: sale.unit.toString().split('.').last,
                totalBuyPrice: sale.buyPrice,
                variantId: sale.variantId,
              ))
          .toList();

      order = order.copyWith(orderItems: orderItems);

      // Upload order to repository
      int orderId = await orderRepository.uploadOrder(
          order.toJson(isUpdate: true), order.orderItems ?? []);

      // Ensure orderId is valid before proceeding
      if (orderId > 0) {
        // Assign actual orderId to each order item using copyWith
        order = order.copyWith(
          orderId: orderId,
          orderItems: order.orderItems
              ?.map((item) => item.copyWith(
                    orderId: orderId,
                  ))
              .toList(),
        );

        final ProductController productController =
            Get.find<ProductController>();

        try {
          // Mark serialized variants as sold
          if (serializedVariantIds.isNotEmpty) {
            final productVariantsRepository =
                Get.find<ProductVariantsRepository>();

            for (var variantId in serializedVariantIds) {
              await productVariantsRepository.markVariantAsSold(variantId);
              if (kDebugMode) {
                print('Marked variant $variantId as sold');
              }
            }
          }

          // Update stock quantities for non-serialized products
          if (order.orderItems != null) {
            await productController.updateStockQuantities(order.orderItems);
          }

          // Check for low stock notifications
          if (order.orderItems != null) {
            List<int> productIds =
                order.orderItems!.map((item) => item.productId).toList();
            await productController.checkLowStock(productIds);
          }

          // Generate receipt
          try {
            final receiptBytes = await _generateReceipt(order);
            // You can add code here to print the receipt or save it
            if (kDebugMode) {
              print('Receipt generated successfully');
            }
          } catch (e) {
            if (kDebugMode) {
              print('Error generating receipt: $e');
            }
            // Don't throw the error since receipt generation is not critical
          }

          // Close loading dialog
          Navigator.of(Get.context!).pop();

          // Clear all sales data
          clearSaleDetails();

          // Show success message
          TLoader.successSnackBar(
            title: 'Order Placed Successfully',
            message: 'Order #$orderId has been placed successfully.',
          );

          return orderId;
        } catch (e) {
          Get.back(); // Close loading dialog
          if (kDebugMode) {
            print('Error updating stock: $e');
          }
          TLoader.errorSnackBar(
              title: 'Stock Update Error', message: e.toString());
          return orderId; // Still return orderId as the order was created
        }
      } else {
        Navigator.of(Get.context!).pop();
        if (kDebugMode) {
          print('Order upload failed');
        }
        TLoader.errorSnackBar(
          title: 'Order Creation Failed',
          message: 'Failed to create order. Please try again.',
        );
        return -1;
      }
    } catch (e) {
      // Close loading dialog if open
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      if (kDebugMode) {
        print('Checkout error: $e');
      }
      TLoader.errorSnackBar(
        title: 'Checkout Error',
        message: 'An error occurred during checkout: ${e.toString()}',
      );
      return -1;
    } finally {
      isCheckingOut.value = false;
    }
  }

  Future<List<int>> _generateReceipt(OrderModel order) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];

    // Print shop information
    bytes += generator.text(
      shopController.shopName.value.text,
      styles: const PosStyles(
        bold: true,
        align: PosAlign.center,
      ),
    );
    bytes += generator.text(
      'Date: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}\n' +
          'Time: ${DateFormat('HH:mm:ss').format(DateTime.now())}',
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.hr();

    // Print order details
    bytes += generator.text(
      'Order #${order.orderId}',
      styles: const PosStyles(bold: true),
    );
    bytes += generator.hr();

    // Print items
    for (var item in order.orderItems ?? []) {
      bytes += generator.text(
        '${item.productId}\n'
        '${item.quantity} x ${item.price} = ${item.quantity * item.price}',
      );
    }

    // Print totals
    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(text: 'Subtotal:', width: 6),
      PosColumn(
          text: '${order.totalPrice}',
          width: 6,
          styles: const PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(text: 'Tax:', width: 6),
      PosColumn(
          text: '${order.tax}',
          width: 6,
          styles: const PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(text: 'Total:', width: 6, styles: const PosStyles(bold: true)),
      PosColumn(
        text: '${order.totalPrice + order.tax}',
        width: 6,
        styles: const PosStyles(bold: true, align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(text: 'Paid:', width: 6),
      PosColumn(
          text: '${order.paidAmount ?? 0}',
          width: 6,
          styles: const PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(text: 'Change:', width: 6),
      PosColumn(
        text: '${(order.paidAmount ?? 0) - (order.totalPrice + order.tax)}',
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.hr();
    bytes += generator.text(
      'Thank you for your purchase!',
      styles: const PosStyles(
        bold: true,
        align: PosAlign.center,
      ),
    );
    bytes += generator.cut();

    return bytes;
  }

  // Helper method to format date as YYYY-MM-DD
  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Helper method to parse date from dd/mm/yyyy string
  DateTime? parseDate(String dateStr) {
    try {
      return DateFormat('dd/MM/yyyy').parse(dateStr);
    } catch (e) {
      return null;
    }
  }

  // Reset form fields only - used internally
  void resetFields() {
    try {
      // Clear form controllers
      unitPrice.value.clear();
      unit.clear();
      quantity.clear();
      totalPrice.value.clear();
      discountController.clear();
      dropdownController.clear();

      // Reset form states
      selectedChipIndex.value = -1;
      selectedChipValue.value = '';

      // Clear payment fields
      paidAmount.clear();
      remainingAmount.value.clear();
    } catch (e) {
      TLoader.errorSnackBar(title: 'Reset Error', message: e.toString());
    }
  }

  // Clear all sales-related data after successful checkout or when needed
  void clearSaleDetails() {
    try {
      // Clear customer information
      customerNameController.clear();
      customerPhoneNoController.value.clear();
      customerCNICController.value.clear();
      customerAddressController.value.clear();
      selectedAddressId = -1;
      entityId.value = -1;

      // Clear salesman fields
      salesmanNameController.clear();
      salesmanCityController.value.clear();
      salesmanAreaController.value.clear();
      selectedSalesmanId = 0;

      // Clear product selection
      selectedProductName.value = '';
      selectedProductId.value = -1;
      selectedUnit.value = UnitType.item;

      // Clear cart
      allSales.clear();
      netTotal.value = 0.0;
      originalNetTotal.value = 0.0;
      buyingPriceTotal = 0.0;
      buyingPriceIndividual = 0.0;

      // Reset form fields
      resetFields();

      // Reset discount
      discount.value = '';

      // Refresh the UI
      update();
    } catch (e) {
      TLoader.errorSnackBar(
          title: 'Clear Details Error', message: e.toString());
    }
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
      if (selectedChipIndex.value == -1 || selectedChipValue.value.isEmpty)
        return;

      // Reset netTotal to the original value
      netTotal.value = originalNetTotal.value;

      // Update remaining amount to match the restored net total
      double currentPaidAmount = double.tryParse(paidAmount.text) ?? 0.0;
      remainingAmount.value.text =
          (netTotal.value - currentPaidAmount).toStringAsFixed(2);

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
    try {
      if (allSales.isEmpty) {
        TLoader.errorSnackBar(
            title: 'Checkout Error', message: 'No products added to checkout.');
        return false;
      }
      if ((!salesmanFormKey.currentState!.validate() &&
              !customerFormKey.currentState!.validate() &&
              !cashierFormKey.currentState!.validate()) ||
          customerNameController.text == "" ||
          selectedDate.value == null ||
          salesmanNameController.text == "") {
        TLoader.errorSnackBar(
            title: 'Checkout Error', message: 'Fill all the fields.');
        return false;
      }

      if (selectedAddressId == -1) {
        TLoader.errorSnackBar(
            title: 'Address Error', message: 'Select Valid Address.');
        return false;
      }

      return true;
    } catch (e) {
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
      if (selectedChipIndex.value != -1 &&
          selectedChipValue.value == discountText) {
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
      if (discountPercentage == null ||
          discountPercentage < 0 ||
          discountPercentage > 100) {
        TLoader.errorSnackBar(
          title: "Invalid Discount",
          message: 'Please select a valid discount percentage (0% to 100%).',
        );
        return;
      }

      // Calculate the discount amount based on the original net total
      double discountAmount =
          (originalNetTotal.value * discountPercentage) / 100;

      // Apply discount
      netTotal.value = originalNetTotal.value - discountAmount;

      // Update remaining amount to match the new net total
      double currentPaidAmount = double.tryParse(paidAmount.text) ?? 0.0;
      remainingAmount.value.text =
          (netTotal.value - currentPaidAmount).toStringAsFixed(2);

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

      // Update remaining amount to match the new net total
      double currentPaidAmount = double.tryParse(paidAmount.text) ?? 0.0;
      remainingAmount.value.text =
          (netTotal.value - currentPaidAmount).toStringAsFixed(2);
    }
  }

  // Add this method after the onInit method
  void selectVariant(ProductVariantModel variant) {
    selectedVariantId.value = variant.variantId ?? -1;

    // Update the unit price and total price fields with the variant's selling price
    if (variant.variantId != null) {
      unitPrice.value.text = variant.sellingPrice.toString();
      quantity.text = "1"; // For serialized products, quantity is always 1
      totalPrice.value.text = variant.sellingPrice.toString();
      buyingPriceIndividual = variant.purchasePrice;
    }
  }

  // Add this method after the setupUserDetails method
  Future<void> loadAvailableVariants(int productId) async {
    try {
      isLoadingVariants.value = true;
      selectedVariantId.value = -1;

      // Reset fields
      availableVariants.clear();

      if (productId <= 0) return;

      // Get the product
      final productController = Get.find<ProductController>();
      final product = productController.allProducts.firstWhere(
        (p) => p.productId == productId,
        orElse: () => ProductModel.empty(),
      );

      // Only load variants for serialized products
      if (!product.hasSerialNumbers) return;

      // Load available variants
      final variants = await productController.getAvailableVariants(productId);
      availableVariants.assignAll(variants);

      // If variants are available, update the UI
      if (variants.isNotEmpty) {
        unitPrice.value.text = "";
        quantity.text = "1"; // For serialized products, quantity is always 1
        totalPrice.value.text = "";
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading variants: $e');
      }
      TLoader.errorSnackBar(
        title: 'Error',
        message: 'Failed to load product variants: $e',
      );
    } finally {
      isLoadingVariants.value = false;
    }
  }
}
