import 'package:ecommerce_dashboard/controllers/media/media_controller.dart';
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
