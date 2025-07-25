import 'package:ecommerce_dashboard/Models/expense/expense_model.dart';
import 'package:ecommerce_dashboard/common/widgets/loaders/tloaders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../repositories/expnese/expense_repository.dart';

class ExpenseController extends GetxController {
  static ExpenseController get instance => Get.find();
  final ExpenseRepository expenseRepository = Get.put(ExpenseRepository());

  final TextEditingController description = TextEditingController();
  final TextEditingController amount = TextEditingController();

  RxList<ExpenseModel> expenses = <ExpenseModel>[].obs;

  RxBool isExpenseFetching = false.obs;

  // @override
  // void onInit() {
  //   fetchExpenses();
  //   super.onInit();
  // }

  @override
  void onClose() {
    description.dispose();
    amount.dispose();
    super.onClose();
  }

  Future<void> fetchExpenses() async {
    try {
      isExpenseFetching.value = true;
      expenses.assignAll(await expenseRepository.fetchExpenses());
    } catch (e) {
      if (kDebugMode) {
        TLoaders.errorSnackBar(
            title: 'Expense Controller', message: e.toString());
        print(e);
      }
    } finally {
      isExpenseFetching.value = false;
    }
  }

  Future<void> addExpense() async {
    try {
      if (description.text.isEmpty || amount.text.isEmpty) {
        TLoaders.errorSnackBar(
            title: 'Expense Controller', message: 'Please fill all fields');
        return;
      }

      final expense = ExpenseModel(
        expenseId: 0, // The actual ID will be set by the database
        description: description.text,
        amount: double.parse(amount.text),
      );

      await expenseRepository.insertExpense(expense);

      expenses.add(expense);

      description.clear();
      amount.clear();
    } catch (e) {
      if (kDebugMode) {
        TLoaders.errorSnackBar(
            title: 'Expense Controller', message: e.toString());
        print(e);
      }
    }
  }

  Future<void> deleteExpense(int expenseId) async {
    try {
      await expenseRepository.deleteExpense(expenseId);

      // Remove the deleted expense from the list
      expenses.removeWhere((expense) => expense.expenseId == expenseId);
    } catch (e) {
      if (kDebugMode) {
        TLoaders.errorSnackBar(
            title: 'Expense Controller', message: e.toString());
        print(e);
      }
    }
  }
}
