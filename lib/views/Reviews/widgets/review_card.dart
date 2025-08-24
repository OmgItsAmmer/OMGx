import 'package:ecommerce_dashboard/Models/review/review_model.dart';
import 'package:ecommerce_dashboard/common/widgets/icons/t_circular_icon.dart';
import 'package:ecommerce_dashboard/controllers/reviews/review_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:ecommerce_dashboard/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ReviewCard extends StatelessWidget {
  final ReviewModel review;
  final bool isDesktop;

  const ReviewCard({
    super.key,
    required this.review,
    this.isDesktop = false,
  });

  @override
  Widget build(BuildContext context) {
    final controller = ReviewController.instance;
    final cardColor = _getVibrantCardColor(review.rating);
    final textColor = _getTextColorForBackground(cardColor);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
        side: BorderSide(
          color: cardColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: isDesktop
            ? _buildDesktopLayout(controller, textColor)
            : _buildMobileLayout(controller, textColor),
      ),
    );
  }

  Widget _buildDesktopLayout(ReviewController controller, Color textColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side - Review content
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(textColor),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              _buildRatingSection(textColor),
              if (review.review != null && review.review!.isNotEmpty) ...[
                const SizedBox(height: TSizes.spaceBtwItems),
                _buildReviewText(textColor),
              ],
            ],
          ),
        ),

        const SizedBox(width: TSizes.spaceBtwItems),

        // Right side - Actions
        _buildActionButtons(controller),
      ],
    );
  }

  Widget _buildMobileLayout(ReviewController controller, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(textColor),
        const SizedBox(height: TSizes.spaceBtwItems / 2),
        _buildRatingSection(textColor),
        if (review.review != null && review.review!.isNotEmpty) ...[
          const SizedBox(height: TSizes.spaceBtwItems),
          _buildReviewText(textColor),
        ],
        const SizedBox(height: TSizes.spaceBtwItems),
        _buildActionButtons(controller),
      ],
    );
  }

  // Helper method to get vibrant card color based on rating
  Color _getVibrantCardColor(double? rating) {
    if (rating == null) return TColors.lightGrey;

    if (rating >= 4.5) {
      return const Color(0xFFE8F5E8); // Vibrant light green
    } else if (rating >= 3.5) {
      return const Color(0xFFE3F2FD); // Vibrant light blue
    } else if (rating >= 2.5) {
      return const Color(0xFFFFF3E0); // Vibrant light orange
    } else if (rating >= 1.5) {
      return const Color(0xFFFFEBEE); // Vibrant light red
    } else {
      return const Color(0xFFFFF8E1); // Vibrant light yellow
    }
  }

  // Helper method to get readable text color for background
  Color _getTextColorForBackground(Color backgroundColor) {
    // Calculate luminance to determine if we need light or dark text
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? TColors.dark : TColors.white;
  }

  Widget _buildHeader(Color textColor) {
    return Row(
      children: [
        // Customer info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Iconsax.user,
                    size: 16,
                    color: TColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      review.customerFullName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (review.productName != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Iconsax.box,
                      size: 14,
                      color: TColors.darkGrey,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        review.productName!,
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),

        // Date
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              review.formattedDate,
              style: TextStyle(
                fontSize: 12,
                color: textColor.withOpacity(0.7),
              ),
            ),
            Text(
              '${review.sentAt.hour.toString().padLeft(2, '0')}:${review.sentAt.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 10,
                color: textColor.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingSection(Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TSizes.sm,
        vertical: TSizes.xs,
      ),
      decoration: BoxDecoration(
        color: THelperFunctions.getReviewRatingColor(review.rating)
            .withOpacity(0.2),
        borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
        border: Border.all(
          color: THelperFunctions.getReviewRatingColor(review.rating)
              .withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (review.rating != null) ...[
            Text(
              review.rating!.toStringAsFixed(1),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: THelperFunctions.getReviewRatingColor(review.rating),
              ),
            ),
            const SizedBox(width: TSizes.xs),
          ],
          ...THelperFunctions.getStarIcons(review.rating, size: 14),
        ],
      ),
    );
  }

  Widget _buildReviewText(Color textColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TSizes.sm),
      decoration: BoxDecoration(
        color: TColors.white,
        borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
        border: Border.all(
          color: TColors.borderPrimary,
          width: 1,
        ),
      ),
      child: Text(
        review.formattedReview,
        style: TextStyle(
          fontSize: 14,
          color: textColor,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildActionButtons(ReviewController controller) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // WhatsApp contact button
        TCircularIcon(
          icon: Iconsax.message,
          color: Colors.white,
          backgroundColor: Colors.green,
          size: 20,
          onPressed: () => controller.openWhatsApp(review),
        ),
        const SizedBox(width: TSizes.xs),

        // Email contact button
        TCircularIcon(
          icon: Iconsax.sms,
          color: Colors.white,
          backgroundColor: Colors.blue,
          size: 20,
          onPressed: () => controller.openEmail(review),
        ),
        const SizedBox(width: TSizes.xs),

        // Delete button
        TCircularIcon(
          icon: Iconsax.trash,
          color: Colors.white,
          backgroundColor: Colors.red,
          size: 20,
          onPressed: () => _showDeleteConfirmation(controller),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(ReviewController controller) {
    Get.defaultDialog(
      title: 'Delete Review',
      middleText:
          'Are you sure you want to delete this review? This action cannot be undone.',
      textCancel: 'Cancel',
      textConfirm: 'Delete',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        controller.deleteReview(review);
      },
    );
  }
}
