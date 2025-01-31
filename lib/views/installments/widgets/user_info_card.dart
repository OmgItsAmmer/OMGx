import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/images/t_rounded_image.dart';
import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../common/widgets/dropdown_search/searchable_text_field.dart';
import '../../../controllers/sales/sales_controller.dart';
import '../../../repositories/guarantors/guarantor_repository.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/validators/validation.dart';

class UserInfoCard extends StatelessWidget {
  final String hintText;

  final cardTitle;
  final namesList;
  final addressList;
  final onSelectedName;
  final userNameTextController;
  final addressTextController;
  final cnicTextController;
  final phoneNoTextController;
  final readOnly;
  final formKey;


  const UserInfoCard(
      {super.key,
        required this.cardTitle,
        required this.hintText,
        required this.readOnly,
        required this.namesList,
        required this.onSelectedName,
        required this.userNameTextController,
        required this.cnicTextController,
        required this.phoneNoTextController,
        required this.addressList,
        required this.formKey,
        required this.addressTextController});

  @override
  Widget build(BuildContext context) {



    return Form(
      key: formKey,
      child: TRoundedContainer(
        backgroundColor: TColors.primaryBackground,

        //  height: 500,
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cardTitle,
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
                  child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          // height: 80,
                          child: TextFormField(
                            controller:
                           phoneNoTextController,
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

                          child: TextFormField(
                            controller:
                            addressTextController,
                            validator: (value) => TValidator.validateEmptyText(
                                'Address', value),
                            keyboardType: TextInputType
                                .number, // Ensure numeric keyboard is shown
                            readOnly: readOnly,
                            maxLines: 3,
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration:
                            const InputDecoration(labelText: 'Address'),
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
                            cnicTextController,
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

                )
              ],
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),

          ],
        ),
      ),
    );
  }
}
