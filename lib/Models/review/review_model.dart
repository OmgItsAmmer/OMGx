class ReviewModel {
  int? reviewId; // Nullable, auto-incremented in DB
  final int? productId; // Foreign key to products table
  final DateTime sentAt; // Timestamp with time zone, defaults to now()
  final String? review; // Text field, defaults to empty string
  final double? rating; // Numeric field, constrained to 1-5 range
  final int? customerId; // Foreign key to customers table

  // Additional fields from joined tables
  final String? customerFirstName;
  final String? customerLastName;
  final String? customerPhone;
  final String? customerEmail;
  final String? productName;

  ReviewModel({
    this.reviewId,
    this.productId,
    required this.sentAt,
    this.review,
    this.rating,
    this.customerId,
    this.customerFirstName,
    this.customerLastName,
    this.customerPhone,
    this.customerEmail,
    this.productName,
  });

  // Static function to create an empty review model
  static ReviewModel empty() => ReviewModel(
        reviewId: null,
        productId: null,
        sentAt: DateTime.now(),
        review: '',
        rating: null,
        customerId: null,
        customerFirstName: null,
        customerLastName: null,
        customerPhone: null,
        customerEmail: null,
        productName: null,
      );

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson({bool isInsert = false}) {
    final Map<String, dynamic> data = {
      'product_id': productId,
      'sent_at': sentAt.toIso8601String(),
      'review': review ?? '',
      'rating': rating,
      'customer_id': customerId,
    };

    if (!isInsert) {
      if (reviewId != null) {
        data['review_id'] = reviewId;
      }
    }

    return data;
  }

  // Factory method to create a ReviewModel from Supabase response
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      reviewId: json['review_id'] as int?,
      productId: json['product_id'] as int?,
      sentAt: json['sent_at'] != null
          ? DateTime.parse(json['sent_at'] as String)
          : DateTime.now(),
      review: json['review'] as String? ?? '',
      rating:
          json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      customerId: json['customer_id'] as int?,
      customerFirstName: json['customer_first_name'] as String?,
      customerLastName: json['customer_last_name'] as String?,
      customerPhone: json['customer_phone'] as String?,
      customerEmail: json['customer_email'] as String?,
      productName: json['product_name'] as String?,
    );
  }

  // Static method to create a list of ReviewModel from a JSON list
  static List<ReviewModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ReviewModel.fromJson(json)).toList();
  }

  // Method to validate rating range (1-5)
  bool get isValidRating {
    if (rating == null) return true; // Null is valid
    return rating! >= 1.0 && rating! <= 5.0;
  }

  // Method to validate review text (no special characters)
  bool get isValidReview {
    if (review == null || review!.isEmpty) return true; // Empty is valid
    return !RegExp(r'[;<>]', caseSensitive: false).hasMatch(review!);
  }

  // Method to get rating as stars (for UI display)
  int get ratingStars {
    if (rating == null) return 0;
    return rating!.round();
  }

  // Method to get formatted review text
  String get formattedReview {
    return review ?? '';
  }

  // Method to get formatted date
  String get formattedDate {
    return '${sentAt.day}/${sentAt.month}/${sentAt.year}';
  }

  // Getter for customer full name
  String get customerFullName {
    if (customerFirstName != null && customerLastName != null) {
      return '$customerFirstName $customerLastName'.trim();
    }
    return customerFirstName ?? customerLastName ?? 'Unknown Customer';
  }

  // Copy with method for creating modified instances
  ReviewModel copyWith({
    int? reviewId,
    int? productId,
    DateTime? sentAt,
    String? review,
    double? rating,
    int? customerId,
    String? customerFirstName,
    String? customerLastName,
    String? customerPhone,
    String? customerEmail,
    String? productName,
  }) {
    return ReviewModel(
      reviewId: reviewId ?? this.reviewId,
      productId: productId ?? this.productId,
      sentAt: sentAt ?? this.sentAt,
      review: review ?? this.review,
      rating: rating ?? this.rating,
      customerId: customerId ?? this.customerId,
      customerFirstName: customerFirstName ?? this.customerFirstName,
      customerLastName: customerLastName ?? this.customerLastName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      productName: productName ?? this.productName,
    );
  }

  // Equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReviewModel &&
        other.reviewId == reviewId &&
        other.productId == productId &&
        other.sentAt == sentAt &&
        other.review == review &&
        other.rating == rating &&
        other.customerId == customerId &&
        other.customerFirstName == customerFirstName &&
        other.customerLastName == customerLastName &&
        other.customerPhone == customerPhone &&
        other.customerEmail == customerEmail &&
        other.productName == productName;
  }

  // Hash code
  @override
  int get hashCode {
    return reviewId.hashCode ^
        productId.hashCode ^
        sentAt.hashCode ^
        review.hashCode ^
        rating.hashCode ^
        customerId.hashCode ^
        customerFirstName.hashCode ^
        customerLastName.hashCode ^
        customerPhone.hashCode ^
        customerEmail.hashCode ^
        productName.hashCode;
  }

  // String representation
  @override
  String toString() {
    return 'ReviewModel(reviewId: $reviewId, productId: $productId, sentAt: $sentAt, review: $review, rating: $rating, customerId: $customerId, customerFullName: $customerFullName, productName: $productName)';
  }
}
