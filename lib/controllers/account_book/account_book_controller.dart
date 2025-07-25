import 'package:ecommerce_dashboard/Models/account_book/account_book_model.dart';
import 'package:ecommerce_dashboard/Models/customer/customer_model.dart';
import 'package:ecommerce_dashboard/Models/entity/entity_model.dart';
import 'package:ecommerce_dashboard/repositories/account_book/account_book_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../common/widgets/loaders/tloaders.dart';
import '../../utils/constants/enums.dart';
import '../customer/customer_controller.dart';
import '../vendor/vendor_controller.dart';
import '../salesman/salesman_controller.dart';

class AccountBookController extends GetxController {
  static AccountBookController get instance => Get.find();
  final AccountBookRepository accountBookRepository =
      Get.put(AccountBookRepository());

  final isLoading = false.obs;
  final isUpdating = false.obs;
  final isSummaryLoading = false.obs;

  // Lists for different data
  RxList<AccountBookModel> allAccountBookEntries = <AccountBookModel>[].obs;
  RxList<AccountBookModel> filteredEntries = <AccountBookModel>[].obs;

  // Summary data
  Rx<double> totalIncoming = 0.0.obs;
  Rx<double> totalOutgoing = 0.0.obs;
  Rx<double> netBalance = 0.0.obs;
  RxMap<String, double> entitySummary = <String, double>{}.obs;

  // Selected entry for editing
  Rx<AccountBookModel> selectedEntry = AccountBookModel.empty().obs;

  // Form controllers
  final entityTypeController = TextEditingController();
  final entityIdController = TextEditingController();
  final entityNameController = TextEditingController();
  final entitySearchController = TextEditingController(); // For autocomplete
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  final referenceController = TextEditingController();
  final transactionDateController = TextEditingController();

  // Dropdowns
  Rx<TransactionType> selectedTransactionType = TransactionType.sell.obs;
  Rx<EntityType> selectedEntityType = EntityType.customer.obs;
  Rx<DateTime> selectedTransactionDate = DateTime.now().obs;

  // Entity selection
  RxList<EntityModel> availableEntities = <EntityModel>[].obs;
  Rx<EntityModel?> selectedEntity = Rx<EntityModel?>(null);
  final isLoadingEntities = false.obs;

  // Form key
  GlobalKey<FormState> accountBookFormKey = GlobalKey<FormState>();

  // Search and filter
  final searchController = TextEditingController();
  RxString searchTerm = ''.obs;
  Rx<EntityType?> filterEntityType = Rx<EntityType?>(null);
  Rx<TransactionType?> filterTransactionType = Rx<TransactionType?>(null);
  Rx<DateTime?> filterStartDate = Rx<DateTime?>(null);
  Rx<DateTime?> filterEndDate = Rx<DateTime?>(null);

  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchAllAccountBookEntries();
  //   loadSummaryData();
  //   loadEntitiesForCurrentType();

  //   // Listen to search changes
  //   searchController.addListener(() {
  //     searchTerm.value = searchController.text;
  //     filterEntries();
  //   });

  //   // Listen to filter changes
  //   ever(filterEntityType, (_) => filterEntries());
  //   ever(filterTransactionType, (_) => filterEntries());
  //   ever(filterStartDate, (_) => filterEntries());
  //   ever(filterEndDate, (_) => filterEntries());

  //   // Listen to entity type changes to load relevant entities
  //   ever(selectedEntityType, (_) => loadEntitiesForCurrentType());
  // }
  Future<void> setUpAccountBook() async {
    await fetchAllAccountBookEntries();
    await loadSummaryData();
    await loadEntitiesForCurrentType();

    // Listen to search changes
    searchController.addListener(() {
      searchTerm.value = searchController.text;
      filterEntries();
    });

    // Listen to filter changes
    ever(filterEntityType, (_) => filterEntries());
    ever(filterTransactionType, (_) => filterEntries());
    ever(filterStartDate, (_) => filterEntries());
    ever(filterEndDate, (_) => filterEntries());

    // Listen to entity type changes to load relevant entities
    ever(selectedEntityType, (_) => loadEntitiesForCurrentType());
  }

