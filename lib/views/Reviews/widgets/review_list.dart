import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/controllers/reviews/review_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:ecommerce_dashboard/views/Reviews/widgets/review_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ReviewList extends StatelessWidget {
  const ReviewList({
    super.key,
    required this.controller,
    this.isMobile = false,
    this.showCard = true,
    this.maxWidth,
  });

  final ReviewController controller;
  final bool isMobile;
  final bool showCard;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return _buildMobileList();
    } else {
      return showCard ? _buildCardList() : _buildCompactList();
    }
  }

  Widget _buildCardList() {
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.md),
      backgroundColor: TColors.white,
      width: maxWidth ?? 600,
      showBorder: true,
      borderColor: TColors.borderPrimary,
      child: _buildListContent(),
    );
  }

  Widget _buildCompactList() {
    return TRoundedContainer(
      backgroundColor: TColors.white,
      showBorder: true,
      borderColor: TColors.borderPrimary,
      child: _buildListContent(),
    );
  }

  Widget _buildMobileList() {
    return _buildListContent();
  }

  Widget _buildListContent() {
    return Obx(() {
      if (controller.isLoading.value && controller.reviews.isEmpty) {
        return _buildLoadingState();
      }

      if (controller.reviews.isEmpty) {
        return _buildEmptyState();
      }

      return Column(
        children: [
          if (!isMobile) _buildListHeader(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.refreshData,
              color: TColors.primary,
              child: ListView.separated(
                padding: EdgeInsets.all(isMobile ? 0 : TSizes.md),
                itemCount: controller.reviews.length +
                    (controller.hasMoreData.value ? 1 : 0),
                separatorBuilder: (context, index) =>
                    SizedBox(height: isMobile ? 0 : TSizes.spaceBtwItems),
                itemBuilder: (context, index) {
                  if (index == controller.reviews.length) {
                    return _buildLoadMoreIndicator();
                  }

                  return ReviewCard(
                    review: controller.reviews[index],
                    isDesktop: !isMobile,
                  );
                },
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildListHeader() {
    return Container(
      padding: const EdgeInsets.all(TSizes.md),
      decoration: const BoxDecoration(
        color: TColors.light,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(TSizes.borderRadiusLg),
          topRight: Radius.circular(TSizes.borderRadiusLg),
        ),
        border: Border(
          bottom: BorderSide(color: TColors.borderPrimary),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Recent Reviews',
            style: TextStyle(
              fontSize: isMobile ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: TColors.dark,
            ),
          ),
          const Spacer(),
          Obx(() => controller.searchQuery.value.isNotEmpty
              ? Chip(
                  label: Text(
                    'Filtered: ${controller.reviews.length} results',
                    style: TextStyle(fontSize: isMobile ? 10 : 12),
                  ),
                  backgroundColor: TColors.primary.withValues(alpha: 0.1),
                  deleteIcon: Icon(
                    Iconsax.close_circle,
                    size: isMobile ? 14 : 16,
                  ),
                  onDeleted: controller.clearSearch,
                )
              : Container()),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: TColors.primary),
          const SizedBox(height: TSizes.spaceBtwItems),
          Text(
            'Loading reviews...',
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              color: TColors.darkGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.message_question,
            size: isMobile ? 64 : 80,
            color: TColors.darkGrey,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Text(
            controller.searchQuery.value.isNotEmpty
                ? 'No reviews found'
                : 'No reviews yet',
            style: TextStyle(
              fontSize: isMobile ? 18 : 24,
              fontWeight: FontWeight.bold,
              color: TColors.darkGrey,
            ),
          ),
          const SizedBox(height: TSizes.xs),
          Text(
            controller.searchQuery.value.isNotEmpty
                ? 'Try adjusting your search criteria'
                : 'Customer reviews will appear here',
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              color: TColors.darkGrey,
            ),
            textAlign: TextAlign.center,
          ),
          if (controller.searchQuery.value.isNotEmpty) ...[
            const SizedBox(height: TSizes.spaceBtwItems),
            ElevatedButton(
              onPressed: controller.clearSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.primary,
                foregroundColor: TColors.white,
              ),
              child: const Text('Clear Search'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return Container(
      padding: const EdgeInsets.all(TSizes.spaceBtwItems),
      child: Center(
        child: Obx(() => controller.isLoadingMore.value
            ? Column(
                children: [
                  const CircularProgressIndicator(color: TColors.primary),
                  const SizedBox(height: TSizes.sm),
                  Text(
                    'Loading more reviews...',
                    style: TextStyle(
                      color: TColors.darkGrey,
                      fontSize: isMobile ? 12 : 14,
                    ),
                  ),
                ],
              )
            : ElevatedButton.icon(
                onPressed: controller.loadMoreReviews,
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primary,
                  foregroundColor: TColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.lg,
                    vertical: TSizes.sm,
                  ),
                ),
                icon: const Icon(Iconsax.arrow_down),
                label: const Text('Load More Reviews'),
              )),
      ),
    );
  }
}
