import 'package:ecommerce_dashboard/common/widgets/loaders/tloaders.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../main.dart';
import '../../Models/account_book/account_book_model.dart';

class AccountBookRepository extends GetxController {
  static AccountBookRepository get instance => Get.find();

  /// Fetch all account book entries
  Future<List<AccountBookModel>> fetchAllAccountBookEntries() async {
    try {
      final data = await supabase
          .from('account_book')
          .select()
          .order('transaction_date', ascending: false);

      final accountBookList = data.map((item) {
        return AccountBookModel.fromJson(item);
      }).toList();

      return accountBookList;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
      return [];
    }
  }

  /// Fetch account book entries by entity type
  Future<List<AccountBookModel>> fetchAccountBookEntriesByEntity(
      String entityType) async {
    try {
      final data = await supabase
          .from('account_book')
          .select()
          .eq('entity_type', entityType)
          .order('transaction_date', ascending: false);

      final accountBookList = data.map((item) {
        return AccountBookModel.fromJson(item);
      }).toList();

      return accountBookList;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
      return [];
    }
  }

  /// Fetch account book entries by entity ID
  Future<List<AccountBookModel>> fetchAccountBookEntriesByEntityId(
      int entityId) async {
    try {
      final data = await supabase
          .from('account_book')
          .select()
          .eq('entity_id', entityId)
          .order('transaction_date', ascending: false);

      final accountBookList = data.map((item) {
        return AccountBookModel.fromJson(item);
      }).toList();

      return accountBookList;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
      return [];
    }
  }

  /// Fetch account book entries by date range
  Future<List<AccountBookModel>> fetchAccountBookEntriesByDateRange(
      DateTime startDate, DateTime endDate) async {
    try {
      final data = await supabase
          .from('account_book')
          .select()
          .gte('transaction_date', startDate.toIso8601String())
          .lte('transaction_date', endDate.toIso8601String())
          .order('transaction_date', ascending: false);

      final accountBookList = data.map((item) {
        return AccountBookModel.fromJson(item);
      }).toList();

      return accountBookList;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
      return [];
    }
  }

  /// Get total incoming payments
  Future<double> getTotalIncomingPayments() async {
    try {
      final data = await supabase
          .from('account_book')
          .select('amount')
          .eq('transaction_type', 'buy');

      double total = 0.0;
      for (var item in data) {
        total += (item['amount'] as num).toDouble();
      }
      return total;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
      return 0.0;
    }
  }

  /// Get total outgoing payments
  Future<double> getTotalOutgoingPayments() async {
    try {
      final data = await supabase
          .from('account_book')
          .select('amount')
          .eq('transaction_type', 'sell');

      double total = 0.0;
      for (var item in data) {
        total += (item['amount'] as num).toDouble();
      }
      return total;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
      return 0.0;
    }
  }

  /// Insert new account book entry
  Future<int> insertAccountBookEntry(Map<String, dynamic> json) async {
    try {
      final response = await supabase
          .from('account_book')
          .insert(json)
          .select('account_book_id')
          .single();

      final accountBookId = response['account_book_id'] as int;
      return accountBookId;
    } on PostgrestException catch (e) {
      TLoaders.errorSnackBar(title: 'Account Book Repo', message: e.message);
      rethrow;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Account Book Repo', message: e.toString());
      rethrow;
    }
  }

  /// Update existing account book entry
  Future<void> updateAccountBookEntry(Map<String, dynamic> json) async {
    try {
      int? accountBookId = json['account_book_id'];
      if (accountBookId == null) {
        throw Exception('Account Book ID is required for update.');
      }

      // Remove account_book_id from the update payload to avoid trying to update the primary key
      final updateData = Map<String, dynamic>.from(json)
        ..remove('account_book_id');

      await supabase
          .from('account_book')
          .update(updateData)
          .eq('account_book_id', accountBookId);
    } on PostgrestException catch (e) {
      TLoaders.errorSnackBar(title: 'Account Book Repo', message: e.message);
      rethrow;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Account Book Repo', message: e.toString());
      rethrow;
    }
  }

  /// Delete account book entry
  Future<void> deleteAccountBookEntry(int accountBookId) async {
    try {
      await supabase
          .from('account_book')
          .delete()
          .match({'account_book_id': accountBookId});

      TLoaders.successSnackBar(
          title: "Success", message: "Account book entry deleted successfully");
    } catch (e) {
      if (kDebugMode) {
        TLoaders.errorSnackBar(
            title: 'Account Book Repo', message: e.toString());
        print("Error deleting account book entry: $e");
      }
    }
  }

  /// Get account summary by entity type
  Future<Map<String, double>> getAccountSummaryByEntityType() async {
    try {
      final data = await supabase
          .from('account_book')
          .select('entity_type, transaction_type, amount');

      Map<String, double> summary = {
        'customer_incoming': 0.0,
        'customer_outgoing': 0.0,
        'vendor_incoming': 0.0,
        'vendor_outgoing': 0.0,
        'salesman_incoming': 0.0,
        'salesman_outgoing': 0.0,
      };

      for (var item in data) {
        String entityType = item['entity_type'];
        String transactionType = item['transaction_type'];
        double amount = (item['amount'] as num).toDouble();

        String key =
            '${entityType}_${transactionType == 'buy' ? 'incoming' : 'outgoing'}';
        summary[key] = (summary[key] ?? 0.0) + amount;
      }

      return summary;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
      return {};
    }
  }

  /// Search account book entries
  Future<List<AccountBookModel>> searchAccountBookEntries(
      String searchTerm) async {
    try {
      final data = await supabase
          .from('account_book')
          .select()
          .or('entity_name.ilike.%$searchTerm%,description.ilike.%$searchTerm%,reference.ilike.%$searchTerm%')
          .order('transaction_date', ascending: false);

      final accountBookList = data.map((item) {
        return AccountBookModel.fromJson(item);
      }).toList();

      return accountBookList;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
      return [];
    }
  }

  /// Fetch all customers for entity selection
  Future<List<Map<String, dynamic>>> fetchCustomersForSelection() async {
    try {
      final data = await supabase
          .from('customers')
          .select('customer_id, first_name, last_name, phone_number')
          .order('first_name');

      return data
          .map((item) => {
                'id': item['customer_id'],
                'name': '${item['first_name']} ${item['last_name']}',
                'phone': item['phone_number'],
              })
          .toList();
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
      return [];
    }
  }

  /// Fetch all vendors for entity selection
  Future<List<Map<String, dynamic>>> fetchVendorsForSelection() async {
    try {
      final data = await supabase
          .from('vendors')
          .select('vendor_id, first_name, last_name, phone_number')
          .order('first_name');

      return data
          .map((item) => {
                'id': item['vendor_id'],
                'name': '${item['first_name']} ${item['last_name']}',
                'phone': item['phone_number'],
              })
          .toList();
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
      return [];
    }
  }

  /// Fetch all salesmen for entity selection
  Future<List<Map<String, dynamic>>> fetchSalesmenForSelection() async {
    try {
      final data = await supabase
          .from('salesman')
          .select('salesman_id, first_name, last_name, phone_number')
          .order('first_name');

      return data
          .map((item) => {
                'id': item['salesman_id'],
                'name': '${item['first_name']} ${item['last_name']}',
                'phone': item['phone_number'],
              })
          .toList();
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
      return [];
    }
  }
}
