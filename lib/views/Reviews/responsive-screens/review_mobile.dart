import 'package:ecommerce_dashboard/controllers/reviews/review_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:ecommerce_dashboard/views/Reviews/widgets/review_header.dart';
import 'package:ecommerce_dashboard/views/Reviews/widgets/review_list.dart';
import 'package:ecommerce_dashboard/views/Reviews/widgets/review_rating_filter_section.dart';
import 'package:ecommerce_dashboard/views/Reviews/widgets/review_quick_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewMobileScreen extends StatelessWidget {
  const ReviewMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReviewController());

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            // Header Section
            ReviewHeader(controller: controller, isMobile: true),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Rating Filter Section
            ReviewRatingFilterSection(controller: controller, isMobile: true),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Reviews List
            SizedBox(
              height: MediaQuery.of(context).size.height -
                  400, // Give it a fixed height for mobile
              child: ReviewList(controller: controller, isMobile: true),
            ),

            // Quick Actions (Mobile)
            const SizedBox(height: TSizes.spaceBtwItems),
            ReviewQuickCard(controller: controller, isMobile: true),
          ],
        ),
      ),
    );
  }
}
