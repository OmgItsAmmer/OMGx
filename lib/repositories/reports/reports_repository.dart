

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../main.dart';

import '../../Models/reports/recovey_salesman_report_model.dart';
import '../../Models/reports/sale_report_model.dart';

class ReportsRepository extends GetxController {
  static ReportsRepository get instance => Get.find();


  Future<List<SalesReportModel>> fetchMonthlySalesReport({
    required int month,
    required int year,
  }) async {
    try {
      final response = await supabase.rpc('get_monthly_sales_report', params: {
        'month_input': month,
        'year_input': year,
      });

      if (response == null || response is! List) {
        throw Exception('No data received or invalid format from Supabase.');
      }

      return response.map<SalesReportModel>((data) {
        return SalesReportModel.fromJson(data as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching sales report: $e');
    }
  }

  Future<List<RecoveryReportModel>> getSalesmanRecoveryReport({
    required int salesmanId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await supabase.rpc('get_salesman_recovery_report', params: {
        'salesman_id': salesmanId,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
      });

      if (response.isEmpty) return [];

      return (response as List)
          .map((e) => RecoveryReportModel.fromJson(e))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception('Error fetching report: ${e.message}');
    }
  }
}




