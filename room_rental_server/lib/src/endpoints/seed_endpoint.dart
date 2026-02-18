import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import '../generated/protocol.dart';

class SeedEndpoint extends Endpoint {
  @override
  bool get requireLogin => false;

  Future<bool> seedData(Session session) async {
    // Check if data already exists
    final roomCount = await Room.db.count(session);
    if (roomCount > 0) return false;

    // 1. Create a UserInfo for the demo user (required for foreign key)
    final userInfo = UserInfo(
      userIdentifier: 'demo-owner',
      userName: 'demo_owner',
      fullName: 'Demo Owner',
      created: DateTime.now(),
      scopeNames: [],
      blocked: false,
    );
    final insertedUserInfo = await UserInfo.db.insertRow(session, userInfo);

    // 2. Create Demo User
    final demoUser = User(
      userInfoId: insertedUserInfo.id!,
      fullName: 'Demo Owner',
      role: UserRole.owner,
      createdAt: DateTime.now(),
      phone: '+123456789',
    );
    final user = await User.db.insertRow(session, demoUser);

    // 3. Create Facilities
    final facilityData = [
      {'name': 'WiFi', 'icon': 'wifi'},
      {'name': 'Kitchen', 'icon': 'kitchen'},
      {'name': 'AC', 'icon': 'ac_unit'},
      {'name': 'Parking', 'icon': 'local_parking'},
      {'name': 'Pool', 'icon': 'pool'},
      {'name': 'Gym', 'icon': 'fitness_center'},
      {'name': 'Laundry', 'icon': 'local_laundry_service'},
    ];

    final facilities = <Facility>[];
    for (final data in facilityData) {
      final f = await Facility.db.insertRow(
        session,
        Facility(
          name: data['name']!,
          icon: data['icon']!,
        ),
      );
      facilities.add(f);
    }

    // 4. Create Rooms
    final roomsData = [
      {
        'title': 'Modern Studio in DHA',
        'desc': 'A beautiful studio apartment with all amenities.',
        'price': 450.0,
        'loc': 'DHA Phase 5, Lahore',
        'type': RoomType.studio,
        'f': [0, 1, 2, 3],
      },
      {
        'title': 'Luxury Suite',
        'desc': 'Experience luxury living in the heart of the city.',
        'price': 600.0,
        'loc': 'Model Town, Lahore',
        'type': RoomType.apartment1br,
        'f': [0, 1, 2, 3, 4, 5],
      },
      {
        'title': 'Cozy Room near University',
        'desc': 'Perfect for students, walking distance to campus.',
        'price': 250.0,
        'loc': 'Johar Town, Lahore',
        'type': RoomType.dormitory,
        'f': [0, 6],
      },
    ];

    for (var data in roomsData) {
      final room = Room(
        ownerId: user.id!,
        title: data['title'] as String,
        description: data['desc'] as String,
        price: data['price'] as double,
        location: data['loc'] as String,
        latitude: 31.5204,
        longitude: 74.3587,
        rating: 4.5,
        type: data['type'] as RoomType,
        isAvailable: true,
        createdAt: DateTime.now(),
        status: RoomStatus.approved,
        imageUrl: 'https://picsum.photos/seed/${data['title']}/800/600',
        images: [
          'https://picsum.photos/seed/${data['title']}1/800/600',
          'https://picsum.photos/seed/${data['title']}2/800/600',
        ],
      );
      final insertedRoom = await Room.db.insertRow(session, room);

      // Link facilities
      final facilityIndices = data['f'] as List<int>;
      for (var idx in facilityIndices) {
        await RoomFacility.db.insertRow(
          session,
          RoomFacility(
            roomId: insertedRoom.id!,
            facilityId: facilities[idx].id!,
          ),
        );
      }

      // Add a dummy review
      await Review.db.insertRow(
        session,
        Review(
          roomId: insertedRoom.id!,
          userId: user.id!,
          rating: 5,
          comment: 'Excellent place to stay!',
          createdAt: DateTime.now(),
        ),
      );
    }

    return true;
  }
}
