import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/images/t_rounded_image.dart';
import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../common/widgets/dropdown_search/drop_down_searchbar.dart';
import '../../../common/widgets/dropdown_search/dropdown_search.dart';
import '../../../common/widgets/dropdown_search/searchable_text_field.dart';
import '../../../controllers/sales/sales_controller.dart';
import '../../../utils/constants/colors.dart';
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
      required this.addressTextController});

  @override
  Widget build(BuildContext context) {
    final SalesController salesController = Get.find<SalesController>();

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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const TRoundedImage(
                          width: 100, height: 100, imageurl: TImages.user),
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
                      const SizedBox(
                        height: TSizes.spaceBtwItems,
                      ),
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
                            decoration:
                                const InputDecoration(labelText: 'Phone Number'),
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
                            decoration: const InputDecoration(labelText: 'CNIC'),
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
