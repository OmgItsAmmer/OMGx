import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/common/widgets/icons/t_circular_icon.dart';
import 'package:ecommerce_dashboard/controllers/reviews/review_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:ecommerce_dashboard/views/Reviews/widgets/review_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ReviewHeader extends StatelessWidget {
  const ReviewHeader({
    super.key,
    required this.controller,
    this.isMobile = false,
    this.isTablet = false,
    this.showSearchBar = true,
    this.showActionButtons = true,
  });

  final ReviewController controller;
  final bool isMobile;
  final bool isTablet;
  final bool showSearchBar;
  final bool showActionButtons;

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return _buildMobileHeader();
    } else if (isTablet) {
      return _buildTabletHeader();
    } else {
      return _buildDesktopHeader();
    }
  }

  Widget _buildDesktopHeader() {
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.lg),
      backgroundColor: TColors.white,
      showBorder: true,
      borderColor: TColors.borderPrimary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Iconsax.message_question,
                size: 32,
                color: TColors.primary,
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Customer Reviews',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: TColors.dark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(() => Text(
                          'Total: ${controller.totalCount.value} reviews',
                          style: const TextStyle(
                            fontSize: 16,
                            color: TColors.darkGrey,
                          ),
                        )),
                  ],
                ),
              ),
              if (showActionButtons) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        TCircularIcon(
                          icon: Iconsax.refresh,
                          backgroundColor: TColors.primary,
                          onPressed: controller.refreshData,
                          color: TColors.white,
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems),
                        TCircularIcon(
                          icon: Iconsax.export,
                          onPressed: () {},
                          color: TColors.white,
                          backgroundColor: TColors.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    if (showSearchBar) ReviewSearchBar(controller: controller),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabletHeader() {
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.lg),
      backgroundColor: TColors.white,
      showBorder: true,
      borderColor: TColors.borderPrimary,
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Iconsax.message_question,
                size: 32,
                color: TColors.primary,
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Customer Reviews',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: TColors.dark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(() => Text(
                          'Total: ${controller.totalCount.value} reviews',
                          style: const TextStyle(
                            fontSize: 16,
                            color: TColors.darkGrey,
                          ),
                        )),
                  ],
                ),
              ),
              if (showActionButtons) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        TCircularIcon(
                          icon: Iconsax.refresh,
                          backgroundColor: TColors.primary,
                          onPressed: controller.refreshData,
                          color: TColors.white,
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems),
                        TCircularIcon(
                          icon: Iconsax.export,
                          onPressed: () {},
                          color: TColors.white,
                          backgroundColor: TColors.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    if (showSearchBar)
                      ReviewSearchBar(
                        controller: controller,
                        maxWidth: 500,
                        showCard: false,
                      ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Customer Reviews',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: TColors.dark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(() => Text(
                        'Total: ${controller.totalCount.value} reviews',
                        style: const TextStyle(
                          fontSize: 14,
                          color: TColors.darkGrey,
                        ),
                      )),
                ],
              ),
            ),
            if (showActionButtons) ...[
              IconButton(
                onPressed: () => controller.refreshData(),
                icon: const Icon(
                  Iconsax.refresh,
                  color: TColors.primary,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        if (showSearchBar)
          ReviewSearchBar(controller: controller, isMobile: true),
      ],
    );
  }
}
