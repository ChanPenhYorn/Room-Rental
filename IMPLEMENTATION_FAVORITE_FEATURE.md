
# 🗂 Favorite Feature — Full Stack Implementation Plan (Flutter + Serverpod)

## 1. Overview

The goal is to implement a **robust, production-ready favorite system** for rooms:

* Users can toggle favorite rooms (add/remove).
* Fully safe: handles authentication, null checks, room existence, and database constraints.
* Works with **Flutter frontend** and **Serverpod backend**.
* Supports **Riverpod state management** for real-time UI updates.

---

## 2. Database

### Favorite Table

| Column  | Type               | Constraint                            |
| ------- | ------------------ | ------------------------------------- |
| id      | SERIAL             | PRIMARY KEY                           |
| user_id | INT                | REFERENCES user(id) ON DELETE CASCADE |
| room_id | INT                | REFERENCES room(id) ON DELETE CASCADE |
| UNIQUE  | (user_id, room_id) | Prevent duplicate favorites           |

**SQL Migration:**

```sql
CREATE TABLE favorite (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL REFERENCES "user"(id) ON DELETE CASCADE,
  room_id INT NOT NULL REFERENCES room(id) ON DELETE CASCADE,
  UNIQUE(user_id, room_id)
);
```

---

## 3. Serverpod Endpoint

### Endpoint: `toggleFavorite`

**Responsibilities:**

1. Check if user is authenticated (`session.authenticatedUserId`).
2. Validate that the `roomId` exists.
3. Toggle favorite: insert if not exists, delete if exists.
4. Return `true` if added, `false` if removed.

**Serverpod Implementation:**

```dart
class RoomEndpoint extends Endpoint {
  Future<bool> toggleFavorite(Session session, int roomId) async {
    final userId = session.authenticatedUserId;

    if (userId == null) {
      throw ServerpodException.forbidden('User not authenticated.');
    }

    final room = await Room.db.findById(session, roomId);
    if (room == null) {
      throw ServerpodException.notFound('Room not found.');
    }

    final existingFavorite = await Favorite.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId) & t.roomId.equals(roomId),
    );

    if (existingFavorite != null) {
      await Favorite.db.deleteRow(session, existingFavorite);
      return false;
    }

    final newFavorite = Favorite(userId: userId, roomId: roomId);
    await Favorite.db.insertRow(session, newFavorite);

    return true;
  }
}
```

---

## 4. Flutter Client

**Toggle Favorite Call:**

```dart
Future<void> toggleFavorite(int roomId) async {
  try {
    final isFavorited = await client.room.toggleFavorite(roomId);
    debugPrint('✅ Favorite toggled: $isFavorited');
  } catch (e, stack) {
    debugPrint('❌ Error toggling favorite: $e');
    debugPrint(stack.toString());
  }
}
```

---

## 5. State Management (Riverpod)

**Provider:**

```dart
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<int>>((ref) {
  return FavoritesNotifier();
});

class FavoritesNotifier extends StateNotifier<Set<int>> {
  FavoritesNotifier() : super({});

  void toggle(int roomId) async {
    try {
      final isFavorited = await client.room.toggleFavorite(roomId);
      if (isFavorited) {
        state = {...state, roomId};
      } else {
        state = state.where((id) => id != roomId).toSet();
      }
    } catch (e) {
      // Handle error if needed
    }
  }
}
```

**Notes:**

* The `Set<int>` keeps track of favorited room IDs.
* UI can listen to `favoritesProvider` for real-time updates.

---

## 6. Flutter UI Integration

* Use a **heart icon button** for favorite toggle.
* On press: call `FavoritesNotifier.toggle(roomId)`.
* Use `ConsumerWidget` or `HookConsumerWidget` to rebuild UI when state changes.

---

## 7. Testing Plan

1. **Authentication Tests**

   * Call endpoint without login → expect `Forbidden`.
   * Call endpoint with login → expect `true` or `false`.

2. **Room Validation Tests**

   * Toggle non-existent room → expect `NotFound`.

3. **Duplicate Handling Tests**

   * Toggle same room multiple times → should never crash.

4. **UI Tests**

   * Favorite icon updates immediately.
   * State remains consistent after app restart (if persisted).

---

## 8. Advantages of New Structure

* ✅ Full null safety & authentication checks.
* ✅ Prevents database crashes (unique & foreign key).
* ✅ Clean Riverpod state management.
* ✅ Scalable and easy to extend (timestamps, analytics).
* ✅ Clean separation of concerns (Serverpod handles backend logic, Flutter handles UI & state).

---

## 9. Next Steps

1. Implement migration and apply in Serverpod.
2. Replace old favorite logic in server with this new endpoint.
3. Connect Flutter Riverpod provider to UI.
4. Test thoroughly (backend + frontend).
5. Optional: Add **favorite count** and **favorite history**.
