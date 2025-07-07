import 'package:ecommerce_dashboard/common/widgets/loaders/tloaders.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../main.dart';
import '../../Models/purchase/purchase_model.dart';
import '../../Models/products/product_model.dart';
import '../../controllers/product/product_controller.dart';
import '../../repositories/products/product_variants_repository.dart';

class PurchaseRepository {
  //fetch vendor purchases
  Future<List<PurchaseModel>> fetchVendorPurchases(int vendorId) async {
    try {
      final data =
          await supabase.from('purchases').select().eq('vendor_id', vendorId);

      final purchaseList = data.map((item) {
        return PurchaseModel.fromJson(item);
      }).toList();

      return purchaseList;
    } catch (e) {
      TLoaders.warningSnackBar(
          title: "Fetch Vendor Purchases", message: e.toString());
      if (kDebugMode) {
        print('Error in fetchVendorPurchases: $e');
      }
      return [];
    }
  }

  Future<void> updateStatus(int purchaseId, String newStatus) async {
    try {
      await supabase
          .from('purchases')
          .update({'status': newStatus}).eq('purchase_id', purchaseId);

      TLoaders.successSnackBar(
          title: 'Status Updated', message: 'Status is Updated to $newStatus');
    } catch (e) {
      // Show error if any
      TLoaders.errorSnackBar(
          title: 'Update Purchase Error', message: e.toString());
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<int> uploadPurchase(
      Map<String, dynamic> json, List<PurchaseItemModel> purchaseItems) async {
    try {
      // ✅ Insert the purchase into the 'purchases' table
      final response = await Supabase.instance.client
          .from('purchases')
          .insert(json)
          .select();

      final purchaseId = response[0]['purchase_id'];

      // ✅ Insert the purchase items using `toJson()`
      if (purchaseItems.isNotEmpty) {
        // Make sure to add the purchase_id to each item before inserting
        await Supabase.instance.client.from('purchase_items').insert(
              purchaseItems.map((item) {
                var itemJson = item.toJson();
                itemJson['purchase_id'] =
                    purchaseId; // Assign the purchase_id here
                return itemJson;
              }).toList(),
            );
      }

      TLoaders.successSnackBar(
          title: 'Success', message: 'Purchase successfully recorded.');
      return purchaseId;
    } catch (e) {
      // ❌ Handle errors
      if (kDebugMode) {
        TLoaders.errorSnackBar(
            title: 'Create Purchase Error', message: e.toString());
        print(e);
      }
      return -1;
    }
  }

  Future<List<PurchaseModel>> fetchPurchases() async {
    try {
      final data = await supabase.from('purchases').select();

      final purchaseList = data.map((item) {
        return PurchaseModel.fromJson(item);
      }).toList();

      return purchaseList;
    } catch (e) {
      if (kDebugMode) {
        TLoaders.errorSnackBar(title: 'Purchase Fetch', message: e.toString());
        print(e.toString());
      }
      return [];
    }
  }

  Future<List<PurchaseItemModel>> fetchPurchaseItems(int purchaseId) async {
    try {
      final data = await supabase
          .from('purchase_items')
          .select('*, products(product_id, name)') // Joining with products
          .eq('purchase_id', purchaseId);

      if (kDebugMode) {
        print(data);
      }

      final purchaseItemList = data.map((item) {
        return PurchaseItemModel.fromJson(item);
      }).toList();

      return purchaseItemList;
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Purchase Item Fetch', message: e.toString());
      print(e.toString());
      return [];
    }
  }

  Future<List<int>> getPurchaseIdsByVariantId(int variantId) async {
    final response = await supabase
        .from('purchase_items')
        .select('purchase_id')
        .eq('variant_id', variantId);

    return response.map<int>((item) => item['purchase_id'] as int).toList();
  }

  Future<void> addStockQuantity(PurchaseItemModel item) async {
    try {
      // Check if this is a variant-based item (new system)
      if (item.variantId != null) {
        // For variant-based products, update the variant batch availability
        final variantsRepository = Get.find<ProductVariantsRepository>();
        await variantsRepository.markVariantAsAvailable(item.variantId!);

        // Update the product's overall stock quantity
        try {
          final productController = Get.find<ProductController>();
          final productIndex = productController.allProducts
              .indexWhere((p) => p.productId == item.productId);
          if (productIndex != -1) {
            final availableCount =
                await variantsRepository.countAvailableVariants(item.productId);
            final updatedProduct =
                productController.allProducts[productIndex].copyWith(
              stockQuantity: availableCount,
            );
            productController.allProducts[productIndex] = updatedProduct;
            productController.update();
          }
        } catch (e) {
          if (kDebugMode) print('Local update error: $e');
        }
      } else {
        // For regular products (non-variant)
        final response = await supabase
            .from('products')
            .select('stock_quantity')
            .eq('product_id', item.productId)
            .single();

        final int currentStock = response['stock_quantity'] as int;
        final int newStock = currentStock + item.quantity;

        // Update stock quantity in database
        final updateResponse = await supabase.from('products').update(
            {'stock_quantity': newStock}).eq('product_id', item.productId);

        if (updateResponse != null && updateResponse.error != null) {
          throw Exception(updateResponse.error!.message);
        }

        // Update local product list
        try {
          final productController = Get.find<ProductController>();
          final productIndex = productController.allProducts
              .indexWhere((p) => p.productId == item.productId);
          if (productIndex != -1) {
            final currentProduct = productController.allProducts[productIndex];
            final updatedProduct = currentProduct.copyWith(
              stockQuantity: currentProduct.stockQuantity! + item.quantity,
            );
            productController.allProducts[productIndex] = updatedProduct;
            productController.update();
          }
        } catch (e) {
          if (kDebugMode) print('Local update error: $e');
        }
      }
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Add Stock Quantity Error', message: e.toString());
      rethrow;
    }
  }

  Future<void> subtractStockQuantity(PurchaseItemModel item) async {
    try {
      // Check if this is a variant-based item (new system)
      if (item.variantId != null) {
        // For variant-based products, update the variant batch as sold
        final variantsRepository = Get.find<ProductVariantsRepository>();
        await variantsRepository.markVariantAsSold(item.variantId!);

        // Update local product list in ProductController
        try {
          final productController = Get.find<ProductController>();
          final productIndex = productController.allProducts
              .indexWhere((p) => p.productId == item.productId);
          if (productIndex != -1) {
            // Get updated count of available variants
            final availableCount =
                await variantsRepository.countAvailableVariants(item.productId);
            final updatedProduct =
                productController.allProducts[productIndex].copyWith(
              stockQuantity: availableCount,
            );
            productController.allProducts[productIndex] = updatedProduct;
            productController.update();
          }
        } catch (e) {
          if (kDebugMode) {
            print('Failed to update local product list: $e');
          }
        }
      } else {
        // For regular products (non-variant), update the quantity in the database
        // Step 1: Fetch the current stock quantity
        final response = await supabase
            .from('products')
            .select('stock_quantity')
            .eq('product_id', item.productId)
            .single(); // Ensures we get a single row

        // Directly access the stock quantity from the response
        final int currentStock = response['stock_quantity'] as int;
        final int newStock = currentStock - item.quantity; // Subtract quantity

        // Step 2: Update the stock quantity
        final updateResponse = await supabase.from('products').update(
            {'stock_quantity': newStock}).eq('product_id', item.productId);

        if (updateResponse != null && updateResponse.error != null) {
          // TLoaders.errorSnackBar(
          //     title: 'Subtract Stock Quantity Error',
          //     message: updateResponse.error!.message);
        } else {
          // Update local product list in ProductController
          try {
            final productController = Get.find<ProductController>();
            final productIndex = productController.allProducts
                .indexWhere((p) => p.productId == item.productId);
            if (productIndex != -1) {
              final currentProduct =
                  productController.allProducts[productIndex];
              final updatedProduct = currentProduct.copyWith(
                stockQuantity: currentProduct.stockQuantity! - item.quantity,
              );
              productController.allProducts[productIndex] = updatedProduct;
              productController.update();
            }
          } catch (e) {
            if (kDebugMode) {
              print('Failed to update local product list: $e');
            }
          }
        }
      }
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Subtract Stock Quantity Error', message: e.toString());
    }
  }

  Future<bool> updatePaidAmount(int purchaseId, double newAmount) async {
    try {
      // Fetch existing paid amount
      final response = await supabase
          .from('purchases')
          .select('paid_amount')
          .eq('purchase_id', purchaseId)
          .single();

      double existingAmount =
          (response['paid_amount'] as num?)?.toDouble() ?? 0.0;
      double updatedAmount = existingAmount + newAmount;

      // Update purchase with new paid amount
      await supabase.from('purchases').update({
        'paid_amount': updatedAmount,
      }).eq('purchase_id', purchaseId);

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating paid amount: $e');
        TLoaders.errorSnackBar(title: 'Purchase Repo', message: e.toString());
      }
      return false;
    }
  }

  /// Check if there's enough stock available for cancelling purchase
  Future<bool> checkStockAvailabilityForCancellation(
      List<PurchaseItemModel> purchaseItems) async {
    try {
      final productController = Get.find<ProductController>();

      for (var item in purchaseItems) {
        // Skip null items
        if (item == null) continue;

        // Find the product
        final product = productController.allProducts.firstWhere(
            (p) => p.productId == item.productId,
            orElse: () => ProductModel.empty());

        if (product.productId == -1) {
          if (kDebugMode) {
            print('Product not found with ID: ${item.productId}');
          }
          return false;
        }

        // Check if this is a variant-based item
        if (item.variantId != null) {
          // For variant-based products, check if the specific variant is available (not sold)
          final response = await supabase
              .from('product_variants')
              .select('is_sold')
              .eq('variant_id', item.variantId!)
              .maybeSingle();

          if (response == null) {
            if (kDebugMode) {
              print('Variant ${item.variantId} not found');
            }
            return false;
          }

          final bool isSold = response['is_sold'] as bool? ?? true;

          if (isSold) {
            if (kDebugMode) {
              print(
                  'Variant ${item.variantId} is already sold and cannot be cancelled');
            }
            return false;
          }
        } else {
          // For regular products, check if there's enough quantity to subtract
          final response = await supabase
              .from('products')
              .select('stock_quantity')
              .eq('product_id', item.productId)
              .single();

          final int currentStock = response['stock_quantity'] as int;

          if (currentStock < item.quantity) {
            if (kDebugMode) {
              print(
                  'Not enough stock to cancel purchase for product ${item.productId}. Required: ${item.quantity}, Available: $currentStock');
            }
            return false;
          }
        }
      }

      return true; // All items have sufficient stock for cancellation
    } catch (e) {
      if (kDebugMode) {
        print('Error checking stock availability for cancellation: $e');
      }
      TLoaders.errorSnackBar(title: 'Stock Check Error', message: e.toString());
      return false;
    }
  }
}
