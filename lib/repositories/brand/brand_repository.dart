import 'package:ecommerce_dashboard/common/widgets/loaders/tloaders.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../Models/brand/brand_model.dart';
import '../../main.dart';

class BrandRepository {
  Future<void> updateBrand(Map<String, dynamic> json) async {
    try {
      int? brandId = json['brandID'];
      if (brandId == null) throw Exception('Brand ID is required for update.');

      // Remove brandID from the update payload to avoid trying to update the primary key
      final updateData = Map<String, dynamic>.from(json)..remove('brandID');

      await supabase.from('brands').update(updateData).eq('brandID', brandId);

      TLoaders.successSnackBar(
          title: 'Brand Updated',
          message: '${json['bname']} has been updated.');
    } on PostgrestException catch (e) {
      TLoaders.errorSnackBar(title: 'Brand Repo Error', message: e.message);
      rethrow;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Unexpected Error', message: e.toString());
      rethrow;
    }
  }

  // New method to update product count
  Future<void> updateBrandProductCount(int brandId, int count) async {
    try {
      // Update just the products_count field
      await supabase
          .from('brands')
          .update({'products_count': count}).eq('brandID', brandId);

      if (kDebugMode) {
        print('Updated brand $brandId product count to $count');
      }
    } on PostgrestException catch (e) {
      if (kDebugMode) {
        print('Error updating brand product count: ${e.message}');
      }
      // Don't show error to user for this background operation
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected error updating brand product count: $e');
      }
    }
  }

  Future<int> insertBrandInTable(Map<String, dynamic> json) async {
    try {
      final response =
          await supabase.from('brands').insert(json).select('brandID').single();

      final brandId = response['brandID'] as int;
      return brandId;
    } on PostgrestException catch (e) {
      TLoaders.errorSnackBar(title: 'Brand Repo', message: e.message);
      rethrow;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Brand Repo', message: e.toString());
      rethrow;
    }
  }

  Future<List<BrandModel>> fetchBrands() async {
    try {
      final data = await supabase.from('brands').select();

      final brandList = data.map((item) {
        return BrandModel.fromJson(item);
      }).toList();

      return brandList;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Brand Repo', message: e.toString());
      return [];
    }
  }

  Future<int> getBrandId(String brandName) async {
    try {
      // Query the Supabase database to find the brand by name
      final response = await Supabase.instance.client
          .from('brands')
          .select('brandID')
          .eq('bname', brandName)
          .single();

      // Check if the response contains the brandID
      return response['brandID'] as int? ?? -1;
    } catch (e) {
      return -1;
    }
  }

  Future<void> deleteBrandFromTable(int brandId) async {
    try {
      await supabase.from('brands').delete().match({'brand_id': brandId});

      TLoaders.successSnackBar(
          title: "Success", message: "Brand deleted successfully");
    } catch (e) {
      if (kDebugMode) {
        TLoaders.errorSnackBar(title: 'Brand Repo', message: e.toString());
        print("Error deleting brand: $e");
      }
    }
  }
}