  @override
  void onClose() {
    entityTypeController.dispose();
    entityIdController.dispose();
    entityNameController.dispose();
    entitySearchController.dispose();
    amountController.dispose();
    descriptionController.dispose();
    referenceController.dispose();
    transactionDateController.dispose();
    searchController.dispose();
    super.onClose();
  }

  /// Fetch all account book entries
  Future<void> fetchAllAccountBookEntries() async {
    try {
      isLoading.value = true;
      final entries = await accountBookRepository.fetchAllAccountBookEntries();
      allAccountBookEntries.assignAll(entries);
      filteredEntries.assignAll(entries);
    } catch (e) {
      TLoaders.errorSnackBar(title: "Oh Snap!", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Load summary data
  Future<void> loadSummaryData() async {
    try {
      isSummaryLoading.value = true;

      // Get totals
      final incoming = await accountBookRepository.getTotalIncomingPayments();
      final outgoing = await accountBookRepository.getTotalOutgoingPayments();

      totalIncoming.value = incoming;
      totalOutgoing.value = outgoing;
      netBalance.value = incoming - outgoing;

      // Get entity summary
      final summary =
          await accountBookRepository.getAccountSummaryByEntityType();
      entitySummary.assignAll(summary);
    } catch (e) {
      TLoaders.errorSnackBar(title: "Oh Snap!", message: e.toString());
    } finally {
      isSummaryLoading.value = false;
    }
  }

  /// Filter entries based on search and filters
  void filterEntries() {
    List<AccountBookModel> filtered = allAccountBookEntries.toList();

    // Apply search filter
    if (searchTerm.value.isNotEmpty) {
      filtered = filtered.where((entry) {
        return entry.entityName
                .toLowerCase()
                .contains(searchTerm.value.toLowerCase()) ||
            entry.description
                .toLowerCase()
                .contains(searchTerm.value.toLowerCase()) ||
            (entry.reference
                    ?.toLowerCase()
                    .contains(searchTerm.value.toLowerCase()) ??
                false);
      }).toList();
    }

    // Apply entity type filter
    if (filterEntityType.value != null) {
      String entityTypeString =
          filterEntityType.value.toString().split('.').last;
      filtered = filtered
          .where((entry) => entry.entityType == entityTypeString)
          .toList();
    }

    // Apply transaction type filter
    if (filterTransactionType.value != null) {
      filtered = filtered
          .where(
              (entry) => entry.transactionType == filterTransactionType.value)
          .toList();
    }

    // Apply date range filter
    if (filterStartDate.value != null) {
      filtered = filtered
          .where((entry) =>
              entry.transactionDate.isAfter(filterStartDate.value!) ||
              entry.transactionDate.isAtSameMomentAs(filterStartDate.value!))
          .toList();
    }

    if (filterEndDate.value != null) {
      filtered = filtered
          .where((entry) => entry.transactionDate
              .isBefore(filterEndDate.value!.add(const Duration(days: 1))))
          .toList();
    }

    filteredEntries.assignAll(filtered);
  }

  /// Clear all filters
  void clearFilters() {
    searchController.clear();
    searchTerm.value = '';
    filterEntityType.value = null;
    filterTransactionType.value = null;
    filterStartDate.value = null;
    filterEndDate.value = null;
    filteredEntries.assignAll(allAccountBookEntries);
  }

  /// Refresh data
  Future<void> refreshData() async {
    try {
      isLoading.value = true;
      await fetchAllAccountBookEntries();
      await loadSummaryData();
      TLoaders.successSnackBar(
        title: 'Refreshed!',
        message: 'Account book data has been updated.',
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error refreshing account book: $e');
      }
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to refresh data: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Insert new account book entry
  Future<void> insertAccountBookEntry() async {
    try {
      isUpdating.value = true;

      if (!accountBookFormKey.currentState!.validate()) {
        TLoaders.errorSnackBar(
          title: "Empty Fields",
          message: 'Kindly fill all the fields before proceeding.',
        );
        return;
      }

      if (selectedEntity.value == null) {
        TLoaders.errorSnackBar(
          title: "Entity Required",
          message:
              'Please select a ${selectedEntityType.value.toString().split('.').last}.',
        );
        return;
      }

      final accountBookModel = AccountBookModel(
        accountBookId: null,
        entityType: selectedEntityType.value.toString().split('.').last,
        entityId: int.parse(entityIdController.text),
        entityName: entityNameController.text,
        transactionType: selectedTransactionType.value,
        amount: double.parse(amountController.text),
        description: descriptionController.text,
        reference:
            referenceController.text.isEmpty ? null : referenceController.text,
        transactionDate: selectedTransactionDate.value,
      );

      final json = accountBookModel.toJson(isUpdate: true);
      final accountBookId =
          await accountBookRepository.insertAccountBookEntry(json);

      // Update the model with the returned ID
      accountBookModel.accountBookId = accountBookId;

      // Add to local list
      allAccountBookEntries.insert(0, accountBookModel);
      filterEntries();

      // Refresh summary
      await loadSummaryData();

      clearForm();
      TLoaders.successSnackBar(
          title: 'Entry Added!',
          message: 'Account book entry added successfully');
    } catch (e) {
      TLoaders.errorSnackBar(
        title: "Error",
        message: e.toString(),
      );
    } finally {
      isUpdating.value = false;
    }
  }

  /// Update existing account book entry
  Future<void> updateAccountBookEntry(int accountBookId) async {
    try {
      isUpdating.value = true;

      if (!accountBookFormKey.currentState!.validate()) {
        TLoaders.errorSnackBar(
          title: "Empty Fields",
          message: 'Kindly fill all the fields before proceeding.',
        );
        return;
      }

      if (selectedEntity.value == null) {
        TLoaders.errorSnackBar(
          title: "Entity Required",
          message:
              'Please select a ${selectedEntityType.value.toString().split('.').last}.',
        );
        return;
      }

      final accountBookModel = AccountBookModel(
        accountBookId: accountBookId,
        entityType: selectedEntityType.value.toString().split('.').last,
        entityId: int.parse(entityIdController.text),
        entityName: entityNameController.text,
        transactionType: selectedTransactionType.value,
        amount: double.parse(amountController.text),
        description: descriptionController.text,
        reference:
            referenceController.text.isEmpty ? null : referenceController.text,
        transactionDate: selectedTransactionDate.value,
      );

      final json = accountBookModel.toJson(isUpdate: false);
      await accountBookRepository.updateAccountBookEntry(json);

      // Update local list
      int index = allAccountBookEntries
          .indexWhere((entry) => entry.accountBookId == accountBookId);
      if (index != -1) {
        allAccountBookEntries[index] = accountBookModel;
        filterEntries();
      }

      // Refresh summary
      await loadSummaryData();

      clearForm();
      TLoaders.successSnackBar(
          title: 'Entry Updated!',
          message: 'Account book entry updated successfully');
    } catch (e) {
      TLoaders.errorSnackBar(
        title: "Error",
        message: e.toString(),
      );
    } finally {
      isUpdating.value = false;
    }
  }

  /// Delete account book entry
  Future<void> deleteAccountBookEntry(int accountBookId) async {
    try {
      await accountBookRepository.deleteAccountBookEntry(accountBookId);

      // Remove from local list
      allAccountBookEntries
          .removeWhere((entry) => entry.accountBookId == accountBookId);
      filterEntries();

      // Refresh summary
      await loadSummaryData();
    } catch (e) {
      TLoaders.errorSnackBar(
        title: "Error",
        message: e.toString(),
      );
    }
  }

  /// Load entry for editing
  void loadEntryForEditing(AccountBookModel entry) {
    selectedEntry.value = entry;
    entityIdController.text = entry.entityId.toString();
    entityNameController.text = entry.entityName;
    amountController.text = entry.amount.toString();
    descriptionController.text = entry.description;
    referenceController.text = entry.reference ?? '';

    selectedTransactionType.value = entry.transactionType;
    selectedTransactionDate.value = entry.transactionDate;

    // Set entity type based on string
    switch (entry.entityType.toLowerCase()) {
      case 'customer':
        selectedEntityType.value = EntityType.customer;
        break;
      case 'vendor':
        selectedEntityType.value = EntityType.vendor;
        break;
      case 'salesman':
        selectedEntityType.value = EntityType.salesman;
        break;
    }

    // Set selected entity for editing
    selectedEntity.value = EntityModel(
      id: entry.entityId,
      name: entry.entityName,
      type: selectedEntityType.value,
    );

    // Set search controller for autocomplete display
    entitySearchController.text = entry.entityName;
  }

  /// Clear form
  void clearForm() {
    entityIdController.clear();
    entityNameController.clear();
    entitySearchController.clear();
    amountController.clear();
    descriptionController.clear();
    referenceController.clear();

    selectedTransactionType.value = TransactionType.sell;
    selectedEntityType.value = EntityType.customer;
    selectedTransactionDate.value = DateTime.now();
    selectedEntry.value = AccountBookModel.empty();
    selectedEntity.value = null;
    // Note: availableEntities will be refreshed when entity type changes
  }

  /// Get entries by entity type
  List<AccountBookModel> getEntriesByEntityType(EntityType entityType) {
    String entityTypeString = entityType.toString().split('.').last;
    return allAccountBookEntries
        .where((entry) => entry.entityType == entityTypeString)
        .toList();
  }

  /// Get total amount by entity and transaction type
  double getTotalAmountByType(
      EntityType entityType, TransactionType transactionType) {
    String entityTypeString = entityType.toString().split('.').last;
    return allAccountBookEntries
        .where((entry) =>
            entry.entityType == entityTypeString &&
            entry.transactionType == transactionType)
        .fold(0.0, (sum, entry) => sum + entry.amount);
  }

  /// Load entities based on currently selected entity type
  Future<void> loadEntitiesForCurrentType() async {
    try {
      isLoadingEntities.value = true;
      selectedEntity.value = null; // Clear current selection
      entitySearchController.clear(); // Clear search field

      List<EntityModel> entities = [];

      switch (selectedEntityType.value) {
        case EntityType.customer:
          final customerController = Get.find<CustomerController>();
          await customerController.fetchAllCustomers();
          entities = customerController.allCustomers
              .map((customer) => EntityModel.fromCustomer(customer))
              .toList();
          break;
        case EntityType.vendor:
          final vendorController = Get.find<VendorController>();
          await vendorController.fetchAllVendors();
          entities = vendorController.allVendors
              .map((vendor) => EntityModel.fromVendor(vendor))
              .toList();
          break;
        case EntityType.salesman:
          final salesmanController = Get.find<SalesmanController>();
          await salesmanController.fetchAllSalesman();
          entities = salesmanController.allSalesman
              .map((salesman) => EntityModel.fromSalesman(salesman))
              .toList();
          break;
        case EntityType.user:
          // User type is not supported for account book entries
          entities = [];
          break;
      }

      availableEntities.assignAll(entities);
    } catch (e) {
      TLoaders.errorSnackBar(title: "Error", message: e.toString());
    } finally {
      isLoadingEntities.value = false;
    }
  }

  /// Handle entity selection
  void onEntitySelected(EntityModel? entity) {
    selectedEntity.value = entity;
    if (entity != null) {
      entityIdController.text = entity.id.toString();
      entityNameController.text = entity.name;

      // Update search controller for autocomplete display
      String display = entity.name;
      if (entity.phoneNumber != null && entity.phoneNumber!.isNotEmpty) {
        display += ' - ${entity.phoneNumber}';
      }
      entitySearchController.text = display;
    }
  }

  /// Clear entity selection
  void clearEntitySelection() {
    selectedEntity.value = null;
    availableEntities.clear();
    entityIdController.clear();
    entityNameController.clear();
    entitySearchController.clear();
  }
}
