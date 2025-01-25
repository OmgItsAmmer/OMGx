import 'package:admin_dashboard_v3/Models/products/product_model.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:flutter/foundation.dart';

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
      TLoader.errorsnackBar(title: 'Product Repo',message: e.toString());
      return [];
    }

  }


}