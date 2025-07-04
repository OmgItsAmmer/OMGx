import 'package:ecommerce_dashboard/common/widgets/loaders/tloaders.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../Models/expense/expense_model.dart';
import '../../main.dart';

class ExpenseRepository extends GetxController {
  static ExpenseRepository get instance => Get.find();

  Future<List<ExpenseModel>> fetchExpenses() async {
    try {
      final response = await supabase.from('expenses').select();
      return ExpenseModel.fromJsonList(response);
    } catch (e) {
      if (kDebugMode) {
        TLoaders.errorSnackBar(title: 'Expense Repo', message: e.toString());
        print('Error fetching expenses: $e');
      }
      return []; // Return an empty list in case of an error
    }
  }

  Future<void> insertExpense(ExpenseModel expense) async {
    try {
      await supabase.from('expenses').insert(expense.toJson(isUpdate: true));
    } catch (e) {
      if (kDebugMode) {
        TLoaders.errorSnackBar(title: 'Expense Repo', message: e.toString());
        print('Error inserting expense: $e');
      }
    }
  }

  Future<void> deleteExpense(int expenseId) async {
    try {
      await supabase.from('expenses').delete().eq('expense_id', expenseId);
    } catch (e) {
      if (kDebugMode) {
        TLoaders.errorSnackBar(title: 'Expense Repo', message: e.toString());
        print('Error deleting expense: $e');
      }
    }
  }
}
