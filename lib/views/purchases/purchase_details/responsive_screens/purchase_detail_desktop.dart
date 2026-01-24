import 'package:ecommerce_dashboard/controllers/purchase/purchase_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:ecommerce_dashboard/views/purchases/purchase_details/widgets/vendor_info.dart';
import 'package:ecommerce_dashboard/views/purchases/purchase_details/widgets/purchase_transaction.dart';
import 'package:ecommerce_dashboard/views/purchases/purchase_details/widgets/purchase_info.dart';
import 'package:ecommerce_dashboard/views/purchases/purchase_details/widgets/purchase_items.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Models/purchase/purchase_model.dart';
import '../../../../controllers/vendor/vendor_controller.dart';
import '../../../../utils/constants/enums.dart';

class PurchaseDetailDesktopScreen extends StatefulWidget {
  const PurchaseDetailDesktopScreen({super.key, required this.purchaseModel});

  final PurchaseModel purchaseModel;

  @override
  State<PurchaseDetailDesktopScreen> createState() =>
      _PurchaseDetailDesktopScreenState();
}

class _PurchaseDetailDesktopScreenState
    extends State<PurchaseDetailDesktopScreen> {
  late PurchaseModel _purchaseModel;
  bool _isLoadingItems = false;

  @override
  void initState() {
    super.initState();
    _purchaseModel = widget.purchaseModel;
    if (kDebugMode) {
      print('🖥️ [PurchaseDetailDesktop] initState called');
      print('   - Purchase ID: ${_purchaseModel.purchaseId}');
      print('   - Purchase items: ${_purchaseModel.purchaseItems}');
      print('   - Purchase items count: ${_purchaseModel.purchaseItems?.length ?? 0}');
      print('   - Purchase items is null: ${_purchaseModel.purchaseItems == null}');
      print('   - Purchase items is empty: ${_purchaseModel.purchaseItems?.isEmpty ?? true}');
    }
    _loadPurchaseItemsIfNeeded();
  }

  Future<void> _loadPurchaseItemsIfNeeded() async {
    // If purchase items are not loaded, fetch them
    if (_purchaseModel.purchaseItems == null ||
        _purchaseModel.purchaseItems!.isEmpty) {
      if (kDebugMode) {
        print('🔄 [PurchaseDetailDesktop] Loading purchase items...');
        print('   - Purchase items is null: ${_purchaseModel.purchaseItems == null}');
        print('   - Purchase items is empty: ${_purchaseModel.purchaseItems?.isEmpty ?? true}');
      }

      setState(() {
        _isLoadingItems = true;
      });

      final PurchaseController purchaseController =
          Get.find<PurchaseController>();
      try {
        if (kDebugMode) {
          print('📞 [PurchaseDetailDesktop] Calling fetchPurchaseItems for purchase_id: ${_purchaseModel.purchaseId}');
        }
        final items =
            await purchaseController.fetchPurchaseItems(_purchaseModel.purchaseId);
        
        if (kDebugMode) {
          print('📥 [PurchaseDetailDesktop] Received ${items.length} items from controller');
          print('   - Items: $items');
        }

        setState(() {
          _purchaseModel = _purchaseModel.copyWith(purchaseItems: items);
          _isLoadingItems = false;
        });

        if (kDebugMode) {
          print('✅ [PurchaseDetailDesktop] Updated purchase model with items');
          print('   - New purchase items count: ${_purchaseModel.purchaseItems?.length ?? 0}');
        }
      } catch (e, stackTrace) {
        if (kDebugMode) {
          print('❌ [PurchaseDetailDesktop] Error loading purchase items: $e');
          print('   Stack trace: $stackTrace');
        }
        setState(() {
          _isLoadingItems = false;
        });
      }
    } else {
      if (kDebugMode) {
        print('✅ [PurchaseDetailDesktop] Purchase items already loaded (${_purchaseModel.purchaseItems?.length ?? 0} items)');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final VendorController vendorController = Get.find<VendorController>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      PurchaseInfo(purchaseModel: _purchaseModel),
                      const SizedBox(height: TSizes.spaceBtwSections),
                      _isLoadingItems
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(TSizes.defaultSpace),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : PurchaseItems(purchase: _purchaseModel),
                      const SizedBox(height: TSizes.spaceBtwSections),
                      PurchaseTransaction(purchaseModel: _purchaseModel),
                      const SizedBox(height: TSizes.spaceBtwSections),
                    ],
                  ),
                ),
                const SizedBox(width: TSizes.spaceBtwSections),
                Expanded(
                  child: Column(
                    children: [
                      VendorInfo(
                        mediaCategory: MediaCategory.vendors,
                        title: 'Vendor',
                        showAddress: true,
                        fullName:
                            vendorController.selectedVendor.value.fullName,
                        email: vendorController.selectedVendor.value.email,
                        phoneNumber:
                            vendorController.selectedVendor.value.phoneNumber,
                        isLoading: vendorController.isLoading.value,
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
