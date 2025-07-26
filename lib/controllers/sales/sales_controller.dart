import 'package:ecommerce_dashboard/Models/address/address_model.dart';
import 'package:ecommerce_dashboard/Models/customer/customer_model.dart';
import 'package:ecommerce_dashboard/Models/products/product_variant_model.dart';
import 'package:ecommerce_dashboard/Models/sales/sale_model.dart';
import 'package:ecommerce_dashboard/common/widgets/loaders/tloaders.dart';
import 'package:ecommerce_dashboard/controllers/address/address_controller.dart';
import 'package:ecommerce_dashboard/controllers/orders/orders_controller.dart';
import 'package:ecommerce_dashboard/utils/popups/loaders.dart';
import 'package:ecommerce_dashboard/controllers/media/media_controller.dart';
import 'package:ecommerce_dashboard/controllers/product/product_controller.dart';
import 'package:ecommerce_dashboard/controllers/salesman/salesman_controller.dart';
import 'package:ecommerce_dashboard/controllers/user/user_controller.dart';
import 'package:ecommerce_dashboard/repositories/products/product_variants_repository.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/enums.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../Models/orders/order_item_model.dart';

import '../../Models/products/product_model.dart';
import '../../repositories/order/order_repository.dart';
import '../customer/customer_controller.dart';
import '../shop/shop_controller.dart';
import '../../Models/salesman/salesman_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:iconsax/iconsax.dart';
import '../../views/reports/specific_reports/receipt_report/receipt_report.dart';

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
  // Alias for allSales for better mobile UI naming consistency
  RxList<SaleModel> get saleCartItem => allSales;

  // UI expansion states
  var isProductEntryExpanded = true.obs;
  var isSerialExpanded = true.obs;

  // Indicator for whether there are serial numbers to display
  RxBool hasSerialNumbers = false.obs;

  // Loading state for fetching products
  final isLoading = false.obs;
  final isCheckingOut = false.obs;

  //Variables
  Rx<String> selectedProductName = ''.obs;
  Rx<String> selectedVariantName = ''.obs;
  Rx<UnitType> selectedUnit = UnitType.item.obs;
  Rx<int> selectedProductId = (-1).obs;
  RxDouble subTotal = (0.0).obs; // Sum of all product prices only
  RxDouble netTotal =
      (0.0).obs; // subTotal + shipping + tax + salesman commission
  RxDouble originalSubTotal = (0.0).obs; // Original subTotal before discounts
  RxDouble originalNetTotal = (0.0).obs; // Original netTotal before discounts
  double buyingPriceIndividual = 0.0;
  double buyingPriceTotal = 0.0;
  Rx<String> discount = ''.obs;

  // Custom units support
  RxString customUnitName = ''.obs;
  RxList<String> customUnits = <String>[].obs;
  RxMap<String, double> customUnitFactors =
      <String, double>{}.obs; // Conversion factors for custom units

  // Toggle for merging products with same ID and unit
  RxBool mergeIdenticalProducts = true.obs;

  // Toggle for serialized product
  RxBool isSerialziedProduct = false.obs;

  // Unit conversion factors (relative to base unit)
  final Map<UnitType, double> unitConversionFactors = {
    UnitType.item: 1.0,
    UnitType.dozen: 12.0,
    UnitType.gross: 144.0,
    UnitType.kilogram: 1.0, // base unit for weight
    UnitType.gram: 0.001, // 1 gram = 0.001 kg
    UnitType.liter: 1.0, // base unit for volume
    UnitType.milliliter: 0.001, // 1 ml = 0.001 L
    UnitType.meter: 1.0, // base unit for length
    UnitType.centimeter: 0.01, // 1 cm = 0.01 m
    UnitType.inch: 0.0254, // 1 inch = 0.0254 m
    UnitType.foot: 0.3048, // 1 foot = 0.3048 m
    UnitType.yard: 0.9144, // 1 yard = 0.9144 m
    UnitType.box: 1.0, // depends on context
    UnitType.pallet: 1.0, // depends on context
    UnitType.custom: 1.0, // will be determined by customUnitFactors
  };

  //TextForm Controllers
  final unitPrice = TextEditingController().obs;
  final unit = TextEditingController();
  final quantity = TextEditingController();
  final totalPrice = TextEditingController().obs;
  final discountController = TextEditingController(); // to reset field to zero
  final dropdownController = TextEditingController(); // to reset field to zero

  final variantDropdownController =
      TextEditingController(); // to reset field to zero

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

  // Focus Nodes for Tab Order
  final FocusNode productNameFocus = FocusNode();
  final FocusNode variantNameFocus = FocusNode();
  final FocusNode unitPriceFocus = FocusNode();
  final FocusNode quantityFocus = FocusNode();
  final FocusNode totalPriceFocus = FocusNode();
  final FocusNode addButtonFocus = FocusNode();

  @override
  void onInit() {
    super.onInit();

    // Refresh product data to ensure accurate stock information
    // try {
    //   final productController = Get.find<ProductController>();
    //   productController.refreshProducts();
    // } catch (e) {
    //   if (kDebugMode) {
    //     print('Failed to refresh products: $e');
    //   }
    // }

    // Initialize values
    remainingAmount.value.text = "0.00";

    // Set current date
    selectedDate.value = DateTime.now();
  }

  @override
  void onClose() {
    // This method is called when the controller is being disposed
    // Clear sales data when navigating away
    try {
      clearSaleDetails();
    } catch (e) {
      if (kDebugMode) {
        print('Error in onClose: $e');
      }
    }
    super.onClose();
  }

  void setCustomerInfo(CustomerModel customer) {
    try {
      customerNameController.text = customer.fullName;
      customerPhoneNoController.value.text = customer.phoneNumber;
      customerCNICController.value.text = customer.cnic;
      entityId.value = customer.customerId ?? -1;

      //customer address
      final addressController = Get.find<AddressController>();
      customerAddressController.value.text =
          addressController.selectedOrderAddress.value.location;
      selectedAddressId =
          addressController.selectedOrderAddress.value.addressId;
    } catch (e) {
      if (kDebugMode) {
        TLoaders.errorSnackBar(title: e.toString());
        print('Error setting customer info: $e');
      }
    }
  }

  void setSalesmanInfo(SalesmanModel salesman) {
    try {
      salesmanNameController.text = salesman.fullName;
      salesmanCityController.value.text = salesman.city;
      salesmanAreaController.value.text = salesman.area;
      selectedSalesmanId = salesman.salesmanId ?? -1;
    } catch (e) {
      if (kDebugMode) {
        TLoaders.errorSnackBar(title: e.toString());
        print('Error setting salesman info: $e');
      }
    }
  }

  void setOrderInfo(OrderModel order, double remainingAmountValue) {
    try {
      //remaining amount
      remainingAmount.value.text = remainingAmountValue.toString();
      discount.value = order.discount.toString();
      subTotal.value = order.subTotal - order.discount;
      netTotal.value = order.subTotal -
          order.discount +
          order.shippingFee +
          (order.subTotal * (order.salesmanComission ?? 0)) / 100;
      //  originalSubTotal.value = order.originalSubTotal;
      //  originalNetTotal.value = order.originalNetTotal;
      //  buyingPriceTotal = order.buyingPriceTotal;
    } catch (e) {
      if (kDebugMode) {
        TLoaders.errorSnackBar(title: e.toString());
        print('Error setting order info: $e');
      }
    }
  }

  void setOrderItems(OrderModel order) {
    try {
      allSales.clear();

      //convert order items to sales
      final sales = convertOrderItemsToSales(order);

      allSales.addAll(sales);
    } catch (e) {
      if (kDebugMode) {
        TLoaders.errorSnackBar(title: e.toString());
        print('Error setting order items: $e');
      }
    }
  }

  List<SaleModel> convertOrderItemsToSales(OrderModel order) {
    try {
     
     return [];
    } catch (e) {
      if (kDebugMode) {
        TLoaders.errorSnackBar(title: e.toString());
        print('Error converting order items to sales: $e');
      }
        return [];
    }
  }

  // Method to manually reset sales data when navigating away (except to installments)
  void onNavigateAway(String targetRoute) {
    try {
      // Only clear if not going to installments
      if (targetRoute != '/installments') {
        clearSaleDetails();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing sales data on navigation: $e');
      }
    }
  }

  void setupUserDetails() {
    try {
      cashierNameController.value.text =
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
      if (availableVariants.isNotEmpty || selectedVariantId.value != -1) {
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

        if (variant.sellPrice <= 0) {
          TLoaders.errorSnackBar(
            title: "Invalid Price",
            message: 'The selected product has an invalid selling price',
          );
          return;
        }

        // For serialized products, create a sale with quantity = 1
        final sale = SaleModel(
          productId: selectedProductId.value,
          name: dropdownController.text.trim(),
          salePrice: unitPrice.value.text.trim(),
          unit: selectedUnit.toString().trim(),
          quantity: "1", // Always 1 for serialized products
          totalPrice: totalPrice.value.text.trim(),
          buyPrice: variant.buyPrice,
          variantId: variant.variantId,
        );
        // Update sub total (product prices only)
        final double newTotalPrice =
            double.tryParse(totalPrice.value.text.trim()) ?? 0.0;
        subTotal.value += newTotalPrice;
        originalSubTotal.value += newTotalPrice;
        buyingPriceTotal += variant.buyPrice;

        // Calculate net total including fees
        calculateNetTotal();
        calculateOriginalNetTotal();

        // Add the sale and reset fields
        allSales.add(sale);

        // Remove the used variant from available list
        availableVariants.removeWhere((v) => v.variantId == variant.variantId);
        selectedVariantId.value = -1;

        // Clear input fields
        _clearInputFields();

        // Show success feedback
        TLoaders.successSnackBar(
          title: "Product Added",
          message: "Serial number ${variant.variantName} added to sale",
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

        // VALIDATION CHECK 11: Stock availability
        int currentStock = product.stockQuantity ?? 0;
        double requiredStock = quantityValue;

        // Consider the unit conversion factor for stock calculation
        if (selectedUnit.value != UnitType.item) {
          double factor = getCurrentUnitFactor();
          requiredStock = quantityValue * factor;
        }

        // Check if product is already in cart, and adjust existing quantities
        double existingQuantity = 0;
        for (var sale in allSales) {
          if (sale.productId == selectedProductId.value &&
              sale.variantId == null) {
            double saleQty = double.tryParse(sale.quantity) ?? 0;

            // Convert to base unit for comparison
            String unitString = sale.unit;
            UnitType? saleUnitType;

            try {
              saleUnitType = UnitType.values.firstWhere(
                  (u) => u.toString().split('.').last.trim() == unitString);
            } catch (e) {
              // Use default if not found
              saleUnitType = UnitType.item;
            }

            double factor = 1.0;
            if (saleUnitType != UnitType.item) {
              factor = unitConversionFactors[saleUnitType] ?? 1.0;
            }

            existingQuantity += (saleQty * factor);
          }
        }

        if (currentStock < requiredStock + existingQuantity) {
          TLoaders.errorSnackBar(
            title: 'Insufficient Stock',
            message: 'Only $currentStock ${product.name} available in stock',
          );
          return;
        }

        // // VALIDATION CHECK 12: Price consistency
        // double calculatedTotal = unitPriceValue * quantityValue;
        // double tolerance = 0.01; // Allow small rounding differences

        // // if ((calculatedTotal - totalPriceValue).abs() > tolerance) {
        // //   TLoaders.warningSnackBar(
        // //     title: 'Price Discrepancy',
        // //     message:
        // //         'Total price doesn\'t match unit price × quantity. Continuing anyway.',
        // //   );
        // // }

        // Try to find existing product with same ID and unit if merging is enabled
        if (mergeIdenticalProducts.value) {
          int index = _findExistingProductIndex(
              selectedProductId.value, selectedUnit.value);

          if (index >= 0) {
            // Check if merging would exceed stock
            SaleModel existingSale = allSales[index];
            double existingQuantity =
                double.tryParse(existingSale.quantity) ?? 0;
            double newTotalQuantity = existingQuantity + quantityValue;

            // Convert to base unit for stock comparison
            double factor = 1.0;
            if (selectedUnit.value != UnitType.item) {
              factor = getCurrentUnitFactor();
            }

            double totalRequiredStock = newTotalQuantity * factor;

            if (currentStock < totalRequiredStock) {
              TLoaders.errorSnackBar(
                title: 'Insufficient Stock',
                message:
                    'Merging would exceed available stock. Only $currentStock ${product.name} available',
              );
              return;
            }

            // Existing product found, update its quantity and total price
            _mergeWithExistingProduct(index, quantityValue, totalPriceValue);

            // Clear input fields after merging
            _clearInputFields();
            return;
          }
        }

        // Create a regular sale as a new entry
        SaleModel sale = SaleModel(
          productId: selectedProductId.value,
          name: dropdownController.text.trim(),
          salePrice: unitPrice.value.text.trim(),
          unit: selectedUnit.toString().split('.').last.trim(),
          quantity: quantity.text.trim(),
          totalPrice: totalPrice.value.text.trim(),
          buyPrice: buyingPriceIndividual,
        );

        // Update sub total (product prices only)
        double newTotalPrice = double.tryParse(totalPrice.value.text) ?? 0.0;
        subTotal.value += newTotalPrice;
        originalSubTotal.value += newTotalPrice;
        buyingPriceTotal +=
            buyingPriceIndividual * (double.tryParse(quantity.text) ?? 0.0);

        // Calculate net total including fees
        calculateNetTotal();
        calculateOriginalNetTotal();

        // Add the sale and reset fields
        allSales.add(sale);

        // Clear input fields
        _clearInputFields();

        // // Show success feedback
        // TLoaders.successSnackBar(
        //   title: "Product Added",
        //   message: "${sale.name} added to sale",
        // );
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

    for (int i = 0; i < allSales.length; i++) {
      // Skip serialized products (with variantId)
      if (allSales[i].variantId != null) continue;

      if (allSales[i].productId == productId &&
          allSales[i].unit == unitString) {
        return i;
      }
    }
    return -1;
  }

  // Merge new product with existing one
  void _mergeWithExistingProduct(
      int index, double newQuantity, double newTotalPrice) {
    try {
      // Get existing sale
      SaleModel existingSale = allSales[index];

      // Parse existing values
      double existingQuantity = double.tryParse(existingSale.quantity) ?? 0;
      double existingTotalPrice = double.tryParse(existingSale.totalPrice) ?? 0;

      // Calculate new values
      double updatedQuantity = existingQuantity + newQuantity;
      double updatedTotalPrice = existingTotalPrice + newTotalPrice;

      // Create updated sale model
      SaleModel updatedSale = SaleModel(
        productId: existingSale.productId,
        name: existingSale.name,
        salePrice: existingSale.salePrice,
        unit: existingSale.unit,
        quantity: updatedQuantity.toString(),
        totalPrice: updatedTotalPrice.toString(),
        buyPrice: existingSale.buyPrice,
      );

      // Update in list
      allSales[index] = updatedSale;

      // Update sub total (product prices only)
      subTotal.value += newTotalPrice;
      originalSubTotal.value += newTotalPrice;
      // Use the existing sale's buyPrice to ensure consistency
      buyingPriceTotal += existingSale.buyPrice * newQuantity;

      // Calculate net total including fees
      calculateNetTotal();
      calculateOriginalNetTotal();

      // Show success message
      TLoaders.successSnackBar(
        title: "Product Updated",
        message: "Added quantity to existing ${existingSale.name}",
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
    isSerialziedProduct.value = false;
  }

  Future<int> checkOut() async {
    try {
      isCheckingOut.value = true;

      // Validate that there are sales to checkout
      if (allSales.isEmpty) {
        TLoaders.errorSnackBar(
            title: 'Checkout Error', message: 'No products added to checkout.');
        return -1;
      }

      // Validate customer form fields
      if (!customerFormKey.currentState!.validate()) {
        TLoaders.errorSnackBar(
            title: 'Customer Information Error',
            message: 'Please fill all required customer fields.');
        return -1;
      }

      // Validate salesman form fields
      if (!salesmanFormKey.currentState!.validate()) {
        TLoaders.errorSnackBar(
            title: 'Salesman Information Error',
            message: 'Please fill all required salesman fields.');
        return -1;
      }

      // Validate cashier form fields
      if (!cashierFormKey.currentState!.validate()) {
        TLoaders.errorSnackBar(
            title: 'Cashier Information Error',
            message: 'Please fill all required cashier fields.');
        return -1;
      }

      // Validate specific critical fields
      if (customerNameController.text.isEmpty) {
        TLoaders.errorSnackBar(
            title: 'Customer Error', message: 'Please select a customer.');
        return -1;
      }

      if (selectedDate.value == null) {
        TLoaders.errorSnackBar(
            title: 'Date Error', message: 'Please select a valid date.');
        return -1;
      }

      if (salesmanNameController.text.isEmpty) {
        TLoaders.errorSnackBar(
            title: 'Salesman Error', message: 'Please select a salesman.');
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

      // Store serialized variants to mark as sold later
      final List<int> serializedVariantIds = [];
      for (var sale in allSales) {
        if (sale.variantId != null) {
          serializedVariantIds.add(sale.variantId!);
        }
      }

      // print(buyingPriceTotal);

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
        subTotal: subTotal.value, // Use actual subTotal (product prices only)
        buyingPrice: buyingPriceTotal,
        status: statusCheck(),
        saletype: selectedSaleType.value.toString().split('.').last,
        addressId: selectedAddressId,
        salesmanId: selectedSalesmanId,
        userId: userController.currentUser.value.userId,
        paidAmount: paidAmountValue,
        customerId: customerController.selectedCustomer.value.customerId,
      );

      // Create order items with the correct variant IDs
      final List<OrderItemModel> orderItems = allSales.map((sale) {
        int quantity = int.tryParse(sale.quantity) ?? 0;
        // For serialized products (variantId != null), quantity is always 1
        // For regular products, multiply buyPrice by quantity to get total buying price
        double totalBuyingPrice = sale.variantId != null
            ? sale
                .buyPrice // For serialized products, buyPrice is already the total
            : sale.buyPrice *
                quantity; // For regular products, multiply by quantity

        return OrderItemModel(
          // orderItemId: -1,
          //createdAt: DateTime.now(),
          productId: sale.productId,
          orderId: -1,
          quantity: quantity,
          price: double.tryParse(sale.totalPrice) ?? 0.0,
          unit: sale.unit.toString().split('.').last,
          totalBuyPrice: totalBuyingPrice,
          variantId: sale.variantId,
        );
      }).toList();

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

        // Add the order to the allOrders and currentOrders lists in OrderController
        final OrderController orderController = Get.find<OrderController>();
        orderController.allOrders.insert(0, order); // Insert at the beginning
        orderController.currentOrders
            .insert(0, order); // Insert at the beginning
        orderController.allOrders.refresh(); // Refresh the list
        orderController.currentOrders.refresh(); // Refresh the list

        final ProductController productController =
            Get.find<ProductController>();

        try {
          // Mark serialized variants as sold
          if (serializedVariantIds.isNotEmpty) {
            final productVariantsRepository =
                Get.find<ProductVariantsRepository>();

            for (var variantId in serializedVariantIds) {
              await productVariantsRepository.toggleVariantVisibility(
                  variantId, false);
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

          // Close loading dialog
          Navigator.of(Get.context!).pop();

          // Generate PDF receipt
          try {
            showReceiptPdfReport(order);
            if (kDebugMode) {
              print('PDF Receipt generated successfully');
            }
          } catch (e) {
            if (kDebugMode) {
              print('Error generating PDF receipt: $e');
            }
            // Don't throw the error since receipt generation is not critical
          }

          // Clear all sales data
          clearSaleDetails();

          // Show success message
          TLoaders.successSnackBar(
            title: 'Order Placed Successfully',
            message: 'Order #$orderId has been placed successfully.',
          );

          return orderId;
        } catch (e) {
          Navigator.of(Get.context!).pop();
          if (kDebugMode) {
            print('Error updating stock: $e');
          }
          TLoaders.errorSnackBar(
              title: 'Stock Update Error', message: e.toString());
          return orderId; // Still return orderId as the order was created
        }
      } else {
        Navigator.of(Get.context!).pop();
        if (kDebugMode) {
          print('Order upload failed');
        }
        TLoaders.errorSnackBar(
          title: 'Order Creation Failed',
          message: 'Failed to create order. Please try again.',
        );
        return -1;
      }
    } catch (e) {
      // Close loading dialog if open
      if (Get.isDialogOpen == true) {
        Navigator.of(Get.context!).pop();
      }

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

  /* Commented out - replaced with PDF receipt
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
          text: '${order.subTotal}',
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
      PosColumn(text: 'Shipping:', width: 6),
      PosColumn(
          text: '${order.shippingFee}',
          width: 6,
          styles: const PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(text: 'Commission:', width: 6),
      PosColumn(
          text: '${order.salesmanComission}',
          width: 6,
          styles: const PosStyles(align: PosAlign.right)),
    ]);

    // Calculate net total for receipt
    double receiptNetTotal = order.subTotal +
        order.tax +
        order.shippingFee +
        order.salesmanComission;

    bytes += generator.row([
      PosColumn(text: 'Total:', width: 6, styles: const PosStyles(bold: true)),
      PosColumn(
        text: '${receiptNetTotal.toStringAsFixed(2)}',
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
        text:
            '${((order.paidAmount ?? 0) - receiptNetTotal).toStringAsFixed(2)}',
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
  */

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
      isSerialziedProduct.value = false;

      // Clear form controllers - ensure direct text assignment
      unitPrice.value.text = '';
      unit.text = '';
      quantity.text = '';
      totalPrice.value.text = '';
      discountController.text = '';

      // Important: To properly clear autocomplete, we need a direct text assignment
      // rather than just calling clear()
      dropdownController.text = '';
      variantDropdownController.text = '';

      // Reset product selection
      selectedProductName.value = '';
      selectedProductId.value = -1;
      isManualTextEntry.value = false;

      // Reset variant selection
      clearVariantSelection();

      // Reset form states
      selectedChipIndex.value = -1;
      selectedChipValue.value = '';
      selectedUnit.value = UnitType.item;

      // Clear payment fields
      paidAmount.text = '';
      remainingAmount.value.text = '';

      // Force UI update - use microtask to ensure this happens after the current frame
      Future.microtask(() {
        update();
      });
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Reset Error', message: e.toString());
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

      // Clear customer image from media controller
      try {
        final mediaController = Get.find<MediaController>();
        mediaController.displayImage.value = null;
      } catch (e) {
        if (kDebugMode) {
          print('Error clearing media controller: $e');
        }
      }

      // Clear salesman fields
      resetSalesmanFields();

      // Clear product selection
      selectedProductName.value = '';
      selectedProductId.value = -1;
      selectedUnit.value = UnitType.item;

      // Clear cart
      allSales.clear();
      subTotal.value = 0.0;
      netTotal.value = 0.0;
      originalSubTotal.value = 0.0;
      originalNetTotal.value = 0.0;
      buyingPriceTotal = 0.0;
      buyingPriceIndividual = 0.0;
      // isSerialziedProduct.value = false;

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
        // Allow small rounding differences
        return OrderStatus.completed.name.toString();
      } else {
        return OrderStatus.pending.name.toString();
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
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
  //     TLoaders.errorsnackBar(title: 'Oh Snap!', message: e.toString());
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

      // Calculate buying price to subtract from buyingPriceTotal
      double buyingPriceToSubtract = 0.0;

      // For serialized products (variantId is not null)
      if (saleItem.variantId != null) {
        // For serialized products, quantity is always 1, so just subtract the buyPrice
        buyingPriceToSubtract = saleItem.buyPrice;
      } else {
        // For regular products, multiply buyPrice by quantity
        double quantity = double.tryParse(saleItem.quantity) ?? 0.0;
        buyingPriceToSubtract = saleItem.buyPrice * quantity;
      }

      // Update sub total (product prices only)
      subTotal.value = (subTotal.value - totalPrice).abs() < 1e-10
          ? 0
          : subTotal.value - totalPrice;

      // Update original sub total to reflect item removal
      originalSubTotal.value =
          (originalSubTotal.value - totalPrice).abs() < 1e-10
              ? 0
              : originalSubTotal.value - totalPrice;

      // Update buyingPriceTotal to reflect item removal
      buyingPriceTotal =
          (buyingPriceTotal - buyingPriceToSubtract).abs() < 1e-10
              ? 0
              : buyingPriceTotal - buyingPriceToSubtract;

      // Recalculate net total including fees
      calculateNetTotal();
      calculateOriginalNetTotal();

      // Remove the item from the list
      allSales.removeAt(index);
    } catch (e) {
      print("Error: $e"); // Debugging
      TLoaders.errorSnackBar(title: e.toString());
    }
  }

  void restoreDiscount() {
    try {
      // If no discount is selected, do nothing
      if (selectedChipIndex.value == -1 || selectedChipValue.value.isEmpty)
        return;

      // Reset subTotal to the original value
      subTotal.value = originalSubTotal.value;

      // Recalculate net total including fees
      calculateNetTotal();
      calculateOriginalNetTotal();

      // Clear the selected chip value and index
      selectedChipValue.value = '';
      selectedChipIndex.value = -1;

      // Show success message
      // TLoaders.successSnackBar(
      //   title: "Discount Restored",
      //   message: 'Discount restored successfully.',
      // );
    } catch (e) {
      TLoaders.errorSnackBar(title: e.toString());
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
        TLoaders.errorSnackBar(
            title: 'Checkout Error', message: 'No products added to checkout.');
        return false;
      }
      if ((!salesmanFormKey.currentState!.validate() &&
              !customerFormKey.currentState!.validate() &&
              !cashierFormKey.currentState!.validate()) ||
          customerNameController.text == "" ||
          selectedDate.value == null ||
          salesmanNameController.text == "") {
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
        TLoaders.errorSnackBar(
          title: "Invalid Discount",
          message: 'Please select a valid discount percentage (0% to 100%).',
        );
        return;
      }

      // Calculate the discount amount based on the original sub total
      double discountAmount =
          (originalSubTotal.value * discountPercentage) / 100;

      // Apply discount to sub total
      subTotal.value = originalSubTotal.value - discountAmount;

      // Recalculate net total including fees
      calculateNetTotal();

      // Update the selected chip value and index
      selectedChipValue.value = discountText;
      selectedChipIndex.value = _getChipIndex(discountText);
    } catch (e) {
      TLoaders.errorSnackBar(title: e.toString());
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

    // Reset sub total to original before applying a new discount
    double currentOriginalSubTotal = originalSubTotal.value;

    // Calculate discount amount
    double discountAmount = (enteredPercentage / 100) * currentOriginalSubTotal;

    // Validate the discount percentage (should not exceed 100%)
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
      discount.value = "$cleanedValue%"; // Ensure percentage format
      subTotal.value = currentOriginalSubTotal - discountAmount;

      // Recalculate net total including fees
      calculateNetTotal();
    }
  }

  // Add this method after the onInit method
  void selectVariant(ProductVariantModel variant) {
    selectedVariantId.value = variant.variantId ?? -1;

    // Update the unit price and total price fields with the variant's selling price
    if (variant.variantId != null) {
      unitPrice.value.text = variant.sellPrice.toString();
      quantity.text = "1"; // For serialized products, quantity is always 1
      totalPrice.value.text = variant.sellPrice.toString();
      buyingPriceIndividual = variant.buyPrice;
    }
  }

  // Method to clear variant selection
  void clearVariantSelection() {
    selectedVariantId.value = -1;
    selectedVariantName.value = '';
    variantDropdownController.text = '';
    availableVariants.clear();
  }

  // Add this method after the setupUserDetails method
  Future<void> loadAvailableVariants(int productId) async {
    try {
      isLoadingVariants.value = true;
      selectedVariantId.value = -1;

      // Reset fields
      availableVariants.clear();

      if (productId <= 0) {
        return;
      }

      // Get the product
      final productController = Get.find<ProductController>();
      final product = productController.allProducts.firstWhere(
        (p) => p.productId == productId,
        orElse: () => ProductModel.empty(),
      );

      if (product.productId == null) {
        return;
      }

      // Load available variants
      final variants = await productController.getVisibleVariants(productId);

      // Use assignAll to trigger reactive updates - no need for manual update() calls
      availableVariants.assignAll(variants);
      availableVariants.refresh();

      // // If variants are available, update the UI
      // if (variants.isNotEmpty) {
      //   unitPrice.value.text = "";
      //   quantity.text = "1"; // For serialized products, quantity is always 1
      //   totalPrice.value.text = "";
      // }
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to load product variants: $e',
      );
    } finally {
      isLoadingVariants.value = false;
    }
  }

  // Add this method to handle custom unit additions
  void addCustomUnit(String unitName, {double conversionFactor = 1.0}) {
    if (unitName.isEmpty) return;

    // Check if the unit already exists
    if (!customUnits.contains(unitName)) {
      customUnits.add(unitName);
      customUnitFactors[unitName] = conversionFactor;
    }

    // Set the current custom unit name
    customUnitName.value = unitName;
    selectedUnit.value = UnitType.custom;

    // Show success message
    TLoaders.successSnackBar(
      title: "Custom Unit Added",
      message: "The unit '$unitName' has been added successfully",
    );
  }

  // Method to select a custom unit
  void selectCustomUnit(String unitName) {
    if (unitName.isEmpty) return;

    customUnitName.value = unitName;
    selectedUnit.value = UnitType.custom;
  }

  // Clear custom unit selection
  void clearCustomUnit() {
    customUnitName.value = '';
    selectedUnit.value = UnitType.item; // Reset to default unit
  }

  // Get the current unit conversion factor
  double getCurrentUnitFactor() {
    if (selectedUnit.value == UnitType.custom &&
        customUnitName.value.isNotEmpty) {
      return customUnitFactors[customUnitName.value] ?? 1.0;
    }
    return unitConversionFactors[selectedUnit.value] ?? 1.0;
  }

  // Method to calculate total price based on unit, quantity and unit price
  void calculateTotalPrice() {
    try {
      // Get values from controllers
      double unitPriceValue = double.tryParse(unitPrice.value.text) ?? 0.0;
      double quantityValue = double.tryParse(quantity.text) ?? 0.0;

      // Apply unit conversion if needed
      double factor = getCurrentUnitFactor();
      double convertedQuantity = quantityValue * factor;

      // Calculate total price
      double totalPriceValue = unitPriceValue * convertedQuantity;

      // Update the total price field
      totalPrice.value.text = totalPriceValue.toStringAsFixed(2);
    } catch (e) {
      if (kDebugMode) {
        print('Error calculating total price: $e');
      }
    }
  }

  // Reset salesman fields - safer implementation
  void resetSalesmanFields() {
    try {
      // Reset all fields in a controlled way
      salesmanNameController.text = '';
      salesmanCityController.value.text = '';
      salesmanAreaController.value.text = '';

      // Use the handleSalesmanSelection method to reset totals
      handleSalesmanSelection(-1);

      // Make sure selection position is updated to trigger listeners
      salesmanNameController.selection =
          TextSelection.fromPosition(const TextPosition(offset: 0));

      // Update UI state without forcing app refresh
      update();
    } catch (e) {
      if (kDebugMode) {
        print('Error resetting salesman fields: $e');
      }
    }
  }

  // Add this method to handle customer selection and field population
  Future<void> handleCustomerSelection(String val) async {
    final addressController = Get.find<AddressController>();
    final mediaController = Get.find<MediaController>();
    if (val.isEmpty) {
      customerController.selectedCustomer.value = CustomerModel.empty();
      customerPhoneNoController.value.clear();
      customerCNICController.value.clear();
      addressController.selectedCustomerAddress.value = AddressModel.empty();
      customerAddressController.value.clear();
      selectedAddressId = null;
      mediaController.displayImage.value = null;
      return;
    }

    // Continue normal logic
    customerController.selectedCustomer.value = customerController.allCustomers
        .firstWhere((user) => user.fullName == val);

    await addressController.fetchEntityAddresses(
        customerController.selectedCustomer.value.customerId!,
        EntityType.customer);

    entityId.value = customerController.selectedCustomer.value.customerId!;

    customerPhoneNoController.value.text =
        customerController.selectedCustomer.value.phoneNumber;

    customerCNICController.value.text =
        customerController.selectedCustomer.value.cnic;

    // Populate the address field with the first address of the selected customer
    if (addressController.allCustomerAddressesLocation.isNotEmpty) {
      final firstAddress = addressController.allCustomerAddressesLocation.first;

      customerAddressController.value.text = firstAddress;

      // Select the first address in the address controller
      addressController.selectedCustomerAddress.value = addressController
          .allCustomerAddresses
          .firstWhere((address) => address.location == firstAddress);
      selectedAddressId =
          addressController.selectedCustomerAddress.value.addressId;
    }
  }

  // Add method to handle salesman selection changes
  void handleSalesmanSelection(int salesmanId) {
    try {
      selectedSalesmanId = salesmanId;

      // Recalculate net total with new salesman commission
      calculateNetTotal();
      calculateOriginalNetTotal();
    } catch (e) {
      if (kDebugMode) {
        print('Error handling salesman selection: $e');
      }
    }
  }

  // Calculate net total from sub total plus fees
  void calculateNetTotal() {
    try {
      double shippingFee =
          shopController.selectedShop?.value.shippingPrice ?? 0.0;
      double tax = shopController.selectedShop?.value.taxrate ?? 0.0;
      double salesmanCommission = 0.0;

      // Get salesman commission if a salesman is selected
      if (selectedSalesmanId > 0) {
        try {
          final selectedSalesman = salesmanController.allSalesman.firstWhere(
            (salesman) => salesman.salesmanId == selectedSalesmanId,
            orElse: () => SalesmanModel.empty(),
          );
          double commissionPercent =
              selectedSalesman.comission?.toDouble() ?? 0.0;
          // Convert percentage to amount: (commission% * subTotal) / 100
          salesmanCommission = (commissionPercent * subTotal.value) / 100;
        } catch (e) {
          salesmanCommission = 0.0;
        }
      }

      // Calculate net total
      netTotal.value = subTotal.value + shippingFee + tax + salesmanCommission;

      // Update remaining amount based on net total
      updateRemainingAmount();
    } catch (e) {
      if (kDebugMode) {
        print('Error calculating net total: $e');
      }
    }
  }

  // Calculate original net total from original sub total plus fees
  void calculateOriginalNetTotal() {
    try {
      double shippingFee =
          shopController.selectedShop?.value.shippingPrice ?? 0.0;
      double tax = shopController.selectedShop?.value.taxrate ?? 0.0;
      double salesmanCommission = 0.0;

      // Get salesman commission if a salesman is selected
      if (selectedSalesmanId > 0) {
        try {
          final selectedSalesman = salesmanController.allSalesman.firstWhere(
            (salesman) => salesman.salesmanId == selectedSalesmanId,
            orElse: () => SalesmanModel.empty(),
          );
          double commissionPercent =
              selectedSalesman.comission?.toDouble() ?? 0.0;
          // Convert percentage to amount: (commission% * originalSubTotal) / 100
          salesmanCommission =
              (commissionPercent * originalSubTotal.value) / 100;
        } catch (e) {
          salesmanCommission = 0.0;
        }
      }

      // Calculate original net total
      originalNetTotal.value =
          originalSubTotal.value + shippingFee + tax + salesmanCommission;
    } catch (e) {
      if (kDebugMode) {
        print('Error calculating original net total: $e');
      }
    }
  }

  // Update remaining amount based on net total and paid amount
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

class SoftwareCompanyInfo extends StatelessWidget {
  const SoftwareCompanyInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final ShopController shopController = Get.find<ShopController>();
    final companyName = shopController.selectedShop?.value.softwareCompanyName;
    final websiteLink = shopController.selectedShop?.value.softwareWebsiteLink;
    final contactNo = shopController.selectedShop?.value.softwareContactNo;

    // If no company info exists, don't show anything
    if (companyName == null && websiteLink == null && contactNo == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: 180,
      padding: const EdgeInsets.all(TSizes.sm),
      decoration: BoxDecoration(
        color: TColors.lightContainer,
        borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
        border: Border.all(color: TColors.grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Company Name
          if (companyName != null && companyName.isNotEmpty)
            Text(
              companyName,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),

          // Contact Number
          if (contactNo != null && contactNo.isNotEmpty) ...[
            const SizedBox(height: TSizes.xs),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Iconsax.call, size: 12),
                const SizedBox(width: 4),
                Text(
                  contactNo,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ],

          // QR Code for website
          if (websiteLink != null && websiteLink.isNotEmpty) ...[
            const SizedBox(height: TSizes.sm),
            GestureDetector(
              onTap: () async {
                final Uri url = Uri.parse(websiteLink);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
              child: Column(
                children: [
                  QrImageView(
                    data: websiteLink,
                    version: QrVersions.auto,
                    size: 80.0,
                    backgroundColor: Colors.white,
                    errorStateBuilder: (context, error) => const Center(
                      child: Text('Error generating QR'),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Scan to visit',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
