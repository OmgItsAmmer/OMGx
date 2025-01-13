
import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../custom_shapes/containers/circular_container.dart';

class TChoiceChip extends StatelessWidget {
  const TChoiceChip({
    super.key,
    required this.text,
    required this.selected,
    this.onSelected,
  });
  final String text;
  final bool selected;
  final void Function(bool)? onSelected;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: ChoiceChip(
        label: THelperFunctions.getColor(text) != null
            ? const SizedBox()
            :  Text(text),
        selected: selected,
        onSelected: onSelected,
        labelStyle: TextStyle(color: selected ? TColors.white : null),
        avatar: THelperFunctions.getColor(text) != null
            ? TCircularContainer(
                width: 50,
                height: 50,
                backgroundColor: THelperFunctions.getColor(text)!,
              )
            : null,
        shape: THelperFunctions.getColor(text) != null ? CircleBorder():null,
        backgroundColor: THelperFunctions.getColor(text) != null ? THelperFunctions.getColor(text)! : null,
        labelPadding: THelperFunctions.getColor(text) != null ? const EdgeInsets.all(0): null,
        padding:THelperFunctions.getColor(text) != null ? EdgeInsets.all(0):null,
        selectedColor: THelperFunctions.getColor(text) != null ?THelperFunctions.getColor(text)! : null,
      ),
    );
  }
}
