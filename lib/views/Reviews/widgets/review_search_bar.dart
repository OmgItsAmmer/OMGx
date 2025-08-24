import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/controllers/reviews/review_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ReviewSearchBar extends StatelessWidget {
  const ReviewSearchBar({
    super.key,
    required this.controller,
    this.isMobile = false,
    this.maxWidth,
    this.showCard = true,
  });

  final ReviewController controller;
  final bool isMobile;
  final double? maxWidth;
  final bool showCard;

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return _buildMobileSearchBar();
    } else {
      return showCard ? _buildCardSearchBar() : _buildCompactSearchBar();
    }
  }

  Widget _buildCardSearchBar() {
    return TRoundedContainer(
      //  padding: 0,
      backgroundColor: TColors.light,
      width: maxWidth ?? 600,
      showBorder: false,
      borderColor: TColors.borderPrimary,
      child: _buildTextField(),
    );
  }

  Widget _buildCompactSearchBar() {
    return Container(
      constraints:
          maxWidth != null ? BoxConstraints(maxWidth: maxWidth!) : null,
      decoration: BoxDecoration(
        color: TColors.light,
        borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
        border: Border.all(color: TColors.borderPrimary),
      ),
      child: _buildTextField(),
    );
  }

  Widget _buildMobileSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: TColors.white,
        borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _buildTextField(),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: controller.searchController,
      onChanged: (value) async {
        // Debounce search to avoid too many API calls
        if (controller.searchController.text.isEmpty) {
          await controller.clearSearch();
        } else if (value.length >= 2) {
          // Only search if query has at least 2 characters
          await controller.searchReviews(value);
        }
      },
      onSubmitted: (value) async {
        await controller.searchReviews(value);
      },
      decoration: InputDecoration(
        hintText: 'Search reviews, customers, or products...',
        hintStyle: const TextStyle(color: TColors.darkGrey),
        prefixIcon: Icon(
          Iconsax.search_normal,
          color: isMobile ? TColors.darkGrey : TColors.primary,
        ),
        suffixIcon: Obx(
          () => controller.searchQuery.value.isNotEmpty
              ? IconButton(
                  onPressed: () async {
                    await controller.clearSearch();
                  },
                  icon: const Icon(
                    Iconsax.close_circle,
                    color: TColors.darkGrey,
                  ),
                )
              : IconButton(
                  onPressed: () async {
                    await controller
                        .searchReviews(controller.searchController.text);
                  },
                  icon: const Icon(
                    Iconsax.search_normal,
                    color: TColors.primary,
                  ),
                ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: TSizes.md,
          vertical: isMobile ? TSizes.sm : TSizes.md,
        ),
      ),
    );
  }
}
