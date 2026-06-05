import 'package:ecommerce_dashboard/controllers/media/media_controller.dart';
import 'package:ecommerce_dashboard/controllers/sales/sales_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../utils/constants/enums.dart';
import 'routes.dart';

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

    // Run function when navigating to any screen
    if (route != null) {
      // Clear sales data when navigating away from sales screen (except to installments)
      if (route != TRoutes.sales && route != TRoutes.installment) {
        try {
          final SalesController salesController = Get.find<SalesController>();
          salesController.clearSaleDetails();
        } catch (e) {
          // Controller might not be initialized yet, ignore error
        }
      }

      // Other controller cleanups (currently commented out)
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
