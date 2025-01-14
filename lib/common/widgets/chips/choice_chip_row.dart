import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';
import 'choice_chip.dart';

class OChoiceChipRow extends StatelessWidget {
  final bool showChip1;
  final bool showChip2;
  final bool showChip3;
  final bool chip1Selected;
  final bool chip2Selected;
  final bool chip3Selected;
  final ValueChanged<bool>? onChip1Selected;
  final ValueChanged<bool>? onChip2Selected;
  final ValueChanged<bool>? onChip3Selected;

  const OChoiceChipRow({
    super.key,
    this.showChip1 = false,
    this.showChip2 = false,
    this.showChip3 = false,
    this.chip1Selected = false,
    this.chip2Selected = false,
    this.chip3Selected = false,
    this.onChip1Selected,
    this.onChip2Selected,
    this.onChip3Selected,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> chips = [];

    // Add chip 1 if showChip1 is true
    if (showChip1) {
      chips.add(
        TChoiceChip(
          text: 'Pending',
          selected: chip1Selected,
          onSelected: onChip1Selected,
        ),
      );
    }

    // Add space between chips if showChip1 is true and showChip2 is true
    if (showChip1 && showChip2) {
      chips.add(const SizedBox(width: TSizes.spaceBtwItems));
    }

    // Add chip 2 if showChip2 is true
    if (showChip2) {
      chips.add(
        TChoiceChip(
          text: 'Completed',
          selected: chip2Selected,
          onSelected: onChip2Selected,
        ),
      );
    }

    // Add space between chips if showChip2 is true and showChip3 is true
    if (showChip2 && showChip3) {
      chips.add(const SizedBox(width: TSizes.spaceBtwItems));
    }

    // Add chip 3 if showChip3 is true
    if (showChip3) {
      chips.add(
        TChoiceChip(
          text: 'Cancelled',
          selected: chip3Selected,
          onSelected: onChip3Selected,
        ),
      );
    }

    // Return the row with the dynamic chips
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: chips,
    );
  }
}
