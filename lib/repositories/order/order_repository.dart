

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
      // if (kDebugMode) {
      //   print(addressList[1].country);
      // }
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


  Future<int> uploadOrder(Map<String, dynamic> json) async {
    try {
      // ✅ Parse orderItems from JSON
      List<OrderItemModel> orderItems = json['order_items'] != null
          ? OrderItemModel.fromJsonList(json['order_items'] as List)
          : [];

      // ✅ Insert the order into the 'orders' table
      final response = await Supabase.instance.client
          .from('orders')
          .insert(json)
          .select();

      final orderId = response[0]['order_id'];

      // ✅ Insert the order items using `toJson()`
      if (orderItems.isNotEmpty) {
        await Supabase.instance.client.from('order_items').insert(
          orderItems.map((item) {
            var itemJson = item.toJson();
            itemJson['order_id'] = orderId; // Assign the order_id
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
      if (kDebugMode) {
        print(orderList[1].orderId);
      }
      return orderList;
    }
    catch (e) {
      TLoader.errorSnackBar(title: 'Order Fetch', message: e.toString());
      print(e.toString());
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
}