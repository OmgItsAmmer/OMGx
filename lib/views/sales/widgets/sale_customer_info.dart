import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/images/t_rounded_image.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../common/widgets/dropdown_search/searchable_text_field.dart';
import '../../../common/widgets/icons/t_circular_icon.dart';
import '../../../common/widgets/shimmers/shimmer.dart';
import '../../../controllers/media/media_controller.dart';
import '../../../controllers/sales/sales_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/validators/validation.dart';
import '../../../common/widgets/dropdown_search/enhanced_autocomplete.dart';

class SaleCustomerInfo extends StatelessWidget {
  final String hintText;

  final namesList;
  final addressList;
  final onSelectedName;
  final onSelectedAddress;
  final userNameTextController;
  final addressTextController;

  const SaleCustomerInfo({
    super.key,
    required this.hintText,
    required this.namesList,
    required this.onSelectedName,
    required this.userNameTextController,
    required this.onSelectedAddress,
    required this.addressList,
    required this.addressTextController,
  });

  @override
  Widget build(BuildContext context) {
    final SalesController salesController = Get.find<SalesController>();
    // final ProductImagesController productImagesController =
    //     Get.find<ProductImagesController>();
    final MediaController mediaController = Get.find<MediaController>();

    return Form(
      key: salesController.customerFormKey,
      child: TRoundedContainer(
        backgroundColor: TColors.primaryBackground,

        //  height: 500,
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Customer Information',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                TCircularIcon(
                  icon: Iconsax.refresh,
                  backgroundColor: TColors.primary.withOpacity(0.1),
                  color: TColors.primary,
                  onPressed: () {
                    // Reset all customer fields - more robust approach
                    // Clear external controllers first
                    userNameTextController.text = '';
                    addressTextController.text = '';
                    salesController.customerPhoneNoController.value.clear();
                    salesController.customerCNICController.value.clear();
                    salesController.selectedAddressId = null;
                    salesController.entityId.value = -1;
                    mediaController.displayImage.value = null;

                    // Force update text selection which triggers the controller listener
                    userNameTextController.selection =
                        TextSelection.fromPosition(
                            const TextPosition(offset: 0));
                    addressTextController.selection =
                        TextSelection.fromPosition(
                            const TextPosition(offset: 0));

                    // Trigger callbacks
                    if (onSelectedName != null) onSelectedName('');
                    if (onSelectedAddress != null) onSelectedAddress('');

                    // Set a very short delay to ensure UI updates
                    Future.microtask(() {
                      if (salesController.customerFormKey.currentState !=
                          null) {
                        salesController.update();
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),

            Row(
              //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(() {
                        final id = salesController.entityId
                            .value; // 👈 This makes Obx react to changes
                        final image = mediaController.displayImage.value;

                        if (image != null) {
                          return FutureBuilder<String?>(
                            future: mediaController.getImageFromBucket(
                              MediaCategory.customers
                                  .toString()
                                  .split('.')
                                  .last,
                              image.filename ?? '',
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const TShimmerEffect(
                                    width: 120, height: 120);
                              } else if (snapshot.hasError ||
                                  snapshot.data == null) {
                                return const Icon(Icons.error);
                              } else {
                                return TRoundedImage(
                                  isNetworkImage: true,
                                  width: 120,
                                  height: 120,
                                  imageurl: snapshot.data!,
                                );
                              }
                            },
                          );
                        }

                        // 👇 Uses entityId directly to reactively fetch new image
                        return FutureBuilder<String?>(
                          future: mediaController.fetchMainImage(
                            id,
                            MediaCategory.customers.toString().split('.').last,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const TShimmerEffect(
                                  width: 120, height: 120);
                            } else if (snapshot.hasError ||
                                snapshot.data == null) {
                              return const TCircularIcon(
                                icon: Iconsax.image,
                                width: 120,
                                height: 120,
                                backgroundColor: TColors.primaryBackground,
                              );
                            } else {
                              return TRoundedImage(
                                isNetworkImage: true,
                                width: 120,
                                height: 120,
                                imageurl: snapshot.data!,
                              );
                            }
                          },
                        );
                      }),
                      const SizedBox(height: TSizes.spaceBtwSections),
                      const SizedBox(
                        height: TSizes.spaceBtwItems,
                      ),
                      SizedBox(
                        width: 300,
                        child: EnhancedAutocomplete<String>(
                          labelText: hintText,
                          hintText: 'Select a customer',
                          options: namesList,
                          externalController: userNameTextController,
                          displayStringForOption: (String option) => option,
                          onSelected: onSelectedName,
                          validator: (value) =>
                              TValidator.validateEmptyText(hintText, value),
                        ),
                      ),
                      // const SizedBox(
                      //   height: TSizes.spaceBtwItems,
                      // ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: TSizes.spaceBtwSections,
                ),
                Expanded(
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          // height: 80,
                          child: TextFormField(
                            controller:
                                salesController.customerPhoneNoController.value,
                            validator: (value) => TValidator.validateEmptyText(
                                'Phone Number', value),
                            keyboardType: TextInputType
                                .number, // Ensure numeric keyboard is shown
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ], // Allow only digits
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration: const InputDecoration(
                                labelText: 'Phone Number'),
                          ),
                        ),
                        const SizedBox(
                          height: TSizes.spaceBtwInputFields / 2,
                        ),
                        SizedBox(
                          width: double.infinity,
                          // height: 80,

                          child: EnhancedAutocomplete<String>(
                            labelText: 'Address',
                            hintText: 'Enter address',
                            options: addressList,
                            externalController: addressTextController,
                            displayStringForOption: (String option) => option,
                            onSelected: onSelectedAddress,
                            showOptionsOnFocus: true,
                          ),
                        ),
                        const SizedBox(
                          height: TSizes.spaceBtwInputFields / 2,
                        ),
                        SizedBox(
                          width: double.infinity,
                          //     height: 80,
                          child: TextFormField(
                            controller:
                                salesController.customerCNICController.value,
                            validator: (value) =>
                                TValidator.validateEmptyText('CNIC', value),
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration:
                                const InputDecoration(labelText: 'CNIC'),
                            keyboardType: TextInputType
                                .number, // Ensure numeric keyboard is shown
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),
            // DropdownDatePicker(
            //   dateformatorder: OrderFormat.DMY, // default is myd
            //   inputDecoration: InputDecoration(
            //       enabledBorder: const OutlineInputBorder(
            //         borderSide: BorderSide(color: Colors.grey, width: 1.0),
            //       ),
            //       border: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(10))), // optional
            //   isDropdownHideUnderline: true, // optional
            //   isFormValidator: true, // optional
            //   startYear: 2000, // optional
            //   endYear: 2030, // optional
            //   width: 5, // optional
            //   selectedDay: DateTime.now().day, // optional
            //   selectedMonth: DateTime.now().month, // optional
            //   selectedYear: DateTime.now().year, // optional
            //   onChangedDay: (value) => print('onChangedDay: $value'),
            //   onChangedMonth: (value) => print('onChangedMonth: $value'),
            //   onChangedYear: (value) => print('onChangedYear: $value'),
            //   // menuHeight: 10,
            //   yearFlex: 1,
            //   dayFlex: 1,
            //   monthFlex: 1,
            //   //boxDecoration: BoxDecoration(
            //   // border: Border.all(color: Colors.grey, width: 1.0)), // optional
            //   // showDay: false,// optional
            //   // dayFlex: 2,// optional
            //   // locale: "zh_CN",// optional
            //   //  hintDay: 'Day', // optional
            //   // hintMonth: 'Month', // optional
            //   // hintYear: 'Year', // optional
            //   // hintTextStyle: TextStyle(color: Colors.black), // optional
            // ),
          ],
        ),
      ),
    );
  }
}
