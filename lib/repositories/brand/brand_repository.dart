import 'package:admin_dashboard_v3/Models/products/product_model.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../Models/brand/brand_model.dart';
import '../../main.dart';

class BrandRepository {




  Future<void> saveOrUpdateBrandRepo(Map<String, dynamic> json) async {
    try {
      final brandId = json['brandID'];

      if (brandId != null && brandId != -1) {
        // Check if brand with brandID exists
        final existingBrand = await supabase
            .from('brands')
            .select()
            .eq('brandID', brandId)
            .maybeSingle();

        if (existingBrand != null) {
          // Update existing brand
          await supabase
              .from('brands')
              .update(json)
              .eq('brandID', brandId);
          return;
        }
      }

      // Insert new brand (remove brandID if it's -1 or not needed)
      json.remove('brandID');
      await supabase.from('brands').insert(json);

      TLoader.successSnackBar(title: 'Brand Added!',message: json['bname'] + ' is Added');

    } on PostgrestException catch (e) {
      TLoader.errorSnackBar(title: 'Brand Repo Error', message: e.message);
      rethrow;
    } catch (e) {
      TLoader.errorSnackBar(title: 'Unexpected Error', message: e.toString());
      rethrow;
    }
  }




  Future<List<BrandModel>> fetchBrands() async {
    try {
      final data = await supabase.from('brands').select();
      //print(data);

      final brandList = data.map((item) {
        return BrandModel.fromJson(item);
      }).toList();
      if (kDebugMode) {
        print(brandList[1].bname);
      }
      return brandList;
    } catch (e) {
      TLoader.errorSnackBar(title: 'Brand Repo', message: e.toString());
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
      // Handle errors and return -1 instead of throwing an exception
     // TLoader.errorSnackBar(title: 'Can\'t get Brand Id!', message: e.toString());
      return -1;
    }
  }

}
