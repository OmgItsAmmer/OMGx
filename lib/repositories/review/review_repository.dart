import 'package:ecommerce_dashboard/Models/review/review_model.dart';
import 'package:ecommerce_dashboard/main.dart';
import 'package:get/get.dart';

class ReviewRepository extends GetxController {
  static ReviewRepository get instance => Get.find();

  // Fetch reviews with pagination and search
  Future<List<ReviewModel>> getReviews({
    int page = 1,
    int limit = 20,
    String? searchQuery,
  }) async {
    try {
      var query = supabase.from('reviews').select('''
            *,
            customers!inner(
              customer_id,
              first_name,
              last_name,
              phone_number,
              email
            ),
            products!inner(
              product_id,
              name
            )
          ''').order('sent_at', ascending: false);

      // Note: Search will be applied client-side for joined table queries
      // This ensures we can search across review content, customer names, and product names

      // Apply pagination
      query = query.range((page - 1) * limit, page * limit - 1);

      final response = await query;

      if (response.isEmpty) return [];

      List<ReviewModel> reviewModels = response.map((json) {
        // Flatten the nested data for easier access
        final flattenedJson = Map<String, dynamic>.from(json);
        if (json['customers'] != null) {
          flattenedJson['customer_first_name'] =
              json['customers']['first_name'];
          flattenedJson['customer_last_name'] = json['customers']['last_name'];
          flattenedJson['customer_phone'] = json['customers']['phone_number'];
          flattenedJson['customer_email'] = json['customers']['email'];
        }
        if (json['products'] != null) {
          flattenedJson['product_name'] = json['products']['name'];
        }

        return ReviewModel.fromJson(flattenedJson);
      }).toList();

      // Apply search filter client-side for comprehensive search across all fields
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        reviewModels = reviewModels.where((review) {
          return (review.review?.toLowerCase().contains(query) ?? false) ||
              (review.customerFirstName?.toLowerCase().contains(query) ??
                  false) ||
              (review.customerLastName?.toLowerCase().contains(query) ??
                  false) ||
              (review.productName?.toLowerCase().contains(query) ?? false) ||
              (review.customerFullName.toLowerCase().contains(query));
        }).toList();
      }

      return reviewModels;
    } catch (e) {
      throw 'Something went wrong. Please try again. Error: $e';
    }
  }

  // Get all reviews without pagination for comprehensive search
  Future<List<ReviewModel>> getAllReviews() async {
    try {
      final response = await supabase.from('reviews').select('''
            *,
            customers!inner(
              customer_id,
              first_name,
              last_name,
              phone_number,
              email
            ),
            products!inner(
              product_id,
              name
            )
          ''').order('sent_at', ascending: false);

      if (response.isEmpty) return [];

      List<ReviewModel> reviewModels = response.map((json) {
        // Flatten the nested data for easier access
        final flattenedJson = Map<String, dynamic>.from(json);
        if (json['customers'] != null) {
          flattenedJson['customer_first_name'] =
              json['customers']['first_name'];
          flattenedJson['customer_last_name'] = json['customers']['last_name'];
          flattenedJson['customer_phone'] = json['customers']['phone_number'];
          flattenedJson['customer_email'] = json['customers']['email'];
        }
        if (json['products'] != null) {
          flattenedJson['product_name'] = json['products']['name'];
        }

        return ReviewModel.fromJson(flattenedJson);
      }).toList();

      return reviewModels;
    } catch (e) {
      throw 'Something went wrong. Please try again. Error: $e';
    }
  }

  // Get total count of reviews for pagination
  Future<int> getReviewsCount({String? searchQuery}) async {
    try {
      var query = supabase.from('reviews').select('review_id');

      // Search filtering will be done client-side for joined table queries

      final response = await query;
      return response.length;
    } catch (e) {
      throw 'Error getting reviews count: $e';
    }
  }

  // Delete a review
  Future<void> deleteReview(int reviewId) async {
    try {
      await supabase.from('reviews').delete().eq('review_id', reviewId);
    } catch (e) {
      throw 'Error deleting review: $e';
    }
  }

  // Update review status or moderate content
  Future<void> updateReview(ReviewModel review) async {
    try {
      await supabase
          .from('reviews')
          .update(review.toJson())
          .eq('review_id', review.reviewId!);
    } catch (e) {
      throw 'Error updating review: $e';
    }
  }

  // Get reviews by product
  Future<List<ReviewModel>> getReviewsByProduct(int productId) async {
    try {
      final response = await supabase.from('reviews').select('''
            *,
            customers!inner(
              customer_id,
              first_name,
              last_name,
              phone_number,
              email
            )
          ''').eq('product_id', productId).order('sent_at', ascending: false);

      return response.map((json) {
        final flattenedJson = Map<String, dynamic>.from(json);
        if (json['customers'] != null) {
          flattenedJson['customer_first_name'] =
              json['customers']['first_name'];
          flattenedJson['customer_last_name'] = json['customers']['last_name'];
          flattenedJson['customer_phone'] = json['customers']['phone_number'];
          flattenedJson['customer_email'] = json['customers']['email'];
        }
        return ReviewModel.fromJson(flattenedJson);
      }).toList();
    } catch (e) {
      throw 'Error fetching product reviews: $e';
    }
  }

  // Get reviews by customer
  Future<List<ReviewModel>> getReviewsByCustomer(int customerId) async {
    try {
      final response = await supabase.from('reviews').select('''
            *,
            products!inner(
              product_id,
              name
            )
          ''').eq('customer_id', customerId).order('sent_at', ascending: false);

      return response.map((json) {
        final flattenedJson = Map<String, dynamic>.from(json);
        if (json['products'] != null) {
          flattenedJson['product_name'] = json['products']['name'];
        }
        return ReviewModel.fromJson(flattenedJson);
      }).toList();
    } catch (e) {
      throw 'Error fetching customer reviews: $e';
    }
  }
}
