import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/images/t_rounded_image.dart';
import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:datepicker_dropdown/order_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/dropdown_search/drop_down_searchbar.dart';
import '../../../utils/constants/enums.dart';

class SaleCustomerInfo extends StatelessWidget {
  const SaleCustomerInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
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

            children: [
              const Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [


                    TRoundedImage(
                        width: 100, height: 100, imageurl: TImages.user),
                    SizedBox(
                      height: TSizes.spaceBtwItems,
                    ),
                    // OSearchDropDown(
                    //   suggestions: ['Ammer','Muhid'],
                    //   onSelected: (value){},
                    //
                    // ),


                    SizedBox(
                      height: TSizes.spaceBtwItems,
                    ),


                  ],
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwSections,),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 300,
                      // height: 80,
                      child: TextFormField(
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: const InputDecoration(labelText: 'Phone Number'),
                      ),
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwInputFields/2,
                    ),
                    SizedBox(
                      width: 300,
                      // height: 80,

                      child: TextFormField(
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: const InputDecoration(labelText: 'Address'),
                        maxLines: 3,
                      ),
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwInputFields/2,
                    ),
                    SizedBox(
                      width: 300,
                      //     height: 80,
                      child: TextFormField(
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: const InputDecoration(labelText: 'P.BALANCE'),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems,),
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
    );
  }
}