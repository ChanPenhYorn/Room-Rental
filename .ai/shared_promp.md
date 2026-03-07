# Enhanced Opencode Command: Fix Scroll to Bottom Button

Execute the following changes to improve the reliability of the "scroll to bottom" button in the chat detail screen.

## 1. Refine Scroll Listener Logic
File: `lib/features/social/presentation/screens/chat_detail_screen.dart`

**Target Code Block (approx. lines 810-853):**
The current `NotificationListener<ScrollNotification>` has logic that hides the button too aggressively (on `ScrollEndNotification`).

**Requested Changes:**
- In the `onNotification` callback:
    - Update `_showScrollDownButton` based on **`notification.metrics.extentAfter`**.
    - If `notification.metrics.extentAfter > 100`, then `_showScrollDownButton = true`.
    - If `notification.metrics.extentAfter <= 0` (user is at the very bottom), then `_showScrollDownButton = false`.
    - **CRITICAL**: Remove the `else if (notification is ScrollEndNotification)` block that forces `_showScrollDownButton = false;`. The button should stay visible even when scrolling ends, as long as the user hasn't reached the bottom.
    - Ensure `_showFloatingPill` and `_currentFloatingDate` logic remains intact.

**Revised Logic Sketch:**
```dart
onNotification: (notification) {
  // Update button visibility based on distance from bottom
  final double extentAfter = notification.metrics.extentAfter;
  
  if (extentAfter > 100) {
    if (!_showScrollDownButton) setState(() => _showScrollDownButton = true);
  } else if (extentAfter <= 0) {
    if (_showScrollDownButton) setState(() => _showScrollDownButton = false);
  }

  // Floating date pill logic...
  if (notification is ScrollStartNotification || notification is ScrollUpdateNotification) {
     setState(() { _showFloatingPill = true; });
     // ... calculate foundDate ...
  } else if (notification is ScrollEndNotification) {
     // ... timer to hide _showFloatingPill ...
  }
  return false;
}
```

## 2. Verification
- Verify that scrolling up makes the button appear.
- Verify that the button stays visible when the user stops scrolling in the middle of the chat.
- Verify that scrolling all the way to the last message makes the button disappear.
- Verify that clicking the button (which calls `_scrollToBottom`) correctly hides the button once the animation finishes.
