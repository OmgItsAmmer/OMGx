import 'package:ecommerce_dashboard/Models/products/product_variant_model.dart';
import 'package:ecommerce_dashboard/Models/products/varaint_batches_model.dart';
import 'package:ecommerce_dashboard/Models/purchase/purchase_model.dart';
import 'package:ecommerce_dashboard/common/widgets/loaders/tloaders.dart';
import 'package:ecommerce_dashboard/controllers/dashboard/dashboard_controoler.dart';
import 'package:ecommerce_dashboard/controllers/product/product_controller.dart';
import 'package:ecommerce_dashboard/repositories/purchase/purchase_repository.dart';
import 'package:ecommerce_dashboard/repositories/products/variant_batches_repository.dart';
import 'package:ecommerce_dashboard/utils/constants/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../Models/products/product_model.dart';
import '../../routes/routes.dart';
import '../address/address_controller.dart';
import '../vendor/vendor_controller.dart';

class PurchaseController extends GetxController {
  static PurchaseController get instance => Get.find();
  final PurchaseRepository purchaseRepository = Get.put(PurchaseRepository());
  final VariantBatchesRepository variantBatchesRepository =
      Get.put(VariantBatchesRepository());

  RxList<PurchaseModel> allPurchases = <PurchaseModel>[].obs;

  Rx<PurchaseStatus> selectedStatus = PurchaseStatus.pending.obs;

  RxList<PurchaseItemModel> purchaseItems = <PurchaseItemModel>[].obs;

  final isStatusLoading = false.obs;
  final isPurchaseLoading = false.obs;
  final isPurchasesFetching = false.obs;

  //Vendor Purchase Detail
  RxList<PurchaseModel> currentPurchases = <PurchaseModel>[].obs;
  String recentPurchaseDay = '';
  String averageTotalAmount = '';

  TextEditingController newPaidAmount = TextEditingController();
  RxDouble remainingAmount = (0.0).obs;

  RxList<ProductVariantModel> availableVariants = <ProductVariantModel>[].obs;
  Rx<TextEditingController> unitPrice = TextEditingController().obs;
  Rx<TextEditingController> quantity = TextEditingController().obs;
  Rx<TextEditingController> totalPrice = TextEditingController().obs;
  Rx<bool> isLoadingVariants = false.obs;
  Rx<int> selectedVariantId = (-1).obs;

  @override
  void onInit() {
    fetchPurchases();
    super.onInit();
  }

  Future<void> fetchPurchases() async {
    try {
      isPurchasesFetching.value = true;
      final purchases = await purchaseRepository.fetchPurchases();

      // Assign the fetched purchases directly
      allPurchases.assignAll(purchases);
      currentPurchases.assignAll(purchases);

      // Dashboard will auto-update through reactive listeners
    } catch (e) {
      if (kDebugMode) {
        TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
        print(e);
      }
    } finally {
      isPurchasesFetching.value = false;
    }
  }

  void setRemainingAmount(PurchaseModel purchase) {
    // Calculate the total amount including subtotal, shipping fee, and tax
    double totalAmount =
        purchase.subTotal + purchase.shippingFee + purchase.tax;

    // Calculate the remaining amount
    remainingAmount.value = totalAmount - (purchase.paidAmount ?? 0.0);
  }

  // Function to set the most recent purchase day with purchaseId
  void setRecentPurchaseDay() {
    if (currentPurchases.isEmpty) {
      recentPurchaseDay = "No purchases available";
      recentPurchaseDay = "0"; // Reset difference if no purchases
      return;
    }

    // Find the most recent purchase
    PurchaseModel recentPurchase = currentPurchases.reduce((curr, next) =>
        DateTime.parse(curr.purchaseDate)
                .isAfter(DateTime.parse(next.purchaseDate))
            ? curr
            : next);

    // Calculate the difference in days between the current day and the purchaseDate
    DateTime currentDate = DateTime.now(); // Get the current date
    DateTime purchaseDate =
        DateTime.parse(recentPurchase.purchaseDate); // Parse the purchaseDate

    // Calculate the difference in days
    recentPurchaseDay =
        '${currentDate.difference(purchaseDate).inDays} Days Ago (#${recentPurchase.purchaseId})';
  }

  // Function to set the average of totalPrice
  void setAverageTotalAmount() {
    if (currentPurchases.isEmpty) {
      averageTotalAmount = "0.0"; // Set to 0 if there are no purchases
      return;
    }

    // Calculate the sum of all total prices
    double totalSum =
        currentPurchases.fold(0.0, (sum, purchase) => sum + purchase.subTotal);

    // Calculate the average and set the class variable
    double average = totalSum / currentPurchases.length;
    averageTotalAmount =
        average.toStringAsFixed(2); // Format to 2 decimal places
  }

