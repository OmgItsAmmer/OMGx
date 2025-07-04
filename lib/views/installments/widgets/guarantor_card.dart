import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/controllers/guarantors/guarantor_controller.dart';
import 'package:ecommerce_dashboard/controllers/guarantors/guarantor_image_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controllers/media/media_controller.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/validators/validation.dart';

import 'guarantor_image.dart';

class GuarrantorCard extends StatelessWidget {
  final int guarrantorIndex;
  final String cardTitle;
  final String hintText;
  final List<String> namesList;
  final List<String> addressList;
  final bool readOnly;
  final Function(String) onSelectedName;
  final TextEditingController userNameTextController;
  final TextEditingController addressTextController;
  final TextEditingController cnicTextController;
  final TextEditingController phoneNoTextController;
  final GlobalKey<FormState> formKey;

  const GuarrantorCard({
    super.key,
    required this.guarrantorIndex,
    required this.cardTitle,
    required this.hintText,
    required this.namesList,
    required this.addressList,
    required this.readOnly,
    required this.onSelectedName,
    required this.userNameTextController,
    required this.addressTextController,
    required this.cnicTextController,
    required this.phoneNoTextController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    final MediaController mediaController = Get.find<MediaController>();
    final GuarantorController guarantorController =
        Get.find<GuarantorController>();
    final GuarantorImageController guarantorImageController =
        Get.find<GuarantorImageController>();

    // Listen to media controller changes outside of build
    ever(mediaController.displayImage, (imageModel) {
      if (imageModel != null &&
          mediaController.displayImageOwner ==
              MediaCategory.guarantors.toString().split('.').last) {
        // Update the appropriate guarantor image based on the index
        if (guarrantorIndex == 1) {
          guarantorImageController.guarantor1Image.value = imageModel;
        } else if (guarrantorIndex == 2) {
          guarantorImageController.guarantor2Image.value = imageModel;
        }
        mediaController.displayImage.value = null;
      }
    });

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(cardTitle, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Add guarantor image
          GuarantorImage(
            guarantorId: guarrantorIndex,
            guarantorType: MediaCategory.guarantors.toString().split('.').last,
            width: 120,
            height: 120,
          ),

          const SizedBox(height: TSizes.spaceBtwItems),

          Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  //    height: 80,
                  child: TextFormField(
                    controller: userNameTextController,
                    validator: (value) =>
                        TValidator.validateEmptyText(hintText, value),
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(labelText: hintText),
                    readOnly: readOnly,
                  ),
                ),
                const SizedBox(
                  height: TSizes.spaceBtwItems,
                ),
                SizedBox(
                  width: double.infinity,
                  //     height: 80,
                  child: TextFormField(
                    controller: cnicTextController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) =>
                        TValidator.validateEmptyText('CNIC', value),
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: const InputDecoration(
                        labelText: 'CNIC (without dashes)'),
                  ),
                ),
                const SizedBox(
                  height: TSizes.spaceBtwItems,
                ),
                SizedBox(
                  width: double.infinity,
                  //    height: 80,
                  child: TextFormField(
                    controller: addressTextController,
                    validator: (value) =>
                        TValidator.validateEmptyText('Address', value),
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: const InputDecoration(labelText: 'Address'),
                  ),
                ),
                const SizedBox(
                  height: TSizes.spaceBtwItems,
                ),
                SizedBox(
                  width: double.infinity,
                  //    height: 80,
                  child: TextFormField(
                    controller: phoneNoTextController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) =>
                        TValidator.validateEmptyText('Phone Number', value),
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration:
                        const InputDecoration(labelText: 'Phone Number'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
