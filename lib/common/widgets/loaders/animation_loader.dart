import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

/// A widget for displaying an animated loading indicator with optional text and action button.
class TAnimationLoaderWidget extends StatelessWidget {
  /// Default constructor for the TAnimationLoaderWidget.
  ///
  /// Parameters:
  ///   - text: The text to be displayed below the animation.
  ///   - animation: The path to the Lottie animation file.
  ///   - isText: Whether to show the text below the animation.
  ///   - showAction: Whether to show an action button below the text.
  ///   - actionText: The text to be displayed on the action button.
  ///   - onActionPressed: Callback function to be executed when the action button is pressed.
  const TAnimationLoaderWidget({
    super.key,
    required this.animation,
    this.text = '',
    this.isText = true,
    this.showAction = false,
    this.actionText,
    this.onActionPressed,
    this.height = 100, // Default fixed height
    this.width = 100,  // Default fixed width
    this.style,
  });

  final String text;
  final TextStyle? style;
  final String animation;
  final bool isText;
  final bool showAction;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min, // Prevent unnecessary expansion
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            animation,
            height: height, // Use fixed height
            width: width,   // Use fixed width
            fit: BoxFit.contain,
          ),
          if (isText) ...[
            const SizedBox(height: TSizes.defaultSpace),
            Text(
              text,
              style: style ?? Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
          if (showAction) ...[
            const SizedBox(height: TSizes.defaultSpace),
            SizedBox(
              width: 250,
              child: OutlinedButton(
                onPressed: onActionPressed,
                style: OutlinedButton.styleFrom(backgroundColor: TColors.dark),
                child: Text(
                  actionText!,
                  style: Theme.of(context).textTheme.bodyMedium!.apply(color: TColors.light),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
