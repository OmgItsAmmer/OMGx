import 'package:admin_dashboard_v3/Models/products/product_model.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../main.dart';

class ProductRepository {
  Future<List<ProductModel>> fetchProducts() async {
    try {
      final data = await supabase.from('products').select();
      //print(data);

      final productList = data.map((item) {
        return ProductModel.fromJson(item);
      }).toList();

      return productList;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Product Repo', message: e.toString());
      return [];
    }
  }

  Future<int> insertProductInTable(Map<String, dynamic> json) async {
    try {
      final response = await supabase
          .from('products')
          .insert(json)
          .select('product_id')
          .single();

      final productId = response['product_id'] as int;
      return productId;
    } on PostgrestException catch (e) {
      TLoaders.errorSnackBar(title: 'Product Repo', message: e.message);
      rethrow;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Product Repo', message: e.toString());
      rethrow;
    }
  }

  Future<void> updateProduct(Map<String, dynamic> json) async {
    try {
      int? productId = json['product_id'];
      if (productId == null) {
        throw Exception('Product ID is required for update.');
      }

      // Remove product_id from the update payload to avoid trying to update the primary key
      final updateData = Map<String, dynamic>.from(json)..remove('product_id');

      await supabase
          .from('products')
          .update(updateData)
          .eq('product_id', productId);
    } on PostgrestException catch (e) {
      TLoaders.errorSnackBar(title: 'Product Repo', message: e.message);
      rethrow;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Product Repo', message: e.toString());
      rethrow;
    }
  }

  Future<int> getProductId(String productName) async {
    try {
      // Query the Supabase database to find the product by name
      final response = await Supabase.instance.client
          .from('products')
          .select('product_id')
          .eq('name', productName)
          .maybeSingle();

      // If the response is null, return -1 (product not found)
      if (response == null || response['product_id'] == null) {
        return -1;
      }

      return response['product_id'] as int;
    } on PostgrestException catch (e) {
      // Handle Supabase-specific errors
      TLoaders.errorSnackBar(
          title: 'Can\'t get Product Id!', message: e.message);
      return -1; // Return -1 on error
    } catch (e) {
      // Handle other errors
      TLoaders.errorSnackBar(
          title: 'Can\'t get Product Id!', message: e.toString());
      return -1; // Return -1 on error
    }
  }

  Future<void> updateStockQuantity(
      {required int productId, required int quantitySold}) async {
    try {
      // First get the current stock quantity
      final response = await supabase
          .from('products')
          .select('stock_quantity')
          .eq('product_id', productId)
          .single();

      final int currentStock = response['stock_quantity'] as int;
      final int newStock = currentStock - quantitySold;

      if (newStock < 0) {
        throw Exception('Insufficient stock. Cannot have negative inventory.');
      }

      // Update the stock quantity
      await supabase
          .from('products')
          .update({'stock_quantity': newStock}).eq('product_id', productId);
    } catch (e) {
      if (kDebugMode) {
        print('Stock Update Exception: $e');
      }
      TLoaders.errorSnackBar(
          title: 'Stock Update Error',
          message: 'Failed to update stock: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> checkLowStock(List<int> productIds) async {
    try {
      // First check if products are below alert stock
      final response = await supabase
          .from('products')
          .select('product_id, name, stock_quantity, alert_stock')
          .inFilter('product_id', productIds);

      for (var product in response) {
        final int stockQuantity = product['stock_quantity'] as int;
        final int alertStock = product['alert_stock'] as int? ?? 0;
        final String productName = product['name'] as String;

        if (stockQuantity <= alertStock) {
          if (kDebugMode) {
            print('Low stock alert for product: $productName');
            print(
                'Current stock: $stockQuantity, Alert threshold: $alertStock');
          }

          // Trigger the notify_low_stock function
          try {
            await supabase.rpc('notify_low_stock', params: {
              'product_id': product['product_id'],
              'current_stock': stockQuantity,
              'alert_threshold': alertStock,
              'product_name': productName
            });
          } catch (e) {
            if (kDebugMode) {
              print('Error triggering low stock notification: $e');
            }
          }
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error checking low stock: $error');
      }
      rethrow;
    }
  }
}
