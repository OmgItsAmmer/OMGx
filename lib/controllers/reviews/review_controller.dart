import 'package:ecommerce_dashboard/Models/review/review_model.dart';
import 'package:ecommerce_dashboard/common/widgets/loaders/tloaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../repositories/review/review_repository.dart';

class ReviewController extends GetxController {
  static ReviewController get instance => Get.find();
  final ReviewRepository reviewRepository = Get.put(ReviewRepository());

  final RxList<ReviewModel> reviews = <ReviewModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString searchQuery = ''.obs;
  final RxInt currentPage = 1.obs;
  final RxBool hasMoreData = true.obs;
  final RxInt totalCount = 0.obs;
  final RxDouble selectedRatingFilter = 0.0.obs;
  final RxList<ReviewModel> allReviews = <ReviewModel>[].obs;

  final TextEditingController searchController = TextEditingController();
  final int itemsPerPage = 20;

  @override
  void onInit() {
    super.onInit();
    fetchReviews();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // Fetch reviews with pagination
  Future<void> fetchReviews({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        currentPage.value = 1;
        hasMoreData.value = true;
        reviews.clear();
      }

      if (currentPage.value == 1) {
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }

      final fetchedReviews = await reviewRepository.getReviews(
        page: currentPage.value,
        limit: itemsPerPage,
        searchQuery: searchQuery.value.isEmpty ? null : searchQuery.value,
      );

      if (fetchedReviews.length < itemsPerPage) {
        hasMoreData.value = false;
      }

      if (currentPage.value == 1) {
        reviews.assignAll(fetchedReviews);
        allReviews.assignAll(fetchedReviews);
      } else {
        reviews.addAll(fetchedReviews);
        allReviews.addAll(fetchedReviews);
      }

      // Get total count for first page
      if (currentPage.value == 1) {
        totalCount.value = await reviewRepository.getReviewsCount(
          searchQuery: searchQuery.value.isEmpty ? null : searchQuery.value,
        );
      }

      currentPage.value++;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  // Load more reviews (lazy loading)
  Future<void> loadMoreReviews() async {
    if (!hasMoreData.value || isLoadingMore.value) return;
    await fetchReviews();
  }

  // Search functionality - fetches all data and filters client-side for comprehensive search
  Future<void> searchReviews(String query) async {
    try {
      searchQuery.value = query;
      isLoading.value = true;

      // Fetch all reviews for comprehensive search
      final allFetchedReviews = await reviewRepository.getAllReviews();

      // Apply search filter
      if (query.isNotEmpty) {
        final searchQueryLower = query.toLowerCase();
        final filteredReviews = allFetchedReviews.where((review) {
          return (review.review?.toLowerCase().contains(searchQueryLower) ??
                  false) ||
              (review.customerFirstName
                      ?.toLowerCase()
                      .contains(searchQueryLower) ??
                  false) ||
              (review.customerLastName
                      ?.toLowerCase()
                      .contains(searchQueryLower) ??
                  false) ||
              (review.productName?.toLowerCase().contains(searchQueryLower) ??
                  false) ||
              (review.customerFullName
                  .toLowerCase()
                  .contains(searchQueryLower));
        }).toList();

        reviews.assignAll(filteredReviews);
        allReviews.assignAll(filteredReviews);
        totalCount.value = filteredReviews.length;
      } else {
        // If search is empty, show all reviews
        reviews.assignAll(allFetchedReviews);
        allReviews.assignAll(allFetchedReviews);
        totalCount.value = allFetchedReviews.length;
      }

      hasMoreData.value = false; // No pagination needed for search results
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Clear search - fetches data the same way as on startup
  Future<void> clearSearch() async {
    searchController.clear();
    searchQuery.value = '';
    currentPage.value = 1;
    hasMoreData.value = true;
    await fetchReviews(isRefresh: true);
  }

  // Delete review
  Future<void> deleteReview(ReviewModel review) async {
    try {
      isLoading.value = true;
      await reviewRepository.deleteReview(review.reviewId!);
      reviews.remove(review);
      totalCount.value--;
      TLoaders.successSnackBar(
          title: 'Success', message: 'Review deleted successfully');
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Open WhatsApp contact
  Future<void> openWhatsApp(ReviewModel review) async {
    try {
      if (review.customerPhone == null || review.customerPhone!.isEmpty) {
        TLoaders.errorSnackBar(
            title: 'Error',
            message: 'Phone number not available for this customer');
        return;
      }

      // Clean phone number (remove spaces, dashes, etc.)
      String phoneNumber =
          review.customerPhone!.replaceAll(RegExp(r'[^\d+]'), '');

      // Add country code if not present (assuming Pakistan +92)
      if (!phoneNumber.startsWith('+')) {
        if (phoneNumber.startsWith('0')) {
          phoneNumber = '+92${phoneNumber.substring(1)}';
        } else {
          phoneNumber = '+92$phoneNumber';
        }
      }

      final whatsappUrl =
          'https://wa.me/$phoneNumber?text=Hello ${review.customerFullName}, regarding your review for ${review.productName ?? "our product"}';

      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(Uri.parse(whatsappUrl));
      } else {
        TLoaders.errorSnackBar(
            title: 'Error', message: 'Could not open WhatsApp');
      }
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Error', message: 'Failed to open WhatsApp: $e');
    }
  }

  // Open email contact
  Future<void> openEmail(ReviewModel review) async {
    try {
      if (review.customerEmail == null || review.customerEmail!.isEmpty) {
        TLoaders.errorSnackBar(
            title: 'Error',
            message: 'Email address not available for this customer');
        return;
      }

      final emailUrl =
          'mailto:${review.customerEmail}?subject=Regarding your review for ${review.productName ?? "our product"}&body=Hello ${review.customerFullName},%0A%0AThank you for your review.';

      if (await canLaunchUrl(Uri.parse(emailUrl))) {
        await launchUrl(Uri.parse(emailUrl));
      } else {
        TLoaders.errorSnackBar(
            title: 'Error', message: 'Could not open email client');
      }
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Error', message: 'Failed to open email: $e');
    }
  }

  // Get reviews by product
  Future<void> fetchReviewsByProduct(int productId) async {
    try {
      isLoading.value = true;
      final productReviews =
          await reviewRepository.getReviewsByProduct(productId);
      reviews.assignAll(productReviews);
      totalCount.value = productReviews.length;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Get reviews by customer
  Future<void> fetchReviewsByCustomer(int customerId) async {
    try {
      isLoading.value = true;
      final customerReviews =
          await reviewRepository.getReviewsByCustomer(customerId);
      reviews.assignAll(customerReviews);
      totalCount.value = customerReviews.length;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh data
  Future<void> refreshData() async {
    await fetchReviews(isRefresh: true);
  }

  // Filter reviews by rating
  void filterByRating(double rating) {
    selectedRatingFilter.value = rating;
    if (rating == 0.0) {
      // Show all reviews
      reviews.assignAll(allReviews);
    } else {
      // Filter reviews by rating
      final filteredReviews = allReviews.where((review) {
        if (review.rating == null) return false;
        return review.rating! >= rating && review.rating! < rating + 1.0;
      }).toList();
      reviews.assignAll(filteredReviews);
    }
  }

  // Clear rating filter
  void clearRatingFilter() {
    selectedRatingFilter.value = 0.0;
    reviews.assignAll(allReviews);
  }

  // Get rating filter options
  List<Map<String, dynamic>> getRatingFilterOptions() {
    return [
      {'rating': 5.0, 'label': '5 Stars', 'color': const Color(0xFF4CAF50)},
      {'rating': 4.0, 'label': '4+ Stars', 'color': const Color(0xFF2196F3)},
      {'rating': 3.0, 'label': '3+ Stars', 'color': const Color(0xFFFF9800)},
      {'rating': 2.0, 'label': '2+ Stars', 'color': const Color(0xFFF44336)},
      {'rating': 1.0, 'label': '1+ Stars', 'color': const Color(0xFFFFEB3B)},
    ];
  }
}
