import 'package:admin_dashboard_v3/Models/products/product_model.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../Models/brand/brand_model.dart';
import '../../main.dart';

class BrandRepository {




  Future<void> saveOrUpdateBrandRepo(Map<String, dynamic> json) async {
    try {


      if (json['brandID'] != null) {
        // Fetch the brand with the given brandID
        final response = await supabase
            .from('brands')
            .select()
            .eq('brandID', json['brandID'])
            .maybeSingle(); // Avoids exception if no brand is found

        if (response != null) {
          // If the brand exists, update it
          await supabase
              .from('brands')
              .update(json)
              .eq('brandID', json['brandID']);
        } else {
          // If no existing brand is found, insert a new one
          // Remove the brandID to let the database auto-generate it
          json.remove('brandID');
          await supabase.from('brands').insert(json);
        }
      } else {
        // If brandID is not provided, insert a new brand
        // Ensure brandID is not present in the json
        json.remove('brandID');
        await supabase.from('brands').insert(json);
      }
    } on PostgrestException catch (e) {
      // Handle Supabase-specific errors
      TLoader.errorSnackBar(title: 'Brand Repo', message: e.message);
      rethrow;
    } catch (e) {
      // Handle other errors
      TLoader.errorSnackBar(title: 'Brand Repo', message: e.toString());
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
