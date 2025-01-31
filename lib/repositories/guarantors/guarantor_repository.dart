

import 'package:admin_dashboard_v3/Models/guarantors/guarantors_model.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../main.dart';


class GuarantorRepository extends GetxController {
  static GuarantorRepository get instance => Get.find();



  Future<List<GuarantorsModel>> fetchAllGuarantors() async {
    try {
      final data =  await supabase.from('guarantors').select();
      //print(data);

      final guarantorList = data.map((item) {
        return GuarantorsModel.fromJson(item);
      }).toList();
      if (kDebugMode) {
        print(guarantorList[1].fullName);
      }
      return guarantorList;
    } catch (e) {
      TLoader.errorsnackBar(title: 'Oh Snap', message: e.toString());
      return [];
    }

  }

  Future<List<int>> uploadGuarantors(List<Map<String, dynamic>> guarantors) async {
    try {
      final insertedData = await supabase.from('guarantors').insert(guarantors).select('guarantor_id');

      // Extract guarantor IDs from the inserted data
      List<int> guarantorIds = insertedData.map<int>((item) => item['guarantor_id'] as int).toList();

      return guarantorIds;
    } catch (e) {
      TLoader.errorsnackBar(title: 'Oh Snap', message: e.toString());
      return [];
    }
  }





}