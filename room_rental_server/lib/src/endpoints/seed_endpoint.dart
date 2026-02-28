import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import '../generated/protocol.dart';

class SeedEndpoint extends Endpoint {
  @override
  bool get requireLogin => false;

  Future<bool> seedData(Session session) async {
    // Check if data already exists to avoid throwing duplicate unique key errors on forced seeds.
    final existingAdmin = await UserInfo.db.findFirstRow(
      session,
      where: (t) => t.userIdentifier.equals('admin2@roomrental.com'),
    );

    if (existingAdmin == null) {
      // 1. Create a UserInfo and Authentication for Demo Owner
      var ownerUser = await _seedUser(
        session,
        email: 'owner2@roomrental.com',
        password: 'password',
        fullName: 'Demo Owner',
        role: UserRole.owner,
      );

      // 2. Create a UserInfo and Authentication for Demo Admin
      var adminUser = await _seedUser(
        session,
        email: 'admin2@roomrental.com',
        password: 'password',
        fullName: 'Demo Admin',
        role: UserRole.admin,
      );

      if (ownerUser != null && adminUser != null) {
        // 5. Create Facilities (Only if admin wasn't found, assuming DB is mostly empty)
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

        // 6. Create Rooms for the Owner
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
            ownerId: ownerUser.id!,
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
              userId: ownerUser.id!,
              rating: 5,
              comment: 'Excellent place to stay!',
              createdAt: DateTime.now(),
            ),
          );
        }
      }
    }
    return true;
  }

  Future<User?> _seedUser(
    Session session, {
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
  }) async {
    try {
      final pepper = session.passwords['emailSecretHashPepper'] ?? '';
      final hasher = Argon2HashUtil(
        hashPepper: pepper,
        hashSaltLength: 16,
        parameters: Argon2HashParameters(memory: 19456),
      );
      final passwordHash = await hasher.createHashFromString(secret: password);

      // Step 1: Create auth core user
      final authUserResult = await session.db.unsafeSimpleQuery(
        '''
        INSERT INTO serverpod_auth_core_user (id, "createdAt", "scopeNames", blocked)
        VALUES (gen_random_uuid_v7(), NOW(), '[]', false)
        RETURNING id::text
        ''',
      );

      final authUserId = authUserResult.first[0] as String;

      // Step 2: Create core profile
      await session.db.unsafeSimpleQuery(
        '''
        INSERT INTO serverpod_auth_core_profile (id, "authUserId", email, "fullName", "userName", "createdAt")
        VALUES (gen_random_uuid_v7(), '$authUserId', '$email', '$fullName', '$email', NOW())
        ''',
      );

      // Step 3: Insert into new email account table
      await session.db.unsafeSimpleQuery(
        '''
        INSERT INTO serverpod_auth_idp_email_account (id, "authUserId", "createdAt", email, "passwordHash")
        VALUES (gen_random_uuid_v7(), '$authUserId', NOW(), '$email', '$passwordHash')
        ''',
      );

      // Step 4: Create Legacy UserInfo
      await Emails.createUser(session, fullName, email, password);

      // Clean up the legacy email auth created by Emails.createUser
      await session.db.unsafeSimpleQuery(
        'DELETE FROM serverpod_email_auth WHERE email = \'$email\'',
      );

      final userInfoResult = await session.db.unsafeSimpleQuery(
        'SELECT id FROM serverpod_user_info WHERE email = \'$email\'',
      );

      if (userInfoResult.isEmpty) {
        return null;
      }

      final userInfoId = userInfoResult.first[0] as int;

      // Step 6: Create the custom user profile
      final user = await User.db.insertRow(
        session,
        User(
          userInfoId: userInfoId,
          authUserId: authUserId, // Link the new IDP UUID to this User record
          fullName: fullName,
          role: role,
          createdAt: DateTime.now(),
        ),
      );

      return user;
    } catch (e) {
      session.log(
        'Error creating user $email: $e',
        level: LogLevel.error,
      );
      return null;
    }
  }
}
