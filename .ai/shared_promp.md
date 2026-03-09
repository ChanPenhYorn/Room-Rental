# Enhanced Opencode Command - Room Facilities Fix & Venue UI

This command fixes the empty facilities issue and implements the premium "VENUE" UI design.

## 1. Backend: Protocol & Persistence
Modify `dwellly_server/lib/src/protocol/room.spy.yaml`:
- **Add**: `facilityNames: List<String>?, persist=false`

Modify `dwellly_server/lib/src/endpoints/room_endpoint.dart`:
- **Update `createRoom`**:
  ```dart
  final createdRoom = await Room.db.insertRow(session, room);
  if (room.facilityNames != null) {
    for (final name in room.facilityNames!) {
      var facility = await Facility.db.findFirstRow(session, where: (t) => t.name.equals(name));
      if (facility == null) {
        facility = await Facility.db.insertRow(session, Facility(name: name, icon: 'check'));
      }
      await RoomFacility.db.insertRow(session, RoomFacility(roomId: createdRoom.id!, facilityId: facility.id!));
    }
  }
  ```
- **Update `getRooms`, `getMyRooms`, etc.**: Add `facilities: RoomFacility.includeList(include: RoomFacility.include(facility: Facility.include()))` to the `include` block.

## 2. Frontend: Property Wizard
Modify `dwellly_flutter/lib/features/property_management/presentation/screens/add_property_wizard_screen.dart`:
- **Submission**: In `_submitProperty`, add `facilityNames: _selectedFacilities` to the `Room` object.
- **Location**: Use `_latitude` and `_longitude` from the map picker.

## 3. Frontend: Room Detail Venue UI
Modify `dwellly_flutter/lib/features/listings/presentation/screens/room_detail_screen.dart`:
- **[NEW] Venue Section**: Add before the "Reviews" section.
- **Header**: "VENUE" (Bold), "Get Direction ->" (Link).
- **Map**: Rounded `GoogleMap` (lite mode) with a pin at `room.latitude/longitude`.
- **Positioning**: Ensure it's correctly placed on top of reviews.

## 4. General (Existing)
Maintain previously implemented:
- Chat scrolling & deep-link fixes.
- Context-aware notification suppression.
- Backend filtering for chat notifications.