  void resetVendorPurchases() {
    try {
      currentPurchases.assignAll(allPurchases);
    } catch (e) {
      TLoaders.errorSnackBar(title: e.toString());
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> setUpPurchaseDetails(PurchaseModel purchase) async {
    try {
      // Convert the orderStatus based on the purchase values
      PurchaseStatus? purchaseStatus = PurchaseStatus.values.firstWhere(
        (e) => e.name == purchase.status,
        orElse: () => PurchaseStatus.pending,
      );

      // Fetch controllers
      final PurchaseController purchaseController =
          Get.find<PurchaseController>();
      final AddressController addressController = Get.find<AddressController>();
      final VendorController vendorController = Get.find<VendorController>();

      // Fetch purchase items for the given purchase
      purchase.purchaseItems =
          await purchaseController.fetchPurchaseItems(purchase.purchaseId);

      // Set the selected purchase status
      purchaseController.selectedStatus.value = purchaseStatus;

      // Fetch vendor info based on the purchase's vendor ID
      vendorController.fetchVendorInfo(purchase.vendorId ?? -1);

      // Fetch vendor addresses
      addressController.fetchEntityAddresses(
          purchase.vendorId ?? -1, EntityType.vendor);

      // Set remaining amount for the purchase
      purchaseController.setRemainingAmount(purchase);

      // Navigate to the purchase details page
      Get.toNamed(TRoutes.purchaseDetails, arguments: purchase);
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'An error occurred while processing the purchase: $e',
      );
    }
  }

  Future<void> fetchEntityPurchases(int entityId, EntityType entityType) async {
    try {
      if (kDebugMode) {
        print("Fetching purchases for ${entityType.name} ID: $entityId");
      }

      isPurchaseLoading.value = true;

      // Clear the previous data
      currentPurchases.clear();

      switch (entityType) {
        case EntityType.user:
          // Fetch and filter purchases for User
          final userPurchases = allPurchases
              .where((purchase) => purchase.userId == entityId)
              .toList();
          currentPurchases.assignAll(userPurchases);
          break;
        default:
          throw Exception('Invalid entity type: ${entityType.name}');
      }

      if (kDebugMode) {
        print(
            "Filtered purchases count for ${entityType.name}: ${currentPurchases.length}");
      }
    } catch (e) {
      TLoaders.errorSnackBar(
          title: "Error: ${e.toString()}"); // Handle errors properly
      if (kDebugMode) {
        print("Error fetching ${entityType.name} purchases: $e");
      }
    } finally {
      isPurchaseLoading.value = false;
    }
  }

  Future<String> updateStatus(int purchaseId, String status) async {
    try {
      isStatusLoading.value = true;

      // Validate purchase exists before updating
      int index = allPurchases
          .indexWhere((purchase) => purchase.purchaseId == purchaseId);
      if (index == -1) {
        throw Exception('Purchase not found with ID: $purchaseId');
      }

      // Get the original status for comparison
      final originalStatus = allPurchases[index].status;

      // CRITICAL: Handle stock changes based on status transition
      if (originalStatus == 'cancelled' && status == 'received') {
        // Moving from cancelled to received - add stock back
        if (allPurchases[index].purchaseItems != null &&
            allPurchases[index].purchaseItems!.isNotEmpty) {
          await addStockQuantity(allPurchases[index].purchaseItems);
        }
      } else if (originalStatus == 'received' && status == 'cancelled') {
        // Moving from received to cancelled - need to check if we can subtract stock
        if (allPurchases[index].purchaseItems != null &&
            allPurchases[index].purchaseItems!.isNotEmpty) {
          bool canSubtract =
              await purchaseRepository.checkStockAvailabilityForCancellation(
                  allPurchases[index].purchaseItems!);

          if (!canSubtract) {
            TLoaders.errorSnackBar(
                title: 'Insufficient Stock',
                message:
                    'Cannot cancel received purchase. Some products do not have enough stock to subtract.');
            return originalStatus; // Return original status if cancellation fails
          }
          await subtractStockQuantity(allPurchases[index].purchaseItems);
        }
      } else if (status == 'received' && originalStatus != 'received') {
        // Moving to received status - add stock
        if (allPurchases[index].purchaseItems != null &&
            allPurchases[index].purchaseItems!.isNotEmpty) {
          await addStockQuantity(allPurchases[index].purchaseItems);
        }
      }

      // Update status in database
      await purchaseRepository.updateStatus(purchaseId, status);

      // Update the status in allPurchases list
      allPurchases[index] = allPurchases[index].copyWith(status: status);
      allPurchases.refresh(); // Notify UI about the update

      return status;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating purchase status: $e');
      }
      TLoaders.errorSnackBar(
          title: 'Status Update Error', message: e.toString());
      return '';
    } finally {
      isStatusLoading.value = false;
    }
  }

