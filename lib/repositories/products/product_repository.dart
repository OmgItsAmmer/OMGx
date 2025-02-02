import 'package:admin_dashboard_v3/Models/products/product_model.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../main.dart';

class ProductRepository {


  Future<List<ProductModel>> fetchProducts() async
  {

    try{
      final data =  await supabase.from('products').select();
      //print(data);

      final productList = data.map((item) {
        return ProductModel.fromJson(item);
      }).toList();
      if (kDebugMode) {
        print(productList[1].name);
      }
      return productList;

    }
    catch(e)
    {
      TLoader.errorSnackBar(title: 'Product Repo',message: e.toString());
      return [];
    }

  }



  Future<void> saveOrUpdateProductRepo(Map<String, dynamic> json) async {
    try {

      if (json['product_id'] != null) {
        // Fetch the product with the given product_id
        final response = await supabase
            .from('products')
            .select()
            .eq('product_id', json['product_id'])
            .maybeSingle(); // Avoids exception if no product is found

        if (response != null) {
          // If the product exists, update it
          await supabase
              .from('products')
              .update(json)
              .eq('product_id', json['product_id']);
        } else {
          // If no existing product is found, insert a new one
          // Remove the product_id to let the database auto-generate it
          json.remove('product_id');
          await supabase.from('products').insert(json);
        }
      } else {
        // If product_id is not provided, insert a new product
        // Ensure product_id is not present in the json
        json.remove('product_id');
        await supabase.from('products').insert(json);
      }
    } on PostgrestException catch (e) {
      // Handle Supabase-specific errors
      TLoader.errorSnackBar(title: 'Product Repo', message: e.message);
      rethrow;
    } catch (e) {
      // Handle other errors
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
      TLoader.errorSnackBar(title: 'Can\'t get Product Id!', message: e.message);
      return -1; // Return -1 on error
    } catch (e) {
      // Handle other errors
      TLoader.errorSnackBar(title: 'Can\'t get Product Id!', message: e.toString());
      return -1; // Return -1 on error
    }
  }




}