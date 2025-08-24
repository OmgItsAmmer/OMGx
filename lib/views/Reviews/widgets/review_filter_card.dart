import 'package:ecommerce_dashboard/controllers/reviews/review_controller.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class ReviewFilterCard extends StatelessWidget {
  const ReviewFilterCard(
      {super.key,
      required this.controller,
      required this.label,
      required this.rating,
      required this.color,
      required this.isSelected});
  final ReviewController controller;
  final String label;
  final double rating;
  final Color color;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TSizes.sm),
      child: Material(
        color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
        child: InkWell(
          onTap: () => controller.filterByRating(rating),
          borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
          child: Container(
            padding: const EdgeInsets.all(TSizes.sm),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(TSizes.xs),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
                  ),
                  child: Icon(
                    Icons.star,
                    size: 16,
                    color: color,
                  ),
                ),
                const SizedBox(width: TSizes.sm),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected ? color : TColors.darkGrey,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: color,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