  PurchaseStatus? stringToPurchaseStatus(String status) {
    try {
      return PurchaseStatus.values.firstWhere((e) => e.toString() == status);
    } catch (e) {
      return null; // Return null if the status string doesn't match any enum value
    }
  }

  Future<List<PurchaseItemModel>> fetchPurchaseItems(int purchaseId) async {
    try {
      final purchaseItems =
          await purchaseRepository.fetchPurchaseItems(purchaseId);
      return purchaseItems;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  Future<List<int>> getPurchaseIdsByProductIdService(int variantId) async {
    try {
      final purchaseIds =
          await purchaseRepository.getPurchaseIdsByVariantId(variantId);
      return purchaseIds;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      print(e);
      return [];
    }
  }

  Future<void> addStockQuantity(List<PurchaseItemModel>? purchaseItems) async {
    try {
      if (purchaseItems == null || purchaseItems.isEmpty) {
        TLoaders.errorSnackBar(
            title: 'Oh Snap!', message: 'No purchase items to process');
        return;
      }

      for (var item in purchaseItems) {
        // Skip null items
        try {
          // Get product information to determine if it has variants
          final productController = Get.find<ProductController>();
          final product = productController.allProducts.firstWhere(
            (p) => p.productId == item.productId,
            orElse: () => ProductModel.empty(),
          );

          if (product.productId != null && product.productId! > 0) {
            // Check if product has variants
            final variants = await productController.productVariantsRepository
                .fetchProductVariants(product.productId!);

            if (variants.isNotEmpty) {
              // Product has variants - create variant batches
              await _createVariantBatchesForPurchase(item, variants);
            } else {
              // Product has no variants - use traditional stock management
              await purchaseRepository.addStockQuantity(item);
            }
          } else {
            // Fallback to traditional stock management
            await purchaseRepository.addStockQuantity(item);
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error adding stock quantity for item: $e');
          }
          // Continue with other items even if one fails
        }
      }

      // Refresh product list to ensure consistent data
      try {
        final productController = Get.find<ProductController>();
        await productController.refreshProducts();
      } catch (e) {
        if (kDebugMode) {
          print('Error refreshing products: $e');
        }
      }

      TLoaders.successSnackBar(
          title: 'Stock Added!',
          message: 'Product quantities have been added to stock successfully.');
    } catch (e) {
      if (kDebugMode) {
        print('Error in addStockQuantity: $e');
      }
      TLoaders.errorSnackBar(
          title: 'Add Stock Error',
          message: 'Failed to add product quantities to stock');
    }
  }

  // Create variant batches for purchased items with variants
  Future<void> _createVariantBatchesForPurchase(
      PurchaseItemModel item, List<ProductVariantModel> variants) async {
    try {
      // For products with variants, we need to distribute the purchased quantity
      // across the variants or create a default variant batch

      // For now, we'll create a batch for the first variant or a default one
      // TODO: In a real implementation, you might want to specify which variant
      // this purchase is for during the purchase process

      final variantId = variants.isNotEmpty ? variants.first.variantId : null;

      if (variantId != null) {
        // Generate a unique batch ID (you can customize this logic)
        final batchId =
            'BATCH_${DateTime.now().millisecondsSinceEpoch}_${item.productId}';

        final variantBatch = VariantBatchesModel(
          variantId: variantId,
          quantity: item.quantity,
          availableQuantity: item.quantity,
          buyPrice: item.price,
          sellPrice:
              item.price * 1.2, // Example markup - you can customize this
          vendor: 'Purchase Vendor', // You can get this from the purchase
          purchaseDate: DateTime.now(),
          batchId: batchId,
        );

        await variantBatchesRepository.insertVariantBatch(variantBatch);

        // Update product stock quantity from batches
        await variantBatchesRepository
            .updateProductStockFromBatches(item.productId);

        debugPrint(
            'Created variant batch for product ${item.productId}, variant $variantId');
      }
    } catch (e) {
      debugPrint('Error creating variant batches: $e');
      rethrow;
    }
  }

  Future<void> subtractStockQuantity(
      List<PurchaseItemModel>? purchaseItems) async {
    try {
      if (purchaseItems == null || purchaseItems.isEmpty) {
        TLoaders.errorSnackBar(
            title: 'Oh Snap!', message: 'No purchase items to process');
        return;
      }

      for (var item in purchaseItems) {
        // Skip null items
        try {
          await purchaseRepository.subtractStockQuantity(item);
        } catch (e) {
          if (kDebugMode) {
            print('Error subtracting stock quantity for item: $e');
          }
          // Continue with other items even if one fails
        }
      }

      // Refresh product list to ensure consistent data
      try {
        final productController = Get.find<ProductController>();
        await productController.refreshProducts();
      } catch (e) {
        if (kDebugMode) {
          print('Error refreshing products: $e');
        }
      }

      TLoaders.successSnackBar(
          title: 'Stock Updated!',
          message: 'Product quantities have been subtracted from stock.');
    } catch (e) {
      if (kDebugMode) {
        print('Error in subtractStockQuantity: $e');
      }
      TLoaders.errorSnackBar(
          title: 'Subtract Stock Error',
          message: 'Failed to subtract product quantities from stock');
    }
  }

  Future<void> updatePurchasePaidAmount(
      int purchaseId, double newAmount) async {
    try {
      bool success =
          await purchaseRepository.updatePaidAmount(purchaseId, newAmount);

      if (success) {
        // Update remaining amount in UI
        remainingAmount.value -= newAmount;

        // Update the purchase in allPurchases list
        final allPurchasesIndex = allPurchases
            .indexWhere((purchase) => purchase.purchaseId == purchaseId);
        if (allPurchasesIndex != -1) {
          final updatedPurchase = allPurchases[allPurchasesIndex].copyWith(
            paidAmount:
                (allPurchases[allPurchasesIndex].paidAmount ?? 0.0) + newAmount,
          );
          allPurchases[allPurchasesIndex] = updatedPurchase;
          allPurchases.refresh(); // Notify UI about the update
        }

        // Update the purchase in currentPurchases list
        final currentPurchasesIndex = currentPurchases
            .indexWhere((purchase) => purchase.purchaseId == purchaseId);
        if (currentPurchasesIndex != -1) {
          final updatedPurchase =
              currentPurchases[currentPurchasesIndex].copyWith(
            paidAmount:
                (currentPurchases[currentPurchasesIndex].paidAmount ?? 0.0) +
                    newAmount,
          );
          currentPurchases[currentPurchasesIndex] = updatedPurchase;
          currentPurchases.refresh(); // Notify UI about the update
        }

        TLoaders.successSnackBar(
          title: 'Success!',
          message: 'Paid amount updated.',
        );
      } else {
        TLoaders.errorSnackBar(
          title: 'Oh Snap!',
          message: 'Update failed!',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Controller Error: $e');
      }
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

     // if (!product.hasSerialNumbers) return;

      final variants =
          await productController.getAvailableVariantBatches(productId);
      // Note: availableVariants now contains VariantBatchesModel instead of ProductVariantModel
      // TODO: Update availableVariants type or convert the data structure

      if (variants.isNotEmpty) {
        unitPrice.value.text = "";
        quantity.value.text = "1";
        totalPrice.value.text = "";
      }
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Error', message: 'Failed to load variants: $e');
    } finally {
      isLoadingVariants.value = false;
    }
  }

  void calculateTotalPrice() {
    try {
      double unitPriceValue = double.tryParse(unitPrice.value.text) ?? 0.0;
      double quantityValue = double.tryParse(quantity.value.text) ?? 0.0;
      double totalPriceValue = unitPriceValue * quantityValue;
      totalPrice.value.text = totalPriceValue.toStringAsFixed(2);
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Error', message: 'Failed to calculate total price: $e');
    }
  }

  Future<void> fetchVendorPurchases(int vendorId) async {
    try {
      isPurchaseLoading.value = true;
      currentPurchases.clear();
      final vendorPurchases =
          await purchaseRepository.fetchVendorPurchases(vendorId);
      currentPurchases.assignAll(vendorPurchases);
      //currentPurchases.refresh();
    } catch (e) {
      TLoaders.errorSnackBar(title: "Error: ${e.toString()}");
      if (kDebugMode) {
        print("Error fetching vendor purchases: $e");
      }
    } finally {
      isPurchaseLoading.value = false;
    }
  }
}
