import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TableSearchController extends GetxController {
  static TableSearchController get instance => Get.find();

  // Search controller for text fields
  final searchController = TextEditingController();

  // Observable search term
  final Rx<String> searchTerm = ''.obs;

  // Observable sort state
  final Rx<int?> sortColumnIndex = Rx<int?>(0);
  final Rx<bool> sortAscending = true.obs;

  // Available rows per page options
  final availableRowsPerPage = [5, 10, 25, 50];
  final Rx<int> rowsPerPage = 10.obs;

  // Initialize controller
  @override
  void onInit() {
    super.onInit();
    // Listen to changes in the search field
    searchController.addListener(() {
      searchTerm.value = searchController.text;
    });
  }

  // Sort function that can be used by different tables
  void sort(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;
  }

  // Update rows per page
  void updateRowsPerPage(int value) {
    rowsPerPage.value = value;
  }

  // Clean up
  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
