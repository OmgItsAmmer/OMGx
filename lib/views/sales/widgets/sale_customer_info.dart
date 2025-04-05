import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/images/t_rounded_image.dart';
import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../common/widgets/dropdown_search/drop_down_searchbar.dart';
import '../../../common/widgets/dropdown_search/dropdown_search.dart';
import '../../../common/widgets/dropdown_search/searchable_text_field.dart';
import '../../../common/widgets/shimmers/shimmer.dart';
import '../../../controllers/media/media_controller.dart';
import '../../../controllers/product/product_images_controller.dart';
import '../../../controllers/sales/sales_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/validators/validation.dart';

class SaleCustomerInfo extends StatelessWidget {
  final String hintText;

  final namesList;
  final addressList;
  final onSelectedName;
  final onSelectedAddress;
  final userNameTextController;
  final addressTextController;


  const SaleCustomerInfo(
      {super.key,
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
    final ProductImagesController productImagesController =
        Get.find<ProductImagesController>();
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
            Text(
              'Customer Information',
              style: Theme.of(context).textTheme.headlineMedium,
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
                      Stack(
                        alignment: Alignment
                            .bottomRight, // Align the camera icon to the bottom right
                        children: [
                          // Rounded Image
                          Obx(
                            () {
                              if (salesController.entityId.value == -1) {
                                return const SizedBox(
                                  height: 120,
                                  width: 100,
                                  child: Icon(Iconsax
                                      .image), // Placeholder icon when no image is selected
                                );
                              }
                              // Check if selectedImages is empty
                              return FutureBuilder<String?>(
                                future: mediaController.fetchMainImage(
                                salesController.entityId.value ,
                                MediaCategory.customers.toString().split('.').last
                              ),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const TShimmerEffect(
                                        width: 350,
                                        height:
                                            170); // Show shimmer while loading
                                  } else if (snapshot.hasError) {
                                    return const Text(
                                        'Error loading image'); // Handle error case
                                  } else if (snapshot.hasData &&
                                      snapshot.data != null) {
                                    return TRoundedImage(
                                      isNetworkImage: true,
                                      width: 150,
                                      height: 150,
                                      imageurl: snapshot.data!,
                                    );
                                  } else {
                                    return const Text(
                                        'No image available'); // Handle case where no image is available
                                  }
                                },
                              );
                            },
                          ),

                          // Camera Icon
                          Positioned(
                            right: 0, // Adjust the position of the icon
                            bottom: 0, // Adjust the position of the icon
                            child: GestureDetector(
                              onTap: () {
                                productImagesController
                                    .selectThumbnailImage(); // Trigger image selection
                              },
                              child: const TRoundedContainer(
                                borderColor: TColors.white,
                                backgroundColor: TColors.primary,
                                padding: EdgeInsets.all(
                                    6), // Add padding around the icon
                                child: Icon(
                                  Iconsax.camera, // Camera icon
                                  size: 25, // Icon size
                                  color: Colors.white, // Icon color
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),
                      const SizedBox(
                        height: TSizes.spaceBtwItems,
                      ),
                      SizedBox(
                        width: 300,
                        //  height: 60,
                        child: AutoCompleteTextField(
                          titleText: hintText,
                          optionList: namesList,
                          textController: userNameTextController,
                          parameterFunc: onSelectedName,
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

                          child: AutoCompleteTextField(
                              titleText: 'Address',
                              optionList: addressList,

                              // key: salesController.searchDropDownKey,

                              textController: addressTextController,
                              parameterFunc: onSelectedAddress),
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
