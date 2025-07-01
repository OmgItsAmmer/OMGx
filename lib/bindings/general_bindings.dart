import 'package:admin_dashboard_v3/controllers/account_book/account_book_controller.dart';
import 'package:admin_dashboard_v3/controllers/address/address_controller.dart';
import 'package:admin_dashboard_v3/controllers/brands/brand_controller.dart';
import 'package:admin_dashboard_v3/controllers/dashboard/dashboard_controoler.dart';
import 'package:admin_dashboard_v3/controllers/expenses/expense_controller.dart';
import 'package:admin_dashboard_v3/controllers/installments/installments_controller.dart';
import 'package:admin_dashboard_v3/controllers/notification/notification_controller.dart';
import 'package:admin_dashboard_v3/controllers/product/product_controller.dart';
import 'package:admin_dashboard_v3/controllers/sales/sales_controller.dart';
import 'package:admin_dashboard_v3/controllers/salesman/salesman_controller.dart';
import 'package:admin_dashboard_v3/controllers/search/search_controller.dart';
import 'package:admin_dashboard_v3/controllers/shop/shop_controller.dart';
import 'package:admin_dashboard_v3/controllers/user/user_controller.dart';
import 'package:admin_dashboard_v3/controllers/vendor/vendor_controller.dart';
import 'package:admin_dashboard_v3/utils/network/supabase_network_manager.dart';
import 'package:get/get.dart';

import '../controllers/category/category_controller.dart';
import '../controllers/customer/customer_controller.dart';
import '../controllers/guarantors/guarantor_image_controller.dart';
import '../controllers/media/media_controller.dart';
import '../controllers/orders/orders_controller.dart';
import '../network_manager.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(SupabaseNetworkManager.instance);

    // Register controllers
    Get.put(UserController());
     Get.put(ProductController());
    Get.put(OrderController());
    Get.put(CustomerController());
    Get.put(VendorController());
    Get.put(SalesController());
    Get.put(InstallmentController());
    Get.put(ExpenseController());
    Get.put(DashboardController());
    Get.put(AccountBookController());

    Get.put(AddressController());
    Get.put(SalesmanController());
    Get.put(BrandController());
    Get.put(CategoryController());
    // Get.put(ProductImagesController());
    Get.put(MediaController());
    Get.put(NotificationController());
    Get.put(ShopController());
    Get.put(GuarantorImageController());

    // Initialize the search controller using the singleton pattern
    TSearchController.instance;

    //Get.put(AuthenticationRepository());

    // final UserRespository userRespository = Get.find<UserRespository>();
  }
}
