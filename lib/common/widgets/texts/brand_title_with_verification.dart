import 'package:flutter/cupertino.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/enums.dart';
import '../../../utils/constants/sizes.dart';
import 'brand_title_text.dart';

class TBrandTitleWithVerification extends StatelessWidget {
  const TBrandTitleWithVerification(
      {super.key,
      required this.title,
      this.maxLines = 1,
      this.iconColor,
      this.textColor,
      this.textAlign,
      this.brandTextSize = TextSizes.small,
      required this.isVerified});

  final String title;
  final int maxLines;
  final Color? iconColor, textColor;
  final TextAlign? textAlign;
  final TextSizes brandTextSize;
  final bool isVerified;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(right: 2),
              child: TBrandTitleText(
                title: title,
                color: textColor,
                maxLines: maxLines,
                textAlign: textAlign,
                brandTextSizes: brandTextSize,
              ),
            ),
          ),
          (isVerified)
              ? Icon(
                  Iconsax.verify5,
                  color: iconColor,
                  size: TSizes.iconXs,
                )
              : SizedBox()

        ],
      ),
    );
  }
}
