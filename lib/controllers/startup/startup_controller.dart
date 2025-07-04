// import 'package:ecommerce_dashboard/Models/user/user_model.dart';
// import 'package:ecommerce_dashboard/controllers/sales/sales_controller.dart';
// import 'package:ecommerce_dashboard/controllers/user/user_controller.dart';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
//
//
// import '../../common/widgets/loaders/tloaders.dart';
//
// class StartUpController extends GetxController {
//   static StartUpController get instance => Get.find();
// // final UserRespository userRespository = Get.put(UserRespository());
//   //final UserController userController = Get.find<UserController>();
//   final SalesController salesController =  Get.put(SalesController());
//   //
//
//
//
//   void setupUserDetails(UserModel currentUser) {
//     try{
//       print(currentUser.firstName);
//      salesController.cashierNameController.value.text = currentUser.firstName;
//       print(salesController.cashierNameController.value.text);
//
//     }
//     catch(e){
//       if(kDebugMode)
//         {
//           TLoader.errorSnackBar(title: e.toString());
//           print(e);
//
//         }
//     }
//
//
// }
//
//
//
//
//
// }
//
//
