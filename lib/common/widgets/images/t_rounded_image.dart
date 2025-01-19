import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../utils/constants/sizes.dart';
import '../shimmers/shimmer.dart';

class TRoundedImage extends StatelessWidget {
  const TRoundedImage({
    super.key,
    this.width,
    this.height,
    required this.imageurl,
    this.applyImageRadius = true,
    this.border,
    this.backgroundColor,
    this.fit = BoxFit.contain,
    this.padding,
    this.isNetworkImage = false,
    this.onPressed,
    this.borderRadius = TSizes.md,
  });

  final double? width, height;
  final String imageurl;
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color? backgroundColor;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final bool isNetworkImage;
  final VoidCallback? onPressed;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: border,
          color: backgroundColor,
        ),
        child: ClipRRect(
          borderRadius: applyImageRadius
              ? BorderRadius.circular(borderRadius)
              : BorderRadius.zero,
          child: isNetworkImage
              ? CachedNetworkImage(
            imageUrl: imageurl,
            fit: fit,
            placeholder: (context, url) => Center(child: TShimmerEffect(width: 80, height: 80)),
            errorWidget: (context, url, error) => Icon(Icons.error),
          )
              : Image.asset(
            imageurl,
            fit: fit,
          ),
        ),
      ),
    );
  }
}
