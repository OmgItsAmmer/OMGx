import 'package:admin_dashboard_v3/Models/reports/simple_pnl_report_model.dart';
import 'package:admin_dashboard_v3/Models/reports/upcoming_installments_report_model.dart';
import 'package:admin_dashboard_v3/Models/reports/overdue_installments_report_model.dart';
import 'package:admin_dashboard_v3/Models/account_book/account_book_model.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../main.dart';

import '../../Models/reports/pnl_report_model.dart';
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

  Future<List<SalesmanRecoveryModel>> fetchSalesmanRecoveryReport(
      {required DateTime startDate,
      required DateTime endDate,
      int? salesmanId // Optional parameter for specific salesman
      }) async {
    try {
      String startDateFormatted = startDate.toIso8601String().split("T")[0];
      String endDateFormatted = endDate.toIso8601String().split("T")[0];

      // Create params map
      final params = {
        'start_date': startDateFormatted,
        'end_date': endDateFormatted,
      };

      // Add salesmanId parameter only if provided
      if (salesmanId != null) {
        params['specific_salesman_id'] = salesmanId.toString();
      }

      final response = await supabase.rpc(
        'get_salesman_recovery_report',
        params: params,
      );

      List<SalesmanRecoveryModel> reportList = (response as List)
          .map((item) =>
              SalesmanRecoveryModel.fromJson(item as Map<String, dynamic>))
          .toList();

      return reportList;
    } catch (e) {
      TLoaders.errorSnackBar(title: e.toString());
      print(e);
      return [];
    }
  }

// Fetch detailed report for a specific salesman (used in SalesmanReportPage)
  Future<List<RecoveryReportModel>> fetchSalesmanDetailedReport({
    required int salesmanId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      String startDateFormatted = startDate.toIso8601String().split("T")[0];
      String endDateFormatted = endDate.toIso8601String().split("T")[0];

      final response = await supabase.rpc(
        'get_salesman_report',
        params: {
          'start_date': startDateFormatted,
          'end_date': endDateFormatted,
          'salesman_id': salesmanId,
        },
      );

      if (response == null) {
        throw Exception('No data received from Supabase.');
      }

      List<RecoveryReportModel> reportList = [];

      // Process each item individually to identify which specific record is causing issues
      for (var i = 0; i < (response as List).length; i++) {
        try {
          var item = response[i] as Map<String, dynamic>;

          // Add debug info to see what's in each record
          print('Processing record $i: ${item.toString()}');

          // Check for null values in numeric fields
          if (item['sale_price'] == null) {
            print('Warning: sale_price is null for record $i');
          }
          if (item['commission_percent'] == null) {
            print('Warning: commission_percent is null for record $i');
          }
          if (item['commission_in_rs'] == null) {
            print('Warning: commission_in_rs is null for record $i');
          }

          reportList.add(RecoveryReportModel.fromJson(item));
        } catch (e) {
          print('Error parsing record $i: $e');
          // Continue processing other records instead of failing completely
        }
      }

      return reportList;
    } catch (e) {
      print('Error fetching salesman detailed report: $e');
      throw Exception('Error fetching salesman detailed report: $e');
    }
  }

  Future<List<SimplePnLReportModel>> fetchSimplePnLReport(
      DateTime startDate, DateTime endDate) async {
    try {
      final response = await supabase.rpc('get_simple_pnl_report', params: {
        'start_date': startDate.toIso8601String().split('T')[0],
        'end_date': endDate.toIso8601String().split('T')[0],
      });

      if (response == null || response is! List) {
        throw Exception('No data received or invalid format from Supabase.');
      }

      return (response as List)
          .map((item) =>
              SimplePnLReportModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      TLoaders.errorSnackBar(title: e.toString());
      return [];
    }
  }

  Future<List<PnLReportModel>> fetchPnLReportData(
      DateTime startDate, DateTime endDate) async {
    try {
      String startDateFormatted = startDate.toIso8601String().split("T")[0];
      String endDateFormatted = endDate.toIso8601String().split("T")[0];

      final response = await supabase.rpc(
        'get_profit_loss_report',
        params: {
          'start_date': startDateFormatted,
          'end_date': endDateFormatted,
        },
      );

      List<PnLReportModel> reportList = (response as List)
          .map((item) => PnLReportModel.fromJson(item as Map<String, dynamic>))
          .toList();

      return reportList;
    } catch (e) {
      TLoaders.errorSnackBar(title: e.toString());
      print(e);
      return [];
    }
  }

  Future<List<OverdueInstallmentsReportModel>>
      fetchOverdueInstallmentsReport() async {
    try {
      final response = await supabase.rpc('get_overdue_installments_report');

      return (response as List)
          .map((item) => OverdueInstallmentsReportModel.fromJson(
              item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        TLoaders.errorSnackBar(title: e.toString());
        print(e);
      }
      return [];
    }
  }

  Future<List<UpcomingInstallmentsReportModel>> fetchUpcomingInstallmentsReport(
      int daysAhead) async {
    try {
      final response =
          await supabase.rpc('get_upcoming_installments_report', params: {
        'days_ahead': daysAhead,
      });

      return (response as List)
          .map((item) => UpcomingInstallmentsReportModel.fromJson(
              item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        TLoaders.errorSnackBar(title: e.toString());
        print(e);
      }
      return [];
    }
  }

  // Debug methods to troubleshoot installment issues
  // Future<void> debugInstallmentPayments() async {
  //   try {
  //     final response = await supabase.rpc('debug_installment_payments');
  //     if (kDebugMode) {
  //       print('Debug Installment Payments:');
  //       print(response);
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Debug installment payments error: $e');
  //     }
  //   }
  // }

  // Future<void> debugInstallmentPlans() async {
  //   try {
  //     final response = await supabase.rpc('debug_installment_plans');
  //     if (kDebugMode) {
  //       print('Debug Installment Plans:');
  //       print(response);
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Debug installment plans error: $e');
  //     }
  //   }
  // }

  // Future<void> debugSimpleUpcomingInstallments() async {
  //   try {
  //     final response = await supabase.rpc('simple_upcoming_installments');
  //     if (kDebugMode) {
  //       print('Simple Upcoming Installments:');
  //       print(response);
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Simple upcoming installments error: $e');
  //     }
  //   }
  // }

  /// Fetch account book entries by entity for report generation
  Future<List<AccountBookModel>> fetchAccountBookByEntity({
    required int entityId,
    required String entityType,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      String startDateFormatted = startDate.toIso8601String().split("T")[0];
      String endDateFormatted = endDate.toIso8601String().split("T")[0];

      final response = await supabase
          .from('account_book')
          .select()
          .eq('entity_id', entityId)
          .eq('entity_type', entityType)
          .gte('transaction_date', startDateFormatted)
          .lte('transaction_date', endDateFormatted)
          .order('transaction_date', ascending: false);

      return response
          .map(
              (item) => AccountBookModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        TLoaders.errorSnackBar(title: e.toString());
        print('Error fetching account book by entity: $e');
      }
      return [];
    }
  }
}
