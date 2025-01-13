import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';


class TFormDivider extends StatelessWidget {
  String divierText;
  TFormDivider({
    super.key,
    required this.dark,required this.divierText
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
            child: Divider(
              color: dark ? TColors.darkGrey : TColors.grey,
              thickness: 0.5,
              indent: 60,
              endIndent: 5,
            )),
        Text(
          divierText,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        Flexible(
            child: Divider(
              color: dark ? TColors.darkGrey : TColors.grey,
              thickness: 0.5,
              indent: 5,
              endIndent: 60,
            ))
      ],
    );
  }
}