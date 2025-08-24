import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/controllers/reviews/review_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ReviewQuickCard extends StatelessWidget {
  const ReviewQuickCard({
    super.key,
    required this.controller,
    this.isMobile = false,
    this.showCard = true,
  });

  final ReviewController controller;
  final bool isMobile;
  final bool showCard;

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return _buildMobileQuickActions();
    } else {
      return showCard ? _buildCardQuickActions() : _buildCompactQuickActions();
    }
  }

  Widget _buildCardQuickActions() {
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.lg),
      backgroundColor: TColors.white,
      showBorder: true,
      borderColor: TColors.borderPrimary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Iconsax.flash,
                color: TColors.primary,
                size: isMobile ? 20 : 24,
              ),
              const SizedBox(width: TSizes.xs),
              Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.bold,
                  color: TColors.dark,
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          _buildQuickActionButton(
            'Refresh Data',
            Iconsax.refresh,
            TColors.primary,
            controller.refreshData,
          ),
          _buildQuickActionButton(
            'Clear Search',
            Iconsax.close_circle,
            TColors.warning,
            controller.clearSearch,
          ),
          _buildQuickActionButton(
            'Load More',
            Iconsax.arrow_down,
            TColors.info,
            controller.loadMoreReviews,
          ),
        ],
      ),
    );
  }

  Widget _buildCompactQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Iconsax.flash,
              color: TColors.primary,
              size: isMobile ? 20 : 24,
            ),
            const SizedBox(width: TSizes.xs),
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.bold,
                color: TColors.dark,
              ),
            ),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        _buildQuickActionButton(
          'Refresh Data',
          Iconsax.refresh,
          TColors.primary,
          controller.refreshData,
        ),
        _buildQuickActionButton(
          'Clear Search',
          Iconsax.close_circle,
          TColors.warning,
          controller.clearSearch,
        ),
        _buildQuickActionButton(
          'Load More',
          Iconsax.arrow_down,
          TColors.info,
          controller.loadMoreReviews,
        ),
      ],
    );
  }

  Widget _buildMobileQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildMobileQuickActionButton(
          'Refresh',
          Iconsax.refresh,
          TColors.primary,
          controller.refreshData,
        ),
        _buildMobileQuickActionButton(
          'Clear',
          Iconsax.close_circle,
          TColors.warning,
          controller.clearSearch,
        ),
        _buildMobileQuickActionButton(
          'More',
          Iconsax.arrow_down,
          TColors.info,
          controller.loadMoreReviews,
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TSizes.sm),
      child: Material(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(TSizes.sm),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: isMobile ? 16 : 20,
                  color: color,
                ),
                const SizedBox(width: TSizes.sm),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileQuickActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: Material(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TSizes.sm,
              vertical: TSizes.md,
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: color,
                ),
                const SizedBox(height: TSizes.xs),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
