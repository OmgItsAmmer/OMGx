

import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../main.dart';

import '../../Models/orders/order_item_model.dart';
import '../../Models/salesman/salesman_model.dart';

class OrderRepository extends GetxController {
  static OrderRepository get instance => Get.find();


      Future<int> uploadOrder(OrderModel order) async {
        try {
          // Insert the order into the 'orders' table
          final response = await Supabase.instance.client
              .from('orders')
              .insert({
            'order_date': order.orderDate,
            'total_price': order.totalPrice,
            'status': order.status,
            'saletype': order.saletype,
            'address_id': order.addressId,
            'user_id': order.userId,
            'salesman_id': order.salesmanId,
            'paid_amount': order.paidAmount,
            'customer_id': order.customerId,
          })
              .select();

          final orderId = response[0]['order_id'];



          // Insert the order items into the 'order_items' table
          await Supabase.instance.client
              .from('order_items')
              .insert(order.orderItems!.map((item) {
            return {
              'order_id': orderId, // Assign the order_id to the order items
              'variant_id': item.variantId,
              'quantity': item.quantity,
              'price': item.price,
              'unit': item.unit,
            };
          }).toList());



          TLoader.successSnackBar(title: 'Success', message: 'Order successfully checked out.');
          return orderId;

        } catch (e) {
          // Show error if any
          TLoader.errorsnackBar(title: 'Update Order Error', message: e.toString());
          print(e);
          return -1;
        }
      }

  Future<List<OrderModel>> fetchOrders() async
  {

    try{
      final data =  await supabase.from('orders').select();
      //print(data);

      final orderList = data.map((item) {
        return OrderModel.fromJson(item);
      }).toList();
      if (kDebugMode) {
        print(orderList[1].orderId);
      }
      return orderList;

    }
    catch(e)
    {
      TLoader.errorsnackBar(title: 'Order Fetch',message: e.toString());
      print(e.toString());
      return [];
    }

  }

  Future<List<OrderItemModel>> fetchOrderItems(int orderId) async {
    try {
      final data = await supabase
          .from('order_items')
          .select('*, product_variants(variant_id, variant_image, variant_name)') // Joining with product_variant
          .eq('order_id', orderId);

      if (kDebugMode) {
        print(data);
      }

      final orderItemList = data.map((item) {
        return OrderItemModel.fromJson(item);
      }).toList();

      return orderItemList;
    } catch (e) {
      TLoader.errorsnackBar(title: 'Order Item Fetch', message: e.toString());
      print(e.toString());
      return [];
    }
  }




}