import 'package:ecommerce_dashboard/Models/category/category_model.dart';
import 'package:ecommerce_dashboard/common/widgets/loaders/tloaders.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../main.dart';

class CategoryRepository {
  Future<int> insertCategoryInTable(Map<String, dynamic> json) async {
    try {
      final response = await supabase
          .from('categories')
          .insert(json)
          .select('category_id')
          .single();

      final categoryId = response['category_id'] as int;
      return categoryId;
    } on PostgrestException catch (e) {
      TLoaders.errorSnackBar(title: 'Categories Repo', message: e.message);
      rethrow;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Categories Repo', message: e.toString());
      rethrow;
    }
  }

  Future<void> updateCategory(CategoryModel plan) async {
    try {
      int? categoryId = plan.categoryId;
      if (categoryId == null) {
        throw Exception('Category ID is required for update.');
      }

      final json = plan.toJson();
      final updateData = Map<String, dynamic>.from(json)
        ..remove('category_id')
        ..remove('product_count');

      await supabase
          .from('categories')
          .update(updateData)
          .eq('category_id', categoryId);

      TLoaders.successSnackBar(title: 'Category Updated');
    } on PostgrestException catch (e) {
      TLoaders.errorSnackBar(title: 'Categories Repo', message: e.message);
      rethrow;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Categories Repo', message: e.toString());
      rethrow;
    }
  }

  Future<void> updateCategoryProductCount(int categoryId, int count) async {
    try {
      await supabase
          .from('categories')
          .update({'product_count': count}).eq('category_id', categoryId);

      if (kDebugMode) {
        print('Updated category $categoryId product count to $count');
      }
    } on PostgrestException catch (e) {
      if (kDebugMode) {
        print('Error updating category product count: ${e.message}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected error updating category product count: $e');
      }
    }
  }

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final data = await supabase.from('categories').select();

      final categoryList = data.map((item) {
        return CategoryModel.fromJson(item);
      }).toList();

      return categoryList;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'fetchCategories', message: e.toString());
      return [];
    }
  }

  Future<int> getCategoryId(String categoryName) async {
    try {
      // Query the Supabase database to find the brand by name
      final response = await supabase
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
      TLoaders.errorSnackBar(
          title: 'Can\'t get Category Id!', message: e.message);
      rethrow;
    } catch (e) {
      // Handle other errors
      TLoaders.errorSnackBar(
          title: 'Can\'t get Category Id!', message: e.toString());
      rethrow;
    }
  }

  Future<void> deleteCategoryFromTable(int categoryId) async {
    try {
      await supabase
          .from('categories')
          .delete()
          .match({'category_id': categoryId});

      TLoaders.successSnackBar(
          title: "Success", message: "Category deleted successfully");
    } catch (e) {
      if (kDebugMode) {
        TLoaders.errorSnackBar(title: 'Category Repo', message: e.toString());
        print("Error deleting category: $e");
      }
    }
  }
}
