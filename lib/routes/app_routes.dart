import 'package:admin_dashboard_v3/routes/routes.dart';
import 'package:admin_dashboard_v3/routes/routes_MIDDLEWARE.dart';
import 'package:admin_dashboard_v3/views/brands/all_brands/brands.dart';
import 'package:admin_dashboard_v3/views/category/all_categories/category.dart';
import 'package:admin_dashboard_v3/views/expenses/expenses.dart';
import 'package:admin_dashboard_v3/views/login/login.dart';
import 'package:admin_dashboard_v3/views/orders/all_orders/orders.dart';
import 'package:get/get.dart';

import '../views/brands/brand_details/brand_detail_screen.dart';
import '../views/category/categories_detail/category_detail.dart';
import '../views/customer/add_customer/add_customer.dart';
import '../views/customer/add_customer/resposive_screens/add_customer_desktop.dart';
import '../views/customer/all_customer/customer.dart';
import '../views/customer/customer_detail/customer_detail.dart';
import '../views/dashboard/dashboard.dart';
import '../views/installments/installments.dart';
import '../views/media/media_screen.dart';
import '../views/notifications/notifcaation_desktop.dart';
import '../views/orders/order_details/order_detail.dart';
import '../views/products/all_products/all_products.dart';
import '../views/products/product_detail/product_detail.dart';
import '../views/profile/profile/profile_screen.dart';
import '../views/reports/all_reports/all_reports.dart';
import '../views/sales/sales.dart';
import '../views/salesman/add_salesman/add_salesman.dart';
import '../views/salesman/all_salesman/salesman.dart';
import '../views/salesman/salesman_detail/responsive_screens/salesman_detail_desktop.dart';
import '../views/salesman/salesman_detail/saleman_details.dart';
import '../views/splashScreen/splash_screen.dart';
import '../views/store/store.dart';

class TAppRoutes {
  static final List<GetPage> pages = [

    GetPage(name: TRoutes.login, page: () => const LoginScreen(),middlewares: [TRouteMiddleware()] ),
    // GetPage(name: TRoutes.responsiveScreenDesignScreen, page: () => const ResponsiveDesignScreen(),middlewares: [TRouteMiddleeare()] ),
    GetPage(name: TRoutes.orders, page: () => const TOrderScreen(),middlewares: [TRouteMiddleware()] ),
    GetPage(name: TRoutes.orderDetails, page: () => const OrderDetailScreen(),middlewares: [TRouteMiddleware()] ),


    //Product Screens
    GetPage(name: TRoutes.products, page: () => const AllProducts(),middlewares: [TRouteMiddleware()] ),
    GetPage(name: TRoutes.productsDetail, page: () => const ProductDetailScreen(),middlewares: [TRouteMiddleware()] ),

    //Sale Screens
    GetPage(name: TRoutes.sales, page: () => const Sales(),middlewares: [TRouteMiddleware()] ),


    //Customer Screens
    GetPage(name: TRoutes.customer, page: () => const CustomerScreen(),middlewares: [TRouteMiddleware()] ),
    GetPage(name: TRoutes.customerDetails, page: () => const CustomerDetailScreen(),middlewares: [TRouteMiddleware()] ),
    GetPage(name: TRoutes.addCustomer, page: () => const AddCustomerScreen(),middlewares: [TRouteMiddleware()] ),
    //Salesman Screens
    GetPage(name: TRoutes.salesman, page: () => const SalesmanScreen(),middlewares: [TRouteMiddleware()] ),
    GetPage(name: TRoutes.salesmanDetails, page: () => const SalesmanDetailScreen(),middlewares: [TRouteMiddleware()] ),
    GetPage(name: TRoutes.addSalesman, page: () => const AddSalesmanScreen(),middlewares: [TRouteMiddleware()] ),


    //installment Screens
    GetPage(name: TRoutes.installment, page: () => const InstallmentsScreen(),middlewares: [TRouteMiddleware()] ),


    //Brand Screens
    GetPage(name: TRoutes.brand, page: () => const AllBrands(),middlewares: [TRouteMiddleware()] ),
    GetPage(name: TRoutes.brandDetails, page: () => const BrandDetailScreen(),middlewares: [TRouteMiddleware()] ),

    //Brand Screens
    GetPage(name: TRoutes.category, page: () => const AllCategoryScreen(),middlewares: [TRouteMiddleware()] ),
    GetPage(name: TRoutes.categoryDetails, page: () => const CategoryDetailScreen(),middlewares: [TRouteMiddleware()] ),


    //Profile
    GetPage(name: TRoutes.profileScreen, page: () => const ProfileScreen(),middlewares: [TRouteMiddleware()]),
   //Store
    GetPage(name: TRoutes.storeScreen, page: () => const StoreScreen(),middlewares: [TRouteMiddleware()] ),

    //Media Screens
    GetPage(name: TRoutes.mediaScreen, page: () => const MediaScreen(),middlewares: [TRouteMiddleware()] ),

    //Report Screens
    GetPage(name: TRoutes.reportScreen, page: () => const ReportScreen(),middlewares: [TRouteMiddleware()] ),



    GetPage(name: TRoutes.dashboard, page: () => const DashboardScreen(),middlewares: [TRouteMiddleware()] ),



    GetPage(name: TRoutes.splashScreen, page: () => const SplashScreen(),middlewares: [TRouteMiddleware()] ),


    GetPage(name: TRoutes.expenseScreen, page: () => const ExpenseScreen(),middlewares: [TRouteMiddleware()] ),







  ];
}
