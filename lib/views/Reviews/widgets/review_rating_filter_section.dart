import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/controllers/reviews/review_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:ecommerce_dashboard/views/Reviews/widgets/review_filter_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ReviewRatingFilterSection extends StatelessWidget {
  const ReviewRatingFilterSection({
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
      return _buildMobileLayout();
    } else {
      return showCard ? _buildCardLayout() : _buildCompactLayout();
    }
  }

  Widget _buildCardLayout() {
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.lg),
      backgroundColor: TColors.white,
      showBorder: true,
      borderColor: TColors.borderPrimary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: TSizes.spaceBtwItems),
          _buildFilterOptions(),
        ],
      ),
    );
  }

  Widget _buildCompactLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: TSizes.sm),
        _buildFilterOptions(),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: TSizes.sm),
        _buildMobileFilterChips(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Iconsax.star,
          color: TColors.primary,
          size: isMobile ? 20 : 24,
        ),
        SizedBox(width: TSizes.xs),
        Text(
          'Filter by Rating',
          style: TextStyle(
            fontSize: isMobile ? 16 : 18,
            fontWeight: FontWeight.bold,
            color: TColors.dark,
          ),
        ),
        const Spacer(),
        Obx(() => controller.selectedRatingFilter.value > 0.0
            ? IconButton(
                onPressed: controller.clearRatingFilter,
                icon: Icon(
                  Iconsax.close_circle,
                  color: TColors.darkGrey,
                  size: isMobile ? 18 : 20,
                ),
              )
            : Container()),
      ],
    );
  }

  Widget _buildFilterOptions() {
    return Obx(() => Column(
          children: [
            ReviewFilterCard(
              controller: controller,
              label: 'All Reviews',
              rating: 0.0,
              color: TColors.darkGrey,
              isSelected: controller.selectedRatingFilter.value == 0.0,
            ),
            ...controller
                .getRatingFilterOptions()
                .map((option) => ReviewFilterCard(
                      controller: controller,
                      label: option['label'],
                      rating: option['rating'],
                      color: option['color'],
                      isSelected: controller.selectedRatingFilter.value ==
                          option['rating'],
                    )),
          ],
        ));
  }

  Widget _buildMobileFilterChips() {
    return Obx(() => Wrap(
          spacing: TSizes.xs,
          runSpacing: TSizes.xs,
          children: [
            _buildFilterChip(
              'All',
              0.0,
              TColors.darkGrey,
              controller.selectedRatingFilter.value == 0.0,
            ),
            ...controller
                .getRatingFilterOptions()
                .map((option) => _buildFilterChip(
                      option['label'],
                      option['rating'],
                      option['color'],
                      controller.selectedRatingFilter.value == option['rating'],
                    )),
          ],
        ));
  }

  Widget _buildFilterChip(
    String label,
    double rating,
    Color color,
    bool isSelected,
  ) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isSelected ? TColors.white : color,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) => controller.filterByRating(rating),
      backgroundColor: Colors.transparent,
      selectedColor: color,
      checkmarkColor: TColors.white,
      side: BorderSide(color: color.withOpacity(0.3)),
      padding: const EdgeInsets.symmetric(
        horizontal: TSizes.sm,
        vertical: TSizes.xs,
      ),
    );
  }
}
