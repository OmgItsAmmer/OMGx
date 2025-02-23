import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';


class ReportController extends GetxController {
  static ReportController get instance => Get.find();
 // final MediaRepository mediaRepository = Get.put(MediaRepository());


  //Product Profitability Report
  final selectedProduct = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;



}
