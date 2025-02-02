import 'package:admin_dashboard_v3/Models/category/category_model.dart';
import 'package:admin_dashboard_v3/Models/products/product_model.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../Models/brand/brand_model.dart';
import '../../main.dart';

class CategoryRepository {



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
