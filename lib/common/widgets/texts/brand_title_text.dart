import 'package:flutter/material.dart';

import '../../../utils/constants/enums.dart';

class TBrandTitleText extends StatelessWidget {
  const TBrandTitleText({
    super.key,
    required this.title,
    this.maxLines=1,
    this.textAlign,
    this.brandTextSizes=TextSizes.small,
    this.color,
  });

  final String title;
  final int maxLines;
  final Color? color;
  final TextAlign? textAlign;
  final TextSizes brandTextSizes;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            maxLines: maxLines,
            style: brandTextSizes==TextSizes.small ? Theme.of(context).textTheme.labelMedium!.apply(color: color):
            brandTextSizes == TextSizes.medium ?
            Theme.of(context).textTheme.labelLarge!.apply(color: color) :
            brandTextSizes == TextSizes.large ? Theme.of(context).textTheme.titleLarge!.apply(color: color):
            Theme.of(context).textTheme.bodyMedium!.apply(color: color)
            ,
          ),
        ),
      ],
    );
  }
}
