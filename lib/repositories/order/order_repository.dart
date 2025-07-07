import 'package:ecommerce_dashboard/common/widgets/loaders/tloaders.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../main.dart';

import '../../Models/orders/order_item_model.dart';
import '../../Models/products/product_model.dart';
import '../../controllers/product/product_controller.dart';
import '../../repositories/products/product_variants_repository.dart';

class OrderRepository {
  //fetch
  Future<List<OrderModel>> fetchCustomerOrders(int customerId) async {
    try {
      final data =
          await supabase.from('orders').select().eq('customer_id', customerId);
      // print(data.length);

      final addressList = data.map((item) {
        return OrderModel.fromJson(item);
      }).toList();

      return addressList;
    } catch (e) {
      TLoaders.warningSnackBar(
          title: "Fetch Customer Orders", message: e.toString());
      return [];
    }
  }

  Future<void> updateStatus(int orderId, String newStatus) async {
    try {
      await supabase
          .from('orders')
          .update({'status': newStatus}).eq('order_id', orderId);

      TLoaders.successSnackBar(
          title: 'Status Updated', message: 'Status is Updated to $newStatus');
    } catch (e) {
      // Show error if anyJ
      TLoaders.errorSnackBar(
          title: 'Update Order Error', message: e.toString());
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<int> uploadOrder(
      Map<String, dynamic> json, List<OrderItemModel> orderItems) async {
    try {
      // ✅ Insert the order into the 'orders' table
      final response =
          await Supabase.instance.client.from('orders').insert(json).select();

      final orderId = response[0]['order_id'];

      // ✅ Insert the order items using `toJson()`
      if (orderItems.isNotEmpty) {
        // Make sure to add the order_id to each item before inserting
        await Supabase.instance.client.from('order_items').insert(
              orderItems.map((item) {
                var itemJson = item.toJson();
                itemJson['order_id'] = orderId; // Assign the order_id here
                return itemJson;
              }).toList(),
            );
      }

      TLoaders.successSnackBar(
          title: 'Success', message: 'Order successfully checked out.');
      return orderId;
    } catch (e) {
      // ❌ Handle errors
      if (kDebugMode) {
        TLoaders.errorSnackBar(
            title: 'Update Order Error', message: e.toString());
        print(e);
      }
      return -1;
    }
  }

  Future<List<OrderModel>> fetchOrders() async {
    try {
      final data = await supabase.from('orders').select();
      //print(data);

      final orderList = data.map((item) {
        return OrderModel.fromJson(item);
      }).toList();

      return orderList;
    } catch (e) {
      if (kDebugMode) {
        TLoaders.errorSnackBar(title: 'Order Fetch', message: e.toString());
        print(e.toString());
      }
      return [];
    }
  }

  Future<List<OrderItemModel>> fetchOrderItems(int orderId) async {
    try {
      final data = await supabase
          .from('order_items')
          .select(
              '*, products(product_id, name)') // Joining with product_variant
          .eq('order_id', orderId);

      if (kDebugMode) {
        print(data);
      }

      final orderItemList = data.map((item) {
        return OrderItemModel.fromJson(item);
      }).toList();

      return orderItemList;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Order Item Fetch', message: e.toString());
      if (kDebugMode) {
        print(e.toString());
      }
      return [];
    }
  }

  Future<List<int>> getOrderIdsByVariantId(int variantId) async {
    final response = await supabase
        .from('order_items')
        .select('order_id')
        .eq('variant_id', variantId);

    return response.map<int>((item) => item['order_id'] as int).toList();
  }

  Future<void> restoreQuantity(OrderItemModel item) async {
    try {
      // Check if this is a variant-based item (new system)
      if (item.variantId != null) {
        // For variant-based products, mark the variant as available
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

        // Fixed: Handle null response properly
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
          title: 'Restore Quantity Error', message: e.toString());
      rethrow;
    }
  }

  Future<void> subtractQuantity(OrderItemModel item) async {
    try {
      // Check if this is a variant-based item (new system)
      if (item.variantId != null) {
        // For variant-based products, update the variant's sold status
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
          //     title: 'Subtract Quantity Error',
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
          title: 'Subtract Quantity Error', message: e.toString());
    }
  }

  Future<bool> updatePaidAmount(int orderId, double newAmount) async {
    try {
      // Fetch existing paid amount
      final response = await supabase
          .from('orders')
          .select('paid_amount')
          .eq('order_id', orderId)
          .single();

      double existingAmount =
          (response['paid_amount'] as num?)?.toDouble() ?? 0.0;
      double updatedAmount = existingAmount + newAmount;

      // Update order with new paid amount
      await supabase.from('orders').update({
        'paid_amount': updatedAmount,
      }).eq('order_id', orderId);

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating paid amount: $e');
        TLoaders.errorSnackBar(title: 'Order Repo', message: e.toString());
      }
      return false;
    }
  }

  /// Check if there's enough stock available for the given order items
  Future<bool> checkStockAvailability(List<OrderItemModel> orderItems) async {
    try {
      final productController = Get.find<ProductController>();

      for (var item in orderItems) {
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
              print('Variant ${item.variantId} is already sold');
            }
            return false;
          }
        } else {
          // For regular products, check if there's enough quantity
          final response = await supabase
              .from('products')
              .select('stock_quantity')
              .eq('product_id', item.productId)
              .single();

          final int currentStock = response['stock_quantity'] as int;

          if (currentStock < item.quantity) {
            if (kDebugMode) {
              print(
                  'Not enough stock for product ${item.productId}. Required: ${item.quantity}, Available: $currentStock');
            }
            return false;
          }
        }
      }

      return true; // All items have sufficient stock
    } catch (e) {
      if (kDebugMode) {
        print('Error checking stock availability: $e');
      }
      TLoaders.errorSnackBar(title: 'Stock Check Error', message: e.toString());
      return false;
    }
  }
}
