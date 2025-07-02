import 'package:admin_dashboard_v3/Models/address/address_model.dart';
import 'package:admin_dashboard_v3/Models/vendor/vendor_model.dart';
import 'package:admin_dashboard_v3/Models/products/product_variant_model.dart';
import 'package:admin_dashboard_v3/Models/purchase/purchase_model.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/controllers/address/address_controller.dart';
import 'package:admin_dashboard_v3/controllers/purchase/purchase_controller.dart';
import 'package:admin_dashboard_v3/controllers/media/media_controller.dart';
import 'package:admin_dashboard_v3/controllers/product/product_controller.dart';
import 'package:admin_dashboard_v3/controllers/user/user_controller.dart';
import 'package:admin_dashboard_v3/repositories/products/product_variants_repository.dart';
import 'package:admin_dashboard_v3/repositories/purchase/purchase_repository.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Models/products/product_model.dart';
import '../vendor/vendor_controller.dart';
import '../shop/shop_controller.dart';

// Local cart item model for purchase sales (different from database model)
class PurchaseCartItem {
  final int productId;
  final String name;
  final String purchasePrice;
  final String unit;
  final String quantity;
  final String totalPrice;
  final int? variantId;

  PurchaseCartItem({
    required this.productId,
    required this.name,
    required this.purchasePrice,
    required this.unit,
    required this.quantity,
    required this.totalPrice,
    this.variantId,
  });
}

class PurchaseSalesController extends GetxController {
  static PurchaseSalesController get instance => Get.find();

  // Repository and Controllers
  final PurchaseRepository purchaseRepository = Get.put(PurchaseRepository());
  final ShopController shopController = Get.put(ShopController());
  final VendorController vendorController = Get.find<VendorController>();
  final UserController userController = Get.find<UserController>();

  // Purchase cart items
  RxList<PurchaseCartItem> allPurchases = <PurchaseCartItem>[].obs;
  RxList<PurchaseCartItem> get purchaseCartItem => allPurchases;

  // UI expansion states
  var isProductEntryExpanded = true.obs;
  var isSerialExpanded = true.obs;

  // Indicator for whether there are serial numbers to display
  RxBool hasSerialNumbers = false.obs;

  // Loading states
  final isLoading = false.obs;
  final isCheckingOut = false.obs;

  // Variables
  Rx<String> selectedProductName = ''.obs;
  Rx<UnitType> selectedUnit = UnitType.item.obs;
  Rx<int> selectedProductId = (-1).obs;
  RxDouble subTotal = (0.0).obs;
  RxDouble netTotal = (0.0).obs;
  RxDouble originalSubTotal = (0.0).obs;
  RxDouble originalNetTotal = (0.0).obs;
  Rx<String> discount = ''.obs;

  // Custom units support
  RxString customUnitName = ''.obs;
  RxList<String> customUnits = <String>[].obs;
  RxMap<String, double> customUnitFactors = <String, double>{}.obs;

  // Toggle for merging products with same ID and unit
  RxBool mergeIdenticalProducts = true.obs;

  // Toggle for serialized product
  RxBool isSerializedProduct = false.obs;

  // Unit conversion factors (relative to base unit)
  final Map<UnitType, double> unitConversionFactors = {
    UnitType.item: 1.0,
    UnitType.dozen: 12.0,
    UnitType.gross: 144.0,
    UnitType.kilogram: 1.0,
    UnitType.gram: 0.001,
    UnitType.liter: 1.0,
    UnitType.milliliter: 0.001,
    UnitType.meter: 1.0,
    UnitType.centimeter: 0.01,
    UnitType.inch: 0.0254,
    UnitType.foot: 0.3048,
    UnitType.yard: 0.9144,
    UnitType.box: 1.0,
    UnitType.pallet: 1.0,
    UnitType.custom: 1.0,
  };

  // TextForm Controllers
  final unitPrice = TextEditingController().obs;
  final unit = TextEditingController();
  final quantity = TextEditingController();
  final totalPrice = TextEditingController().obs;
  final discountController = TextEditingController();
  final dropdownController = TextEditingController();

