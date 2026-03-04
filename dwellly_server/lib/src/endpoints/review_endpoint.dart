import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../utils/user_utils.dart';

class ReviewEndpoint extends Endpoint {
  /// Fetch all reviews for a specific room, ordered by newest first
  Future<List<Review>> getReviewsForRoom(Session session, int roomId) async {
    return await Review.db.find(
      session,
      where: (t) => t.roomId.equals(roomId),
      include: Review.include(
        user: User.include(),
      ),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Submit a new review or update an existing one for a room by the current user
  Future<Review?> submitReview(Session session, Review review) async {
    final user = await UserUtils.getOrCreateUser(session);
    if (user == null || user.id == null) return null;

    final roomId = review.roomId;

    // Check if the user already reviewed this room
    final existingReviews = await Review.db.find(
      session,
      where: (t) => t.roomId.equals(roomId) & t.userId.equals(user.id!),
    );

    Review savedReview;
    if (existingReviews.isNotEmpty) {
      // Update existing review
      final existingReview = existingReviews.first;
      existingReview.rating = review.rating;
      existingReview.comment = review.comment;
      savedReview = await Review.db.updateRow(session, existingReview);
    } else {
      // Create new review
      review.userId = user.id!;
      review.createdAt = DateTime.now();
      savedReview = await Review.db.insertRow(session, review);
    }

    // Recalculate average rating for the room
    await _updateRoomAverageRating(session, roomId);

    // Return the saved review with user info populated for the frontend
    return await Review.db.findById(
      session,
      savedReview.id!,
      include: Review.include(user: User.include()),
    );
  }

  /// Recalculates and updates the average rating on a Room
  Future<void> _updateRoomAverageRating(Session session, int roomId) async {
    final reviews = await Review.db.find(
      session,
      where: (t) => t.roomId.equals(roomId),
    );

    if (reviews.isEmpty) return;

    double totalRating = 0.0;
    for (var r in reviews) {
      totalRating += r.rating;
    }
    final avgRating = totalRating / reviews.length;

    // Update the room's rating column
    final room = await Room.db.findById(session, roomId);
    if (room != null) {
      room.rating = avgRating;
      await Room.db.updateRow(session, room);
    }
  }
}
