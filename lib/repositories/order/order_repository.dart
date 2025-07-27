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

      print(orderList.length);

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
      print(e.toString());
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
      if (item.variantId != null) {
        // For orders with variants, restore the variant stock
        final variantsRepository = Get.find<ProductVariantsRepository>();

        // Get current variant stock and add the returned quantity
        final variants =
            await variantsRepository.fetchProductVariants(item.productId);
        final variant =
            variants.firstWhere((v) => v.variantId == item.variantId);
        final newStock = variant.stock + item.quantity;

        await variantsRepository.updateVariantStock(item.variantId!, newStock);

        // Update local product list with calculated total stock
        try {
          final productController = Get.find<ProductController>();
          final productIndex = productController.allProducts
              .indexWhere((p) => p.productId == item.productId);
          if (productIndex != -1) {
            final totalStock =
                await variantsRepository.calculateProductStock(item.productId);
            final updatedProduct =
                productController.allProducts[productIndex].copyWith(
              stockQuantity: totalStock,
            );
            productController.allProducts[productIndex] = updatedProduct;
            productController.update();
          }
        } catch (e) {
          if (kDebugMode) print('Local update error: $e');
        }
      } else {
        // For regular products without variants
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
      if (item.variantId != null) {
        // For orders with variants, subtract from variant stock
        final variantsRepository = Get.find<ProductVariantsRepository>();

        // Get current variant stock and subtract the sold quantity
        final variants =
            await variantsRepository.fetchProductVariants(item.productId);
        final variant =
            variants.firstWhere((v) => v.variantId == item.variantId);
        final newStock = variant.stock - item.quantity;

        await variantsRepository.updateVariantStock(item.variantId!, newStock);

        // Update local product list with calculated total stock
        try {
          final productController = Get.find<ProductController>();
          final productIndex = productController.allProducts
              .indexWhere((p) => p.productId == item.productId);
          if (productIndex != -1) {
            final totalStock =
                await variantsRepository.calculateProductStock(item.productId);
            final updatedProduct =
                productController.allProducts[productIndex].copyWith(
              stockQuantity: totalStock,
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
        // For regular products without variants, update the quantity in the database
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
      for (var item in orderItems) {
        // Skip null items
        //   if (item == null) continue;

        if (item.variantId != null) {
          // For items with variants, check variant stock
          final variantsRepository = Get.find<ProductVariantsRepository>();
          final variants =
              await variantsRepository.fetchProductVariants(item.productId);
          final variant = variants.firstWhere(
            (v) => v.variantId == item.variantId,
            orElse: () => throw Exception('Variant not found'),
          );

          if (variant.stock < item.quantity) {
            if (kDebugMode) {
              print(
                  'Not enough variant stock for variant ${item.variantId}. Required: ${item.quantity}, Available: ${variant.stock}');
            }
            return false;
          }
        } else {
          // For regular products without variants, check product stock
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

  /// Update an existing order with new data
  Future<bool> updateOrder(int orderId, Map<String, dynamic> orderData,
      List<OrderItemModel> newOrderItems) async {
    try {
      // Start a transaction-like approach

      // Step 1: Update the main order record
      await supabase.from('orders').update(orderData).eq('order_id', orderId);

      // Step 2: Handle order items update
      if (newOrderItems.isNotEmpty) {
        // Delete existing order items
        await supabase.from('order_items').delete().eq('order_id', orderId);

        // Insert new order items
        final orderItemsJson = newOrderItems
            .map((item) => {
                  'order_id': orderId,
                  'product_id': item.productId,
                  'variant_id': item.variantId,
                  'quantity': item.quantity,
                  'price': item.price,
                  'unit': item.unit,
                  'total_buy_price': item.totalBuyPrice,
                })
            .toList();

        await supabase.from('order_items').insert(orderItemsJson);
      }

      TLoaders.successSnackBar(
          title: 'Order Updated',
          message: 'Order #$orderId has been updated successfully');

      return true;
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Update Order Error', message: e.toString());
      if (kDebugMode) {
        print('Error updating order: $e');
      }
      return false;
    }
  }

  /// Get the original order items before editing (for stock restoration)
  Future<List<OrderItemModel>> getOriginalOrderItems(int orderId) async {
    try {
      final response = await supabase
          .from('order_items')
          .select('*')
          .eq('order_id', orderId);

      return response
          .map<OrderItemModel>((item) => OrderItemModel(
                productId: item['product_id'],
                orderId: item['order_id'],
                quantity: item['quantity'],
                price: (item['price'] as num).toDouble(),
                unit: item['unit'],
                totalBuyPrice: (item['total_buy_price'] as num?)?.toDouble(),
                variantId: item['variant_id'],
              ))
          .toList();
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Fetch Order Items Error', message: e.toString());
      if (kDebugMode) {
        print('Error fetching original order items: $e');
      }
      return [];
    }
  }

  /// Calculate stock differences between original and new order items
  Future<Map<String, dynamic>> calculateStockDifferences(
      List<OrderItemModel> originalItems, List<OrderItemModel> newItems) async {
    try {
      Map<String, int> stockChanges = {};
      Map<String, int> variantStockChanges = {};

      // Create maps for easier lookup
      Map<int, int> originalProductQuantities = {};
      Map<int, int> originalVariantQuantities = {};

      for (var item in originalItems) {
        if (item.variantId != null) {
          originalVariantQuantities[item.variantId!] =
              (originalVariantQuantities[item.variantId!] ?? 0) + item.quantity;
        } else {
          originalProductQuantities[item.productId] =
              (originalProductQuantities[item.productId] ?? 0) + item.quantity;
        }
      }

      Map<int, int> newProductQuantities = {};
      Map<int, int> newVariantQuantities = {};

      for (var item in newItems) {
        if (item.variantId != null) {
          newVariantQuantities[item.variantId!] =
              (newVariantQuantities[item.variantId!] ?? 0) + item.quantity;
        } else {
          newProductQuantities[item.productId] =
              (newProductQuantities[item.productId] ?? 0) + item.quantity;
        }
      }

      // Calculate differences for products
      Set<int> allProductIds = {
        ...originalProductQuantities.keys,
        ...newProductQuantities.keys
      };
      for (int productId in allProductIds) {
        int originalQty = originalProductQuantities[productId] ?? 0;
        int newQty = newProductQuantities[productId] ?? 0;
        int difference = newQty -
            originalQty; // Positive means more items needed, negative means stock restored

        if (difference != 0) {
          stockChanges['product_$productId'] = difference;
        }
      }

      // Calculate differences for variants
      Set<int> allVariantIds = {
        ...originalVariantQuantities.keys,
        ...newVariantQuantities.keys
      };
      for (int variantId in allVariantIds) {
        int originalQty = originalVariantQuantities[variantId] ?? 0;
        int newQty = newVariantQuantities[variantId] ?? 0;
        int difference = newQty - originalQty;

        if (difference != 0) {
          variantStockChanges['variant_$variantId'] = difference;
        }
      }

      return {
        'productChanges': stockChanges,
        'variantChanges': variantStockChanges,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error calculating stock differences: $e');
      }
      return {
        'productChanges': <String, int>{},
        'variantChanges': <String, int>{}
      };
    }
  }

  /// Apply stock changes based on differences
  Future<bool> applyStockChanges(Map<String, dynamic> stockDifferences) async {
    try {
      final productChanges =
          stockDifferences['productChanges'] as Map<String, int>;
      final variantChanges =
          stockDifferences['variantChanges'] as Map<String, int>;

      // Apply product stock changes
      for (var entry in productChanges.entries) {
        String key = entry.key;
        int change = entry.value;
        int productId = int.parse(key.split('_')[1]);

        // Get current stock
        final response = await supabase
            .from('products')
            .select('stock_quantity')
            .eq('product_id', productId)
            .single();

        int currentStock = response['stock_quantity'] as int;
        int newStock =
            currentStock - change; // Subtract because we're updating stock

        if (newStock < 0) {
          TLoaders.errorSnackBar(
              title: 'Insufficient Stock',
              message: 'Not enough stock for product ID: $productId');
          return false;
        }

        await supabase
            .from('products')
            .update({'stock_quantity': newStock}).eq('product_id', productId);
      }

      // Apply variant stock changes
      final variantsRepository = Get.find<ProductVariantsRepository>();
      for (var entry in variantChanges.entries) {
        String key = entry.key;
        int change = entry.value;
        int variantId = int.parse(key.split('_')[1]);

        // Get current variant stock
        final variants = await variantsRepository
            .fetchProductVariants(0); // We'll filter by variantId
        final variant = variants.firstWhere((v) => v.variantId == variantId);

        int newStock =
            variant.stock - change; // Subtract because we're updating stock

        if (newStock < 0) {
          TLoaders.errorSnackBar(
              title: 'Insufficient Stock',
              message: 'Not enough stock for variant ID: $variantId');
          return false;
        }

        await variantsRepository.updateVariantStock(variantId, newStock);
      }

      return true;
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Stock Update Error', message: e.toString());
      if (kDebugMode) {
        print('Error applying stock changes: $e');
      }
      return false;
    }
  }
}
