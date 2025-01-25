import 'dart:ffi';

import 'package:admin_dashboard_v3/Models/products/product_model.dart';
import 'package:admin_dashboard_v3/Models/sales/sale_model.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/repositories/products/product_repository.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../common/widgets/dropdown_search/drop_down_searchbar.dart';

class SalesController extends GetxController {
  static SalesController get instance => Get.find();

  RxList<SaleModel> allSales = <SaleModel>[].obs;

  // Loading state for fetching products
  final isLoading = false.obs;

  //Variables
  Rx<String> selectedProductName = ''.obs;
  Rx<UnitType> selectedUnit = UnitType.Unit.obs;
  Rx<int> selectedProductId = (-1).obs;
  RxDouble netTotal = (0.0).obs;
  Rx<String> discount = ''.obs;


  //TextForm Controllers
  final unitPrice = TextEditingController().obs;
  final unit = TextEditingController();
  final quantity = TextEditingController();
  final totalPrice = TextEditingController().obs;
  final discountController = TextEditingController(); // to reset field to zero
  final dropdownController = TextEditingController(); // to reset field to zero

  //Customer Info fields
  final customerNameController = TextEditingController();
  final customerPhoneNoController = TextEditingController().obs;
  final customerAddressController = TextEditingController().obs;
  final customerCNICController = TextEditingController().obs;


  GlobalKey<FormState> addUnitPriceAndQuantityKey =
      GlobalKey<FormState>(); // Form key for form validation
  GlobalKey<FormState> addUnitTotalKey =
  GlobalKey<FormState>(); // Form key for form validation



  // Reactive variable to track expansion state
  var isExpanded = true.obs;





  @override
  void onInit() {
    super.onInit();
  }

  void addProduct() {
   try{
     if ((!addUnitTotalKey.currentState!.validate() && !addUnitPriceAndQuantityKey.currentState!.validate()) ||
         selectedProductId == -1    ) {
       TLoader.errorsnackBar(title: "Empty",message: 'Kindly fill all the Text fields before proceed');
       return;
     }

     final sale = SaleModel(
         productId: selectedProductId.value,
         name: dropdownController.text.trim(),
         salePrice: unitPrice.value.text.trim(),
         unit: selectedUnit.toString().trim(),
         quantity: quantity.text,
         totalPrice: totalPrice.value.text);
     //Adding in netTotal
     netTotal.value += double.parse(totalPrice.value.text);

     allSales.add(sale);
     dropdownController.clear();
     unitPrice.value.clear();
     unit.clear();
     quantity.clear();
     totalPrice.value.clear();
     //searchDropDownKey.currentState?.resetToHint();
     TLoader.successSnackBar(title: 'Added');

   }
   catch(e)
    {
      TLoader.errorsnackBar(title: 'Adding Data',message: e.toString());
    }
  }




  // Toggle the expansion state in sale desktop
  void toggleExpanded() {
    isExpanded.value = !isExpanded.value;
  }
}
