import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dwellly_client/room_rental_client.dart';
import '../../data/repositories/review_repository.dart';

final roomReviewsProvider =
    AsyncNotifierProvider.family<RoomReviewsController, List<Review>, int>(
      RoomReviewsController.new,
    );

class RoomReviewsController extends FamilyAsyncNotifier<List<Review>, int> {
  late ReviewRepository _repository;

  @override
  Future<List<Review>> build(int arg) async {
    _repository = ref.watch(reviewRepositoryProvider);
    return _fetchReviews();
  }

  Future<List<Review>> _fetchReviews() async {
    return await _repository.getReviewsForRoom(arg);
  }

  Future<void> submitReview(int rating, String comment) async {
    state = const AsyncValue.loading();
    try {
      final newReview = Review(
        roomId: arg,
        userId: 0, // Gets set by backend securely via session
        rating: rating,
        comment: comment,
        createdAt: DateTime.now(), // Gets rewritten by backend
      );

      await _repository.submitReview(newReview);

      // Refresh the reviews list and rebuild
      state = AsyncValue.data(await _fetchReviews());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
