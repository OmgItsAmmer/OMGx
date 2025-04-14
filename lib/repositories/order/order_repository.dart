

import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../main.dart';

import '../../Models/orders/order_item_model.dart';
import '../../Models/salesman/salesman_model.dart';

class OrderRepository extends GetxController {
  static OrderRepository get instance => Get.find();


  //fetch
  Future<List<OrderModel>> fetchCustomerOrders(int customerId) async {
    try {
      final data = await supabase
          .from('orders')
          .select().eq('customer_id', customerId);
     // print(data.length);

      final addressList = data.map((item) {
        return OrderModel.fromJson(item);
      }).toList();

      return addressList;
    } catch (e) {
      TLoader.warningSnackBar(
          title: "Fetch Customer Orders", message: e.toString());
      return [];
    }
  }

  Future<void> updateStatus(int orderId, String newStatus) async {
    try {
      await supabase
          .from('orders')
          .update({ 'status': newStatus})
          .eq('order_id', orderId);


      TLoader.successSnackBar(
          title: 'Status Updated', message: 'Status is Updated to$newStatus');
    } catch (e) {
      // Show error if any
      TLoader.errorSnackBar(title: 'Update Order Error', message: e.toString());
      if (kDebugMode) {
        print(e);
      }
    }
  }


  Future<int> uploadOrder(Map<String, dynamic> json, List<OrderItemModel> orderItems) async {
    try {


      // ✅ Insert the order into the 'orders' table
      final response = await Supabase.instance.client
          .from('orders')
          .insert(json)
          .select();

      final orderId = response[0]['order_id'];

      // ✅ Insert the order items using `toJson()`
      if (orderItems.isNotEmpty) {
        // Make sure to add the order_id to each item before inserting
        await Supabase.instance.client.from('order_items').insert(
          orderItems.map((item) {
            var itemJson = item.toJson();
            itemJson['order_id'] = orderId; // Assign the order_id here
            return itemJson;
          }).toList(),
        );
      }

      TLoader.successSnackBar(
          title: 'Success', message: 'Order successfully checked out.');
      return orderId;
    } catch (e) {
      // ❌ Handle errors
      if (kDebugMode) {
        TLoader.errorSnackBar(title: 'Update Order Error', message: e.toString());
        print(e);
      }
      return -1;
    }
  }




  Future<List<OrderModel>> fetchOrders() async
  {
    try {
      final data = await supabase.from('orders').select();
      //print(data);

      final orderList = data.map((item) {
        return OrderModel.fromJson(item);
      }).toList();

      return orderList;
    }
    catch (e) {
      if (kDebugMode) {
        TLoader.errorSnackBar(title: 'Order Fetch', message: e.toString());
        print(e.toString());
      }
      return [];
    }
  }

  Future<List<OrderItemModel>> fetchOrderItems(int orderId) async {
    try {
      final data = await supabase
          .from('order_items')
          .select(
          '*, products(product_id, name)') // Joining with product_variant
          .eq('order_id', orderId);

      if (kDebugMode) {
        print(data);
      }

      final orderItemList = data.map((item) {
        return OrderItemModel.fromJson(item);
      }).toList();

      return orderItemList;
    } catch (e) {
      TLoader.errorSnackBar(title: 'Order Item Fetch', message: e.toString());
      print(e.toString());
      return [];
    }
  }

  Future<List<int>> getOrderIdsByVariantId(int variantId) async {
    final response = await supabase
        .from('order_items')
        .select('order_id')
        .eq('variant_id', variantId);

    return response.map<int>((item) => item['order_id'] as int).toList();
  }

  Future<void> restoreQuantity(OrderItemModel item) async {
    try {
      // Step 1: Fetch the current stock quantity
      final response = await supabase
          .from('products')
          .select('stock_quantity')
          .eq('product_id', item.productId)
          .single(); // Ensures we get a single row

      // Directly access the stock quantity from the response
      final int currentStock = response['stock_quantity'] as int;
      final int newStock = currentStock + item.quantity;

      // Step 2: Update the stock quantity
      final updateResponse = await supabase
          .from('products')
          .update({'stock_quantity': newStock})
          .eq('product_id', item.productId);

      if (updateResponse.error != null) {
        TLoader.errorSnackBar(
            title: 'Restore Quantity Error', message: updateResponse.error!.message);
      } else {
        TLoader.successSnackBar(
            title: 'Success', message: 'Quantity restored successfully');
      }
    } catch (e) {
      TLoader.errorSnackBar(title: 'Restore Quantity Error', message: e.toString());
    }
  }
  Future<void> subtractQuantity(OrderItemModel item) async {
    try {
      // Step 1: Fetch the current stock quantity
      final response = await supabase
          .from('products')
          .select('stock_quantity')
          .eq('product_id', item.productId)
          .single(); // Ensures we get a single row

      // Directly access the stock quantity from the response
      final int currentStock = response['stock_quantity'] as int;
      final int newStock = currentStock - item.quantity; // Subtract quantity

      // Step 2: Update the stock quantity
      final updateResponse = await supabase
          .from('products')
          .update({'stock_quantity': newStock})
          .eq('product_id', item.productId);

      if (updateResponse.error != null) {
        TLoader.errorSnackBar(
            title: 'Subtract Quantity Error', message: updateResponse.error!.message);
      }
    } catch (e) {
      TLoader.errorSnackBar(title: 'Subtract Quantity Error', message: e.toString());
    }
  }

  Future<bool> updatePaidAmount(int orderId, double newAmount) async {
    try {
      // Fetch existing paid amount
      final response = await supabase
          .from('orders')
          .select('paid_amount')
          .eq('order_id', orderId)
          .single();

      double existingAmount = (response['paid_amount'] as num?)?.toDouble() ?? 0.0;
      double updatedAmount = existingAmount + newAmount;

      // Update order with new paid amount
      await supabase.from('orders').update({
        'paid_amount': updatedAmount,
      }).eq('order_id', orderId);

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating paid amount: $e');
        TLoader.errorSnackBar(title: 'Order Repo', message: e.toString());
      }
      return false;
    }
  }


}