import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/image_strings.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../loaders/animation_loader.dart';

class HoverableCard extends StatefulWidget {
  final String text;
  final String animation;
  final VoidCallback? onPressed;

  const HoverableCard({
    super.key,
    required this.text,
    required this.animation,
    this.onPressed,
  });

  @override
  _HoverableCardState createState() => _HoverableCardState();
}

class _HoverableCardState extends State<HoverableCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: widget.onPressed, // Handle card click action
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 300, // Fixed width
          height: 200, // Fixed height
          decoration: BoxDecoration(
            border: Border.all(width: 0.2),
            color: _isHovered
                ? TColors.primary.withOpacity(0.6) // Very light transparent purple
                : Colors.transparent, // Default transparent color
            borderRadius: BorderRadius.circular(12),
            boxShadow: _isHovered
                ? [
              // Add shadow on hover if needed
            ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center the content
            children: [
              SizedBox(
                width: 100, // Set a specific width for the animation
                height: 100, // Set a specific height for the animation
                child: TAnimationLoaderWidget(
                  isText: false,
                  animation: widget.animation,
                  showAction: false,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              Text(widget.text, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
  }
}
