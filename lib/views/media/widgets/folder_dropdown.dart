import 'package:ecommerce_dashboard/controllers/media/media_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MediaFolderDropDown extends StatelessWidget {
  const MediaFolderDropDown({super.key, this.onChanged});

  final void Function(MediaCategory?)? onChanged;
  @override
  Widget build(BuildContext context) {
    final MediaController mediaController = Get.find<MediaController>();

    return Obx(
      () => SizedBox(
        width: 140,
        child: DropdownButtonFormField(
          isExpanded: false,
          value: mediaController.selectedPath.value,
          items: MediaCategory.values
              .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category.name.capitalize.toString())))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
