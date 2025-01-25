import 'package:admin_dashboard_v3/routes/routes.dart';
import 'package:admin_dashboard_v3/routes/routes_MIDDLEWARE.dart';
import 'package:admin_dashboard_v3/views/login/login.dart';
import 'package:admin_dashboard_v3/views/orders/all_orders/orders.dart';
import 'package:get/get.dart';

import '../repsonsive_screen.dart';
import '../views/customer/all_customer/customer.dart';
import '../views/customer/customer_detail/customer_detail.dart';
import '../views/installments/installments.dart';
import '../views/orders/order_details/order_detail.dart';
import '../views/products/all_products/all_products.dart';
import '../views/products/product_detail/product_detail.dart';
import '../views/sales/sales.dart';
import '../views/sales/widgets/cashier_info.dart';
import '../views/salesman/all_salesman/salesman.dart';

class TAppRoutes {
  static final List<GetPage> pages = [

    GetPage(name: TRoutes.login, page: () => const LoginScreen(),middlewares: [TRouteMiddleeare()] ),
    GetPage(name: TRoutes.responsiveScreenDesignScreen, page: () => const ResponsiveDesignScreen(),middlewares: [TRouteMiddleeare()] ),
    GetPage(name: TRoutes.orders, page: () => const TOrderScreen(),middlewares: [TRouteMiddleeare()] ),
    GetPage(name: TRoutes.orderDetails, page: () => const OrderDetailScreen(),middlewares: [TRouteMiddleeare()] ),


    //Product Screens
    GetPage(name: TRoutes.products, page: () => const AllProducts(),middlewares: [TRouteMiddleeare()] ),
    GetPage(name: TRoutes.productsDetail, page: () => const ProductDetailScreen(),middlewares: [TRouteMiddleeare()] ),

    //Sale Screens
    GetPage(name: TRoutes.sales, page: () => const Sales(),middlewares: [TRouteMiddleeare()] ),


    //Customer Screebs
    GetPage(name: TRoutes.customer, page: () => const CustomerScreen(),middlewares: [TRouteMiddleeare()] ),
    GetPage(name: TRoutes.customerDetails, page: () => const CustomerDetailScreen(),middlewares: [TRouteMiddleeare()] ),
    //Salesman Screebs
    GetPage(name: TRoutes.salesman, page: () => const SalesmanScreen(),middlewares: [TRouteMiddleeare()] ),
    GetPage(name: TRoutes.salesmanDetails, page: () => const CustomerDetailScreen(),middlewares: [TRouteMiddleeare()] ),


    //installment Screebs
    GetPage(name: TRoutes.installment, page: () => const InstallmentsScreen(),middlewares: [TRouteMiddleeare()] ),



  ];
}