  // Vendor Info fields
  final vendorNameController = TextEditingController();
  final vendorPhoneNoController = TextEditingController().obs;
  final vendorAddressController = TextEditingController().obs;
  int? selectedAddressId = -1;
  final vendorEmailController = TextEditingController().obs;
  RxInt entityId = (-1).obs;

  // User Info
  final userNameController = TextEditingController().obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(DateTime.now());

  // Checkout popup
  final paidAmount = TextEditingController();
  final remainingAmount = TextEditingController().obs;

  // Form keys
  GlobalKey<FormState> addUnitPriceAndQuantityKey = GlobalKey<FormState>();
  GlobalKey<FormState> addUnitTotalKey = GlobalKey<FormState>();
  GlobalKey<FormState> userFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> vendorFormKey = GlobalKey<FormState>();

  // Reactive variable to track expansion state
  var isExpanded = true.obs;

  // Choice Chip logic
  RxInt selectedChipIndex = (-1).obs;
  RxString selectedChipValue = ''.obs;

  // Variant handling
  RxBool isLoadingVariants = false.obs;
  RxList<ProductVariantModel> availableVariants = <ProductVariantModel>[].obs;
  RxInt selectedVariantId = (-1).obs;
  RxBool isManualTextEntry = false.obs;

  // Focus Nodes for Tab Order
  final FocusNode productNameFocus = FocusNode();
  final FocusNode unitPriceFocus = FocusNode();
  final FocusNode quantityFocus = FocusNode();
  final FocusNode totalPriceFocus = FocusNode();
  final FocusNode addButtonFocus = FocusNode();

  @override
  void onInit() {
    super.onInit();
    remainingAmount.value.text = "0.00";
    selectedDate.value = DateTime.now();
  }

  @override
  void onClose() {
    try {
      clearPurchaseDetails();
    } catch (e) {
      if (kDebugMode) {
        print('Error in onClose: $e');
      }
    }
    super.onClose();
  }

  void setupUserDetails() {
    try {
      userNameController.value.text =
          userController.currentUser.value.firstName;
    } catch (e) {
      if (kDebugMode) {
        TLoaders.errorSnackBar(title: e.toString());
        print(e);
      }
    }
  }

