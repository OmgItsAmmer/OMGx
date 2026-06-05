import 'package:ecommerce_dashboard/Models/brand/brand_model.dart';
import 'package:ecommerce_dashboard/Models/category/category_model.dart';
import 'package:ecommerce_dashboard/Models/customer/customer_model.dart';
import 'package:ecommerce_dashboard/Models/orders/order_item_model.dart';
import 'package:ecommerce_dashboard/Models/products/product_model.dart';
import 'package:ecommerce_dashboard/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchItem {
  final String title;
  final String route;
  final dynamic arguments;

  SearchItem({required this.title, required this.route, this.arguments});
}

class TSearchController extends GetxController {
  // Singleton instance pattern
  static TSearchController? _instance;

  // Get a singleton instance
  static TSearchController get instance {
    _instance ??= Get.isRegistered<TSearchController>()
          ? Get.find<TSearchController>()
          : Get.put(TSearchController());
    return _instance!;
  }

  // List of all searchable items
  final RxList<SearchItem> allSearchItems = <SearchItem>[].obs;

  // Filtered items based on search query
  final RxList<SearchItem> filteredItems = <SearchItem>[].obs;

  // Search text controller
  final TextEditingController searchController = TextEditingController();

  // Loading state
  final RxBool isLoading = false.obs;

  // Search overlay visibility
  final RxBool isSearchOverlayVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeSearchItems();

    // Listen to text changes and filter items
    searchController.addListener(() {
      filterSearchResults(searchController.text);
    });
  }

  // Initialize all searchable items from routes
  void initializeSearchItems() {
    allSearchItems.value = [
      // Dashboard
      SearchItem(title: 'Dashboard', route: TRoutes.dashboard),

      // Orders
      SearchItem(title: 'Orders', route: TRoutes.orders),
      // SearchItem(title: 'Order Details', route: TRoutes.orderDetails, arguments: OrderModel.empty()),

      // Products
      SearchItem(title: 'Products', route: TRoutes.products),
      // SearchItem(
      //     title: 'Add Product',
      //     route: TRoutes.productsDetail,
      //     arguments: ProductModel.empty()),

      // Sales
      SearchItem(title: 'Sales', route: TRoutes.sales),

      // Customers
      SearchItem(title: 'Customers', route: TRoutes.customer),
      // SearchItem(title: 'Customer Details', route: TRoutes.customerDetails, ),
      //    SearchItem(title: 'Add Customer', route: TRoutes.addCustomer,arguments: CustomerModel.empty()),

      // Salesmen
      SearchItem(title: 'Salesmen', route: TRoutes.salesman),
      //   SearchItem(title: 'Salesman Details', route: TRoutes.salesmanDetails),
      //  SearchItem(title: 'Add Salesman', route: TRoutes.addSalesman),

      // Installments
      //  SearchItem(title: 'Installments', route: TRoutes.installment),

      // Brands
      SearchItem(title: 'Brands', route: TRoutes.brand),
      // SearchItem(title: 'Add Brand', route: TRoutes.brandDetails, arguments: BrandModel.empty()),

      // Categories
      SearchItem(title: 'Categories', route: TRoutes.category),
      // SearchItem(title: 'Add Category', route: TRoutes.categoryDetails, arguments: CategoryModel.empty()),

      // Other
      SearchItem(title: 'Profile', route: TRoutes.profileScreen),
      SearchItem(title: 'Store', route: TRoutes.storeScreen),
      SearchItem(title: 'Media', route: TRoutes.mediaScreen),
      SearchItem(title: 'Reports', route: TRoutes.reportScreen),
      SearchItem(title: 'Expenses', route: TRoutes.expenseScreen),
    ];

    // Initialize filtered items with all items
    filteredItems.value = [...allSearchItems];
  }

  // Filter search results based on query
  void filterSearchResults(String query) {
    if (query.isEmpty) {
      filteredItems.value = [...allSearchItems];
      return;
    }

    final lowercaseQuery = query.toLowerCase().trim();
    filteredItems.value = allSearchItems
        .where((item) => item.title.toLowerCase().contains(lowercaseQuery))
        .toList();

    // Ensure UI is updated
    filteredItems.refresh();
  }

  // Navigate to the selected item's route
  void navigateToRoute(SearchItem item) {
    // Hide search overlay
    isSearchOverlayVisible.value = false;

    // Clear search field
    searchController.clear();

    // Navigate to the selected route with optional arguments
    if (item.arguments != null) {
      Get.toNamed(item.route, arguments: item.arguments);
    } else {
      Get.toNamed(item.route);
    }
  }

  // Toggle search overlay visibility
  void toggleSearchOverlay() {
    isSearchOverlayVisible.value = !isSearchOverlayVisible.value;

    // If closing, clear the search
    if (!isSearchOverlayVisible.value) {
      searchController.clear();
    }
  }

  // Clear search
  void clearSearch() {
    searchController.clear();
  }

  @override
  void onClose() {
    searchController.dispose();
    _instance = null; // Clear the singleton instance
    super.onClose();
  }
}
