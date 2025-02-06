import 'package:admin_dashboard_v3/Models/category/category_model.dart';
import 'package:admin_dashboard_v3/Models/products/product_model.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../Models/brand/brand_model.dart';
import '../../main.dart';

class CategoryRepository {

  Future<void> saveOrUpdateCategoryRepo(Map<String, dynamic> json) async {
    try {


      if (json['category_id'] != null) {
        // Fetch the brand with the given brandID
        final response = await supabase
            .from('categories')
            .select()
            .eq('category_id', json['category_id'])
            .maybeSingle(); // Avoids exception if no brand is found

        if (response != null) {
          // If the brand exists, update it
          await supabase
              .from('categories')
              .update(json)
              .eq('category_id', json['category_id']);
        } else {
          // If no existing brand is found, insert a new one
          // Remove the brandID to let the database auto-generate it
          json.remove('category_id');
          await supabase.from('categories').insert(json);
        }
      } else {
        // If brandID is not provided, insert a new brand
        // Ensure brandID is not present in the json
        json.remove('category_id');
        await supabase.from('categories').insert(json);
      }
    } on PostgrestException catch (e) {
      // Handle Supabase-specific errors
      TLoader.errorSnackBar(title: 'categories Repo', message: e.message);
      rethrow;
    } catch (e) {
      // Handle other errors
      TLoader.errorSnackBar(title: 'categories Repo', message: e.toString());
      rethrow;
    }
  }

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final data = await supabase.from('categories').select();
      print(data);

      final categoryList = data.map((item) {
        return CategoryModel.fromJson(item);
      }).toList();
      if (kDebugMode) {
        print(categoryList[1].categoryName);
      }
      return categoryList;
    } catch (e) {
      TLoader.errorSnackBar(title: 'Brand Repo', message: e.toString());
      return [];
    }
  }



  Future<int> getCategoryId(String categoryName) async {
    try {
      // Query the Supabase database to find the brand by name
      final response = await Supabase.instance.client
          .from('categories')
          .select('category_id')
          .eq('category_name', categoryName)
          .single();

      // Check if the response contains the brandID
      if (response['category_id'] != null) {
        return response['category_id'] as int;
      } else {
        throw Exception('Category not found');
      }
    } on PostgrestException catch (e) {
      // Handle Supabase-specific errors
      TLoader.errorSnackBar(title: 'Can\'t get Category Id!', message: e.message);
      rethrow;
    } catch (e) {
      // Handle other errors
      TLoader.errorSnackBar(title: 'Can\'t get Category Id!', message: e.toString());
      rethrow;
    }
  }
}
