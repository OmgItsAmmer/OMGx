import 'package:ecommerce_dashboard/controllers/brands/brand_controller.dart';
import 'package:ecommerce_dashboard/controllers/category/category_controller.dart';
import 'package:ecommerce_dashboard/controllers/customer/customer_controller.dart';
import 'package:ecommerce_dashboard/controllers/installments/installments_controller.dart';
import 'package:ecommerce_dashboard/controllers/media/media_controller.dart';
import 'package:ecommerce_dashboard/controllers/orders/orders_controller.dart';
import 'package:ecommerce_dashboard/controllers/product/product_controller.dart';
import 'package:ecommerce_dashboard/controllers/sales/sales_controller.dart';
import 'package:ecommerce_dashboard/controllers/salesman/salesman_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../utils/constants/enums.dart';

class TRouteMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // final ProductImagesController productImagesController =
    //   Get.find<ProductImagesController>();
    final MediaController mediaController = Get.find<MediaController>();

    mediaController.displayImage.value = null;
    for (var image in mediaController.allImages) {
      image.isSelected.value = false; // ✅ Reset checkbox state
    }
    mediaController.selectedImages.clear();
    mediaController.allImages.clear();

    mediaController.selectedPath.value = MediaCategory.folders;

    // Run function when navigating to ProfileScreen
    if (route != null) {
      // CategoryController.instance.cleanCategoryDetail();
      // ProductController.instance.cleanProductDetail();
      // BrandController.instance.cleanBrandDetail();
      // CustomerController.instance.cleanCustomerDetails();
      // SalesmanController.instance.cleanSalesmanDetails();
      // OrderController.instance.resetCustomerOrders();
      // SalesController.instance.resetFields();
      // InstallmentController.instance.resetFormFields();
    }

    return null;
  }
}
