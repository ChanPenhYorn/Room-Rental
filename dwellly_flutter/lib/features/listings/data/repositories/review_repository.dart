import 'package:dwellly_client/room_rental_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client_provider.dart';

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  return ReviewRepositoryImpl(client);
});

abstract class ReviewRepository {
  Future<List<Review>> getReviewsForRoom(int roomId);
  Future<Review?> submitReview(Review review);
}

class ReviewRepositoryImpl implements ReviewRepository {
  final Client _client;

  ReviewRepositoryImpl(this._client);

  @override
  Future<List<Review>> getReviewsForRoom(int roomId) async {
    try {
      return await _client.review.getReviewsForRoom(roomId);
    } catch (e) {
      throw Exception('Failed to fetch reviews: $e');
    }
  }

  @override
  Future<Review?> submitReview(Review review) async {
    try {
      return await _client.review.submitReview(review);
    } catch (e) {
      throw Exception('Failed to submit review: $e');
    }
  }
}
