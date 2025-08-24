import 'package:ecommerce_dashboard/controllers/reviews/review_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:ecommerce_dashboard/views/Reviews/widgets/review_header.dart';
import 'package:ecommerce_dashboard/views/Reviews/widgets/review_list.dart';
import 'package:ecommerce_dashboard/views/Reviews/widgets/review_rating_filter_section.dart';
import 'package:ecommerce_dashboard/views/Reviews/widgets/review_quick_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewTabletScreen extends StatelessWidget {
  const ReviewTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReviewController());

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            // Header Section
            ReviewHeader(controller: controller, isTablet: true),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Main Content
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Reviews List
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height -
                        200, // Give it a fixed height
                    child: ReviewList(controller: controller, showCard: false),
                  ),
                ),

                const SizedBox(width: TSizes.spaceBtwSections),

                // Sidebar with Rating Filter
                SizedBox(
                  width: 250,
                  child: Column(
                    children: [
                      ReviewRatingFilterSection(
                          controller: controller, showCard: false),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      ReviewQuickCard(controller: controller, showCard: false),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
