import 'package:ecommerce_dashboard/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:ecommerce_dashboard/controllers/customer/customer_controller.dart';
import 'package:ecommerce_dashboard/controllers/orders/orders_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:ecommerce_dashboard/utils/helpers/helper_functions.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../Models/orders/order_item_model.dart';
import '../../../../common/widgets/containers/rounded_container.dart';

import '../../../../utils/constants/enums.dart';

class OrderRows extends DataTableSource {
  OrderRows({
    required this.searchTerm,
  });

  final String searchTerm;
  final OrderController orderController = Get.find<OrderController>();
  final CustomerController customerController = Get.find<CustomerController>();

  List<OrderModel> _filteredOrders = [];
  int _currentlyLoadedCount = 20;
  bool _isLoading = false;

  // Get customer name by ID
  String getCustomerName(int? customerId) {
    if (customerId == null) return 'Unknown';

    final customer = customerController.allCustomers
        .firstWhereOrNull((customer) => customer.customerId == customerId);

    return customer?.fullName ?? 'Unknown';
  }

  // Format date to dd/mm/yyyy
  String formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  // Initialize filtered orders on first access
  void _initializeFilteredOrders() {
    if (_filteredOrders.isEmpty) {
      var filtered = [...orderController.allOrders];

      if (searchTerm.isNotEmpty) {
        filtered = orderController.allOrders.where((order) {
          return order.orderId
                  .toString()
                  .toLowerCase()
                  .contains(searchTerm.toLowerCase()) ||
              order.orderDate
                  .toLowerCase()
                  .contains(searchTerm.toLowerCase()) ||
              order.status.toLowerCase().contains(searchTerm.toLowerCase()) ||
              order.subTotal
                  .toString()
                  .toLowerCase()
                  .contains(searchTerm.toLowerCase());
        }).toList();
      }

      // Apply sorting (descending order by ID)
      filtered.sort((a, b) {
        int orderIdComparison = b.orderId.compareTo(a.orderId);
        if (orderIdComparison == 0) {
          try {
            DateTime dateA = DateTime.parse(a.orderDate);
            DateTime dateB = DateTime.parse(b.orderDate);
            return dateB.compareTo(dateA);
          } catch (e) {
            return 0;
          }
        }
        return orderIdComparison;
      });

      _filteredOrders = filtered;
    }
  }

  // Load more data when needed
  void _loadMoreIfNeeded(int index) {
    if (index >= _currentlyLoadedCount - 5 &&
        _currentlyLoadedCount < _filteredOrders.length &&
        !_isLoading) {
      _isLoading = true;
      // Simulate loading delay
      Future.delayed(const Duration(milliseconds: 300), () {
        _currentlyLoadedCount =
            (_currentlyLoadedCount + 20).clamp(0, _filteredOrders.length);
        _isLoading = false;
        notifyListeners();
      });
    }
  }

  @override
  DataRow? getRow(int index) {
    _initializeFilteredOrders();

    // Check if we need to load more data
    _loadMoreIfNeeded(index);

    // Return null if we're beyond our currently loaded count and still loading
    if (index >= _currentlyLoadedCount) {
      return null;
    }

    // Check if index is within bounds
    if (index >= _filteredOrders.length) {
      return null;
    }

    final order = _filteredOrders[index];
    OrderStatus? orderStatus = OrderStatus.values.firstWhere(
      (e) => e.name == order.status,
      orElse: () => OrderStatus.pending,
    );

    return DataRow2(
        onTap: () async {
          orderController.setUpOrderDetails(order);
        },
        selected: false,
        onSelectChanged: (value) {},
        cells: [
          DataCell(
            Text(
              order.orderId.toString(),
              style: Theme.of(Get.context!)
                  .textTheme
                  .bodyLarge!
                  .apply(color: TColors.primary),
            ),
          ),
          DataCell(
            Text(
              formatDate(order.orderDate),
            ),
          ),
          DataCell(
            Text(
              getCustomerName(order.customerId),
              style: Theme.of(Get.context!)
                  .textTheme
                  .bodyLarge!
                  .apply(color: TColors.primary),
            ),
          ),
          DataCell(TRoundedContainer(
            radius: TSizes.cardRadiusSm,
            padding: const EdgeInsets.symmetric(
                vertical: TSizes.sm, horizontal: TSizes.md),
            backgroundColor: THelperFunctions.getOrderStatusColor(orderStatus)
                .withValues(alpha: 0.1),
            child: Text(
              order.status.toString(),
              style: TextStyle(
                  color: THelperFunctions.getOrderStatusColor(orderStatus)),
            ),
          )),
          DataCell(Text(order.subTotal.toString())),
          DataCell(TTableActionButtons(
            delete: false,
            view: true,
            edit: false,
            onViewPressed: () async {
              orderController.setUpOrderDetails(order);
            },
          ))
        ]);
  }

  @override
  bool get isRowCountApproximate =>
      _currentlyLoadedCount < _filteredOrders.length;

  @override
  int get rowCount {
    _initializeFilteredOrders();
    return _filteredOrders.length;
  }

  @override
  int get selectedRowCount => 0;

  // Get the currently loaded count for UI purposes
  int get currentlyLoadedCount => _currentlyLoadedCount;

  // Check if currently loading
  bool get isLoading => _isLoading;
}