  void addProduct() async {
    try {
      isLoading.value = true;

      // VALIDATION CHECK 1: Product selection
      if (dropdownController.text.isEmpty || selectedProductId.value < 0) {
        TLoaders.errorSnackBar(
          title: "Product Selection Required",
          message: 'Please select a valid product from the dropdown list',
        );
        return;
      }

      // VALIDATION CHECK 2: Manual text entry
      if (isManualTextEntry.value) {
        TLoaders.errorSnackBar(
          title: "Invalid Product",
          message: 'Please select a valid product from the dropdown list',
        );
        return;
      }

      // Get the product to check if it's serialized
      final productController = Get.find<ProductController>();

      // VALIDATION CHECK 3: Product exists
      final product = productController.allProducts.firstWhere(
        (p) => p.productId == selectedProductId.value,
        orElse: () => ProductModel.empty(),
      );

      if (product.productId == null) {
        TLoaders.errorSnackBar(
          title: "Product Not Found",
          message: 'The selected product no longer exists in the database',
        );
        return;
      }

      // For serialized products handling
      if (product.hasSerialNumbers) {
        // VALIDATION CHECK 4: Serial number selected
        if (selectedVariantId.value == -1) {
          TLoaders.errorSnackBar(
            title: "Select Serial Number",
            message: 'Please select a specific serial number for this product',
          );
          return;
        }

        // VALIDATION CHECK 5: Valid variant
        final variant = availableVariants.firstWhere(
          (v) => v.variantId == selectedVariantId.value,
          orElse: () => ProductVariantModel.empty(),
        );

        if (variant.variantId == null) {
          TLoaders.errorSnackBar(
            title: "Invalid Selection",
            message: 'The selected variant is no longer available',
          );
          return;
        }

        // VALIDATION CHECK 6: Valid price
        if (variant.purchasePrice <= 0) {
          TLoaders.errorSnackBar(
            title: "Invalid Price",
            message: 'The selected product has an invalid purchase price',
          );
          return;
        }

        // For serialized products, create a purchase item with quantity = 1
        final purchaseItem = PurchaseCartItem(
          productId: selectedProductId.value,
          name: dropdownController.text.trim(),
          purchasePrice: unitPrice.value.text.trim(),
          unit: selectedUnit.toString().trim(),
          quantity: "1", // Always 1 for serialized products
          totalPrice: totalPrice.value.text.trim(),
          variantId: variant.variantId,
        );

        // Update sub total
        final double newTotalPrice =
            double.tryParse(totalPrice.value.text.trim()) ?? 0.0;
        subTotal.value += newTotalPrice;
        originalSubTotal.value += newTotalPrice;

        // Calculate net total including fees
        calculateNetTotal();
        calculateOriginalNetTotal();

        // Add the purchase item and reset fields
        allPurchases.add(purchaseItem);

        // Remove the used variant from available list
        availableVariants.removeWhere((v) => v.variantId == variant.variantId);
        selectedVariantId.value = -1;

        // Clear input fields
        _clearInputFields();

        // Show success feedback
        TLoaders.successSnackBar(
          title: "Product Added",
          message: "Serial number ${variant.serialNumber} added to purchase",
        );
      } else {
        // For regular products

        // VALIDATION CHECK 7: Form validation
        if (!addUnitPriceAndQuantityKey.currentState!.validate() ||
            !addUnitTotalKey.currentState!.validate()) {
          TLoaders.errorSnackBar(
            title: 'Required Fields Missing',
            message: 'Please fill all required fields to continue',
          );
          return;
        }

        // VALIDATION CHECK 8: Empty values
        if (unitPrice.value.text.isEmpty ||
            quantity.text.isEmpty ||
            totalPrice.value.text.isEmpty) {
          TLoaders.errorSnackBar(
            title: 'Missing Values',
            message: 'Please enter price and quantity values',
          );
          return;
        }

        // VALIDATION CHECK 9: Numeric values
        double? unitPriceValue = double.tryParse(unitPrice.value.text);
        double? quantityValue = double.tryParse(quantity.text);
        double? totalPriceValue = double.tryParse(totalPrice.value.text);

        if (unitPriceValue == null ||
            quantityValue == null ||
            totalPriceValue == null) {
          TLoaders.errorSnackBar(
            title: 'Invalid Values',
            message: 'Price and quantity must be valid numbers',
          );
          return;
        }

        // VALIDATION CHECK 10: Non-negative values
        if (unitPriceValue <= 0) {
          TLoaders.errorSnackBar(
            title: 'Invalid Unit Price',
            message: 'Unit price must be greater than zero',
          );
          return;
        }

        if (quantityValue <= 0) {
          TLoaders.errorSnackBar(
            title: 'Invalid Quantity',
            message: 'Quantity must be greater than zero',
          );
          return;
        }

        if (totalPriceValue <= 0) {
          TLoaders.errorSnackBar(
            title: 'Invalid Total Price',
            message: 'Total price must be greater than zero',
          );
          return;
        }

        // Try to find existing product with same ID and unit if merging is enabled
        if (mergeIdenticalProducts.value) {
          int index = _findExistingProductIndex(
              selectedProductId.value, selectedUnit.value);

          if (index >= 0) {
            // Existing product found, update its quantity and total price
            _mergeWithExistingProduct(index, quantityValue, totalPriceValue);
            _clearInputFields();
            return;
          }
        }

        // Create a regular purchase item as a new entry
        PurchaseCartItem purchaseItem = PurchaseCartItem(
          productId: selectedProductId.value,
          name: dropdownController.text.trim(),
          purchasePrice: unitPrice.value.text.trim(),
          unit: selectedUnit.toString().split('.').last.trim(),
          quantity: quantity.text.trim(),
          totalPrice: totalPrice.value.text.trim(),
        );

        // Update sub total
        double newTotalPrice = double.tryParse(totalPrice.value.text) ?? 0.0;
        subTotal.value += newTotalPrice;
        originalSubTotal.value += newTotalPrice;

        // Calculate net total including fees
        calculateNetTotal();
        calculateOriginalNetTotal();

        // Add the purchase item and reset fields
        allPurchases.add(purchaseItem);

        // Clear input fields
        _clearInputFields();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in addProduct: $e');
      }
      TLoaders.errorSnackBar(
        title: 'Error Adding Product',
        message: 'An error occurred while adding the product: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Find index of an existing product with matching productId and unit
  int _findExistingProductIndex(int productId, UnitType unit) {
    String unitString = unit.toString().split('.').last.trim();

    for (int i = 0; i < allPurchases.length; i++) {
      // Skip serialized products (with variantId)
      if (allPurchases[i].variantId != null) continue;

      if (allPurchases[i].productId == productId &&
          allPurchases[i].unit == unitString) {
        return i;
      }
    }
    return -1;
  }

  // Merge new product with existing one
  void _mergeWithExistingProduct(
      int index, double newQuantity, double newTotalPrice) {
    try {
      // Get existing purchase item
      PurchaseCartItem existingItem = allPurchases[index];

      // Parse existing values
      double existingQuantity = double.tryParse(existingItem.quantity) ?? 0;
      double existingTotalPrice = double.tryParse(existingItem.totalPrice) ?? 0;

      // Calculate new values
      double updatedQuantity = existingQuantity + newQuantity;
      double updatedTotalPrice = existingTotalPrice + newTotalPrice;

      // Create updated purchase item
      PurchaseCartItem updatedItem = PurchaseCartItem(
        productId: existingItem.productId,
        name: existingItem.name,
        purchasePrice: existingItem.purchasePrice,
        unit: existingItem.unit,
        quantity: updatedQuantity.toString(),
        totalPrice: updatedTotalPrice.toString(),
      );

      // Update in list
      allPurchases[index] = updatedItem;

      // Update sub total
      subTotal.value += newTotalPrice;
      originalSubTotal.value += newTotalPrice;

      // Calculate net total including fees
      calculateNetTotal();
      calculateOriginalNetTotal();

      // Show success message
      TLoaders.successSnackBar(
        title: "Product Updated",
        message: "Added quantity to existing ${existingItem.name}",
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error merging products: $e');
      }
      TLoaders.errorSnackBar(
        title: 'Error Updating Product',
        message: 'Failed to update quantity: ${e.toString()}',
      );
    }
  }

  // Helper method to clear input fields after adding/updating products
  void _clearInputFields() {
    dropdownController.clear();
    unitPrice.value.clear();
    unit.clear();
    quantity.text = '';
    totalPrice.value.clear();
    isSerializedProduct.value = false;
  }

  Future<int> checkOut() async {
    try {
      isCheckingOut.value = true;

      // Validate that there are purchases to checkout
      if (allPurchases.isEmpty) {
        TLoaders.errorSnackBar(
            title: 'Checkout Error', message: 'No products added to checkout.');
        return -1;
      }

      // Validate vendor form fields
      if (!vendorFormKey.currentState!.validate()) {
        TLoaders.errorSnackBar(
            title: 'Vendor Information Error',
            message: 'Please fill all required vendor fields.');
        return -1;
      }

      // Validate user form fields
      if (!userFormKey.currentState!.validate()) {
        TLoaders.errorSnackBar(
            title: 'User Information Error',
            message: 'Please fill all required user fields.');
        return -1;
      }

      // Validate specific critical fields
      if (vendorNameController.text.isEmpty) {
        TLoaders.errorSnackBar(
            title: 'Vendor Error', message: 'Please select a vendor.');
        return -1;
      }

      if (selectedDate.value == null) {
        TLoaders.errorSnackBar(
            title: 'Date Error', message: 'Please select a valid date.');
        return -1;
      }

      if (selectedAddressId == null || selectedAddressId == -1) {
        TLoaders.errorSnackBar(
            title: 'Address Error', message: 'Please select a valid address.');
        return -1;
      }

      // Validate paid amount
      double paidAmountValue = double.tryParse(paidAmount.text.trim()) ?? 0.0;
      if (paidAmountValue < 0) {
        TLoaders.errorSnackBar(
            title: 'Payment Error',
            message: 'Please enter a valid paid amount.');
        return -1;
      }

      // Store serialized variants to mark as available later (since we're purchasing them)
      final List<int> serializedVariantIds = [];
      for (var item in allPurchases) {
        if (item.variantId != null) {
          serializedVariantIds.add(item.variantId!);
        }
      }

      // Create a PurchaseModel instance with formatted date
      PurchaseModel purchase = PurchaseModel(
        discount: double.tryParse(discount.value.replaceAll('%', '')) ?? 0.0,
        shippingFee: shopController.selectedShop!.value.shippingPrice,
        tax: shopController.selectedShop!.value.taxrate,
        purchaseId: -1, // Using -1 as a temporary ID
        purchaseDate: formatDate(selectedDate.value ?? DateTime.now()),
        subTotal: subTotal.value,
        status: statusCheck(),
        addressId: selectedAddressId,
        userId: userController.currentUser.value.userId,
        paidAmount: paidAmountValue,
        vendorId: vendorController.selectedVendor.value.vendorId,
      );

      // Create purchase items from cart items (convert to database model)
      final List<PurchaseItemModel> purchaseItems = allPurchases.map((item) {
        int qty = int.tryParse(item.quantity) ?? 0;
        double price = double.tryParse(item.totalPrice) ?? 0.0;
        return PurchaseItemModel(
          productId: item.productId,
          price: price,
          quantity: qty,
          purchaseId: -1, // Will be updated after purchase creation
          unit: item.unit.toString().split('.').last,
          variantId: item.variantId,
        );
      }).toList();

      purchase = purchase.copyWith(purchaseItems: purchaseItems);

      // Upload purchase to repository
      int purchaseId = await purchaseRepository.uploadPurchase(
          purchase.toJson(isUpdate: true), purchase.purchaseItems ?? []);

      // Ensure purchaseId is valid before proceeding
      if (purchaseId > 0) {
        // Assign actual purchaseId to each purchase item
        purchase = purchase.copyWith(
          purchaseId: purchaseId,
          purchaseItems: purchase.purchaseItems
              ?.map((item) => item.copyWith(purchaseId: purchaseId))
              .toList(),
        );

        // Add the purchase to the allPurchases list in PurchaseController
        final PurchaseController purchaseController =
            Get.find<PurchaseController>();
        purchaseController.allPurchases.insert(0, purchase);
        purchaseController.currentPurchases.insert(0, purchase);
        purchaseController.allPurchases.refresh();
        purchaseController.currentPurchases.refresh();

        try {
          // For purchases, we don't update stock automatically - that happens when status changes to "received"
          // But we can mark serialized variants as available (assuming they're now in our inventory)
          if (serializedVariantIds.isNotEmpty &&
              purchase.status == 'received') {
            final productVariantsRepository =
                Get.find<ProductVariantsRepository>();
            for (var variantId in serializedVariantIds) {
              await productVariantsRepository.markVariantAsAvailable(variantId);
              if (kDebugMode) {
                print('Marked variant $variantId as available');
              }
            }
          }

          // Clear all purchase data
          clearPurchaseDetails();

          // Show success message
          TLoaders.successSnackBar(
            title: 'Purchase Recorded Successfully',
            message: 'Purchase #$purchaseId has been recorded successfully.',
          );

          return purchaseId;
        } catch (e) {
          if (kDebugMode) {
            print('Error updating stock: $e');
          }
          TLoaders.errorSnackBar(
              title: 'Stock Update Error', message: e.toString());
          return purchaseId; // Still return purchaseId as the purchase was created
        }
      } else {
        if (kDebugMode) {
          print('Purchase upload failed');
        }
        TLoaders.errorSnackBar(
          title: 'Purchase Creation Failed',
          message: 'Failed to create purchase. Please try again.',
        );
        return -1;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Checkout error: $e');
      }
      TLoaders.errorSnackBar(
        title: 'Checkout Error',
        message: 'An error occurred during checkout: ${e.toString()}',
      );
      return -1;
    } finally {
      isCheckingOut.value = false;
    }
  }

  // Helper method to format date as YYYY-MM-DD
  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Reset form fields only - used internally
  void resetFields() {
    try {
      isSerializedProduct.value = false;
      unitPrice.value.text = '';
      unit.text = '';
      quantity.text = '';
      totalPrice.value.text = '';
      discountController.text = '';
      dropdownController.text = '';
      selectedProductName.value = '';
      selectedProductId.value = -1;
      isManualTextEntry.value = false;
      selectedVariantId.value = -1;
      if (availableVariants.isNotEmpty) {
        availableVariants.clear();
      }
      selectedChipIndex.value = -1;
      selectedChipValue.value = '';
      selectedUnit.value = UnitType.item;
      paidAmount.text = '';
      remainingAmount.value.text = '';

      Future.microtask(() {
        update();
      });
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Reset Error', message: e.toString());
    }
  }

  // Clear all purchase-related data after successful checkout or when needed
  void clearPurchaseDetails() {
    try {
      // Clear vendor information
      vendorNameController.clear();
      vendorPhoneNoController.value.clear();
      vendorEmailController.value.clear();
      vendorAddressController.value.clear();
      selectedAddressId = -1;
      entityId.value = -1;

      // Clear vendor image from media controller
      try {
        final mediaController = Get.find<MediaController>();
        mediaController.displayImage.value = null;
      } catch (e) {
        if (kDebugMode) {
          print('Error clearing media controller: $e');
        }
      }

      // Clear product selection
      selectedProductName.value = '';
      selectedProductId.value = -1;
      selectedUnit.value = UnitType.item;

      // Clear cart
      allPurchases.clear();
      subTotal.value = 0.0;
      netTotal.value = 0.0;
      originalSubTotal.value = 0.0;
      originalNetTotal.value = 0.0;

      // Reset form fields
      resetFields();

      // Reset discount
      discount.value = '';

      // Refresh the UI
      update();
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Clear Details Error', message: e.toString());
    }
  }

  String statusCheck() {
    try {
      double paidAmountValue = double.tryParse(paidAmount.text) ?? 0.0;
      double remainingAmountValue = netTotal.value - paidAmountValue;

      if (remainingAmountValue <= 0.01) {
        return PurchaseStatus.received.name.toString();
      } else {
        return PurchaseStatus.pending.name.toString();
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return '';
    }
  }

  // Toggle the expansion state
  void toggleExpanded() {
    isExpanded.value = !isExpanded.value;
  }

  void deleteItem(PurchaseCartItem purchaseItem, int index) {
    try {
      double? totalPrice = double.tryParse(
          purchaseItem.totalPrice.replaceAll(RegExp(r'[^0-9.]'), ''));

      String cleanedRemaining =
          remainingAmount.value.text.replaceAll(RegExp(r'[^0-9.]'), '');

      if (cleanedRemaining.contains('.')) {
        List<String> parts = cleanedRemaining.split('.');
        if (parts.length > 1) {
          cleanedRemaining =
              '${parts[0]}.${parts[1].substring(0, parts[1].length > 2 ? 2 : parts[1].length)}';
        }
      }

      double? remaining = double.tryParse(cleanedRemaining);

      if (totalPrice == null) {
        throw Exception("Invalid totalPrice: ${purchaseItem.totalPrice}");
      }

      if (remaining == null) {
        throw Exception(
            "Invalid remainingAmount: ${remainingAmount.value.text}");
      }

      // Update sub total
      subTotal.value = (subTotal.value - totalPrice).abs() < 1e-10
          ? 0
          : subTotal.value - totalPrice;

      // Update original sub total to reflect item removal
      originalSubTotal.value =
          (originalSubTotal.value - totalPrice).abs() < 1e-10
              ? 0
              : originalSubTotal.value - totalPrice;

      // Recalculate net total including fees
      calculateNetTotal();
      calculateOriginalNetTotal();

      // Remove the item from the list
      allPurchases.removeAt(index);
    } catch (e) {
      print("Error: $e");
      TLoaders.errorSnackBar(title: e.toString());
    }
  }

  void restoreDiscount() {
    try {
      if (selectedChipIndex.value == -1 || selectedChipValue.value.isEmpty)
        return;

      subTotal.value = originalSubTotal.value;
      calculateNetTotal();
      calculateOriginalNetTotal();
      selectedChipValue.value = '';
      selectedChipIndex.value = -1;
    } catch (e) {
      TLoaders.errorSnackBar(title: e.toString());
    }
  }

  int _getChipIndex(String discountText) {
    if (discountText == shopController.profile1.text) return 0;
    if (discountText == shopController.profile2.text) return 1;
    if (discountText == shopController.profile3.text) return 2;
    return -1;
  }

  bool purchaseValidator() {
    try {
      if (allPurchases.isEmpty) {
        TLoaders.errorSnackBar(
            title: 'Checkout Error', message: 'No products added to checkout.');
        return false;
      }
      if ((!vendorFormKey.currentState!.validate() &&
              !userFormKey.currentState!.validate()) ||
          vendorNameController.text == "" ||
          selectedDate.value == null) {
        TLoaders.errorSnackBar(
            title: 'Checkout Error', message: 'Fill all the fields.');
        return false;
      }

      if (selectedAddressId == -1) {
        TLoaders.errorSnackBar(
            title: 'Address Error', message: 'Select Valid Address.');
        return false;
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
        TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      }
      return false;
    }
  }

  void applyDiscountInChips(String discountText) {
    try {
      if (selectedChipIndex.value != -1 &&
          selectedChipValue.value == discountText) {
        restoreDiscount();
        return;
      }

      if (discount.value.isNotEmpty) {
        restoreDiscount();
        discountController.clear();
      }

      String percentageString = discountText.replaceAll('%', '');
      double? discountPercentage = double.tryParse(percentageString);

      if (discountPercentage == null ||
          discountPercentage < 0 ||
          discountPercentage > 100) {
        TLoaders.errorSnackBar(
          title: "Invalid Discount",
          message: 'Please select a valid discount percentage (0% to 100%).',
        );
        return;
      }

      double discountAmount =
          (originalSubTotal.value * discountPercentage) / 100;

      subTotal.value = originalSubTotal.value - discountAmount;
      calculateNetTotal();
      selectedChipValue.value = discountText;
      selectedChipIndex.value = _getChipIndex(discountText);
    } catch (e) {
      TLoaders.errorSnackBar(title: e.toString());
    }
  }

  void applyDiscountInField(String value) {
    if (selectedChipIndex.value != -1) {
      restoreDiscount();
    }

    String cleanedValue = value.replaceAll(RegExp(r'[^0-9.]'), '');

    if (cleanedValue.split('.').length > 2) {
      List<String> parts = cleanedValue.split('.');
      cleanedValue = '${parts[0]}.${parts.sublist(1).join()}';
    }

    double enteredPercentage = double.tryParse(cleanedValue) ?? 0.0;
    double currentOriginalSubTotal = originalSubTotal.value;
    double discountAmount = (enteredPercentage / 100) * currentOriginalSubTotal;

    if (enteredPercentage > 100) {
      discountController.text = "0.0";
      discount.value = "0.0";
      subTotal.value = currentOriginalSubTotal;
      calculateNetTotal();

      TLoaders.errorSnackBar(
        title: "Invalid Discount",
        message: "Discount cannot exceed 100%.",
      );
    } else {
      discount.value = "$cleanedValue%";
      subTotal.value = currentOriginalSubTotal - discountAmount;
      calculateNetTotal();
    }
  }

  void selectVariant(ProductVariantModel variant) {
    selectedVariantId.value = variant.variantId ?? -1;

    if (variant.variantId != null) {
      unitPrice.value.text = variant.purchasePrice.toString();
      quantity.text = "1";
      totalPrice.value.text = variant.purchasePrice.toString();
    }
  }

  Future<void> loadAvailableVariants(int productId) async {
    try {
      isLoadingVariants.value = true;
      selectedVariantId.value = -1;
      availableVariants.clear();

      if (productId <= 0) return;

      final productController = Get.find<ProductController>();
      final product = productController.allProducts.firstWhere(
        (p) => p.productId == productId,
        orElse: () => ProductModel.empty(),
      );

      if (!product.hasSerialNumbers) return;

      final variants = await productController.getAvailableVariants(productId);
      availableVariants.assignAll(variants);

      if (variants.isNotEmpty) {
        unitPrice.value.text = "";
        quantity.text = "1";
        totalPrice.value.text = "";
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading variants: $e');
      }
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to load product variants: $e',
      );
    } finally {
      isLoadingVariants.value = false;
    }
  }

  void addCustomUnit(String unitName, {double conversionFactor = 1.0}) {
    if (unitName.isEmpty) return;

    if (!customUnits.contains(unitName)) {
      customUnits.add(unitName);
      customUnitFactors[unitName] = conversionFactor;
    }

    customUnitName.value = unitName;
    selectedUnit.value = UnitType.custom;

    TLoaders.successSnackBar(
      title: "Custom Unit Added",
      message: "The unit '$unitName' has been added successfully",
    );
  }

  void selectCustomUnit(String unitName) {
    if (unitName.isEmpty) return;
    customUnitName.value = unitName;
    selectedUnit.value = UnitType.custom;
  }

  void clearCustomUnit() {
    customUnitName.value = '';
    selectedUnit.value = UnitType.item;
  }

  double getCurrentUnitFactor() {
    if (selectedUnit.value == UnitType.custom &&
        customUnitName.value.isNotEmpty) {
      return customUnitFactors[customUnitName.value] ?? 1.0;
    }
    return unitConversionFactors[selectedUnit.value] ?? 1.0;
  }

  void calculateTotalPrice() {
    try {
      double unitPriceValue = double.tryParse(unitPrice.value.text) ?? 0.0;
      double quantityValue = double.tryParse(quantity.text) ?? 0.0;

      double factor = getCurrentUnitFactor();
      double convertedQuantity = quantityValue * factor;

      double totalPriceValue = unitPriceValue * convertedQuantity;
      totalPrice.value.text = totalPriceValue.toStringAsFixed(2);
    } catch (e) {
      if (kDebugMode) {
        print('Error calculating total price: $e');
      }
    }
  }

  Future<void> handleVendorSelection(String val) async {
    final addressController = Get.find<AddressController>();
    final mediaController = Get.find<MediaController>();

    if (val.isEmpty) {
      vendorController.selectedVendor.value = VendorModel.empty();
      vendorPhoneNoController.value.clear();
      vendorEmailController.value.clear();
      vendorAddressController.value.clear();
      selectedAddressId = null;
      mediaController.displayImage.value = null;
      return;
    }

    vendorController.selectedVendor.value = vendorController.allVendors
        .firstWhere((vendor) => vendor.fullName == val);

    await addressController.fetchEntityAddresses(
        vendorController.selectedVendor.value.vendorId!, EntityType.vendor);

    entityId.value = vendorController.selectedVendor.value.vendorId!;

    vendorPhoneNoController.value.text =
        vendorController.selectedVendor.value.phoneNumber;

    vendorEmailController.value.text =
        vendorController.selectedVendor.value.email;

    // Use the existing address controller properties for customer addresses
    // since vendor addresses might use the same structure
    if (addressController.allVendorAddressesLocation.isNotEmpty) {
      final firstAddress = addressController.allVendorAddressesLocation.first;

      vendorAddressController.value.text = firstAddress;

      addressController.selectedVendorAddress.value = addressController
          .allVendorAddresses
          .firstWhere((address) => address.location == firstAddress);
      selectedAddressId =
          addressController.selectedVendorAddress.value.addressId;
    }
  }

  void calculateNetTotal() {
    try {
      double shippingFee =
          shopController.selectedShop?.value.shippingPrice ?? 0.0;
      double tax = shopController.selectedShop?.value.taxrate ?? 0.0;

      netTotal.value = subTotal.value + shippingFee + tax;
      updateRemainingAmount();
    } catch (e) {
      if (kDebugMode) {
        print('Error calculating net total: $e');
      }
    }
  }

  void calculateOriginalNetTotal() {
    try {
      double shippingFee =
          shopController.selectedShop?.value.shippingPrice ?? 0.0;
      double tax = shopController.selectedShop?.value.taxrate ?? 0.0;

      originalNetTotal.value = originalSubTotal.value + shippingFee + tax;
    } catch (e) {
      if (kDebugMode) {
        print('Error calculating original net total: $e');
      }
    }
  }

  void updateRemainingAmount() {
    try {
      double currentPaidAmount = double.tryParse(paidAmount.text) ?? 0.0;
      remainingAmount.value.text =
          (netTotal.value - currentPaidAmount).toStringAsFixed(2);
    } catch (e) {
      if (kDebugMode) {
        print('Error updating remaining amount: $e');
      }
    }
  }

  
}
