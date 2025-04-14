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
      TLoader.errorSnackBar(title: 'Product Repo', message: e.toString());
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
      TLoader.errorSnackBar(title: 'Product Repo', message: e.message);
      rethrow;
    } catch (e) {
      TLoader.errorSnackBar(title: 'Product Repo', message: e.toString());
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
      TLoader.errorSnackBar(title: 'Product Repo', message: e.message);
      rethrow;
    } catch (e) {
      TLoader.errorSnackBar(title: 'Product Repo', message: e.toString());
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
      TLoader.errorSnackBar(
          title: 'Can\'t get Product Id!', message: e.message);
      return -1; // Return -1 on error
    } catch (e) {
      // Handle other errors
      TLoader.errorSnackBar(
          title: 'Can\'t get Product Id!', message: e.toString());
      return -1; // Return -1 on error
    }
  }

  Future<void> updateStockQuantity(
      {required int productId, required int quantitySold}) async {
    try {
      final response = await supabase.from('products').update({
        'stock_quantity': supabase.rpc('decrease_stock', params: {
          'p_id': productId,
          'qty_sold': quantitySold,
        })
      }).eq('product_id', productId);

      if (response.error != null) {
        if (kDebugMode) {
          print('Stock Update Error: ${response.error!.message}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Stock Update Exception: $e');
      }
    }
  }

  Future<void> checkLowStock(List<int> productIds) async {
    try {
      final response = await supabase.rpc('notify_low_stock', params: {
        'product_ids': productIds,
      });

      if (kDebugMode) {
        print("Low stock check response: $response");
      }
    } catch (error) {
      if (kDebugMode) {
        TLoader.errorSnackBar(
            title: 'Alert Stock Error', message: error.toString());
        print("Error checking low stock: $error");
      }
    }
  }
}
