import 'dart:math';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import '../generated/protocol.dart';
import 'cloudinary_service.dart';

class DataSeeder {
  static const khmer24Images = [
    'https://images.khmer24.co/26-01-21/studio-room-for-rent-near-chip-mong-271-megamall-693454176901179948745578-c.jpg',
    'https://images.khmer24.co/24-05-10/293957-studio-room-for-rent-at-toul-tom-pong-1715324381-62765694-b.jpg',
    'https://images.khmer24.co/25-12-23/room-for-rent-448357176648161396662042-b.jpg',
    'https://images.khmer24.co/26-02-03/room-for-rent-448357177009087965548499-b.jpg',
    'https://images.khmer24.co/25-11-25/room-for-rent-120-month-152895176406326715864780-b.jpg',
    'https://images.khmer24.co/26-01-01/-ud83c-udf40nice-studio-room-for-rent-at-bkk3-929268176723878864774171-d.jpg',
    'https://images.khmer24.co/24-01-18/137037-ttp-area-clean-studio-room-for-rent-nearby-russian-market-1705556357-15954821-d.jpg',
    'https://images.khmer24.co/26-01-20/lovely-studio-room-for-rent-near-new-air-port-ud83c-udf40-293957176889325848915191-f.jpg',
    'https://images.khmer24.co/25-12-23/room-for-rent-448357176648129969127821-b.jpg',
    'https://images.khmer24.co/25-02-24/studio-room-for-rent-650367174037903549201819-b.jpg',
    'https://images.khmer24.co/25-09-04/-ud83c-udf38modern-studio-room-for-rent-bkk3-phnom-penh-293957175695181343425642-b.jpg',
    'https://images.khmer24.co/25-12-23/room-for-rent-448357176648161453629633-c.jpg',
    'https://images.khmer24.co/26-01-21/s-studio-room-for-rent-near-chip-mong-271-megamall-693454176901179820810629-b.jpg',
    'https://images.khmer24.co/25-12-30/room-for-rent-655855176707518996645851-b.jpg',
    'https://images.khmer24.co/25-12-10/best-one-bedroom-for-rent-at-urban-village-929268176535032314881491-e.jpg',
  ];

  static Future<void> seed(Session session, {bool force = false}) async {
    // Check for existing data first
    final userCountResult = await session.db.unsafeSimpleQuery(
      'SELECT COUNT(*) FROM serverpod_user_info',
    );
    final int userCount = int.parse(userCountResult.first[0].toString());
    final bool hasExistingData = userCount > 0;

    if (!force && hasExistingData) {
      session.log(
        'ℹ️ Data already exists. Skipping seeding (use force=true to regenerate).',
      );
      return;
    }

    session.log(
      force
          ? '🌱 Force regenerating data (Wiping existing data)...'
          : '🌱 Starting data seeding (Database empty)...',
    );

    // Wipe data in correct order to respect foreign keys
    await session.db.unsafeSimpleQuery('DELETE FROM room');
    await session.db.unsafeSimpleQuery('DELETE FROM "user"');
    await session.db.unsafeSimpleQuery(
      'DELETE FROM serverpod_auth_idp_email_account',
    );
    await session.db.unsafeSimpleQuery('DELETE FROM serverpod_auth_core_user');
    await session.db.unsafeSimpleQuery('DELETE FROM serverpod_user_info');
    await session.db.unsafeSimpleQuery(
      'DELETE FROM serverpod_auth_core_profile',
    );

    User? owner;

    session.log('Seeding default owner account...');
    await _seedUser(
      session,
      email: 'chanpenh@example.com',
      password: 'password123',
      fullName: 'Default Owner',
      role: UserRole.owner,
    );

    final newlyCreatedUserInfo = await Users.findUserByEmail(
      session,
      'chanpenh@example.com',
    );

    if (newlyCreatedUserInfo != null) {
      owner = await User.db.findFirstRow(
        session,
        where: (u) => u.userInfoId.equals(newlyCreatedUserInfo.id!),
      );
    }

    if (owner != null) {
      await _seedRooms(session, owner);
    } else {
      session.log(
        '⚠️ Failed to identify or create an owner for room seeding.',
        level: LogLevel.error,
      );
    }

    session.log('✅ Data seeding completed.');
  }

  static Future<void> _seedRooms(Session session, User owner) async {
    final count = await Room.db.count(session);
    if (count >= 50) {
      session.log('Skipping room seeding, already have $count rooms.');
      return;
    }

    session.log('Seeding 50 rooms for owner ${owner.id}...');
    final random = Random();
    final cloudinary = CloudinaryService(session);

    // Prepare uploaded images once to avoid redundant uploads
    final uploadedImageUrls = <String>[];
    session.log('Syncing ${khmer24Images.length} images to Cloudinary...');

    for (var i = 0; i < khmer24Images.length; i++) {
      final source = khmer24Images[i];
      final publicId = 'room_rental_seed_$i';

      // Try to upload to Cloudinary
      final response = await cloudinary.uploadImage(
        session,
        source,
        folder: 'room_rental',
        publicId: publicId,
      );

      if (response != null && response.isSuccessful) {
        session.log('✅ Uploaded/Synced: $publicId');
        uploadedImageUrls.add(response.secureUrl!);
      } else {
        session.log(
          '❌ Skipping broken source: $source',
          level: LogLevel.warning,
        );
      }
    }

    if (uploadedImageUrls.isEmpty) {
      session.log(
        '⚠️ Critical: No images successfully synced to Cloudinary.',
        level: LogLevel.error,
      );
      return;
    }

    // Realistic Phnom Penh Locations based on Khmer24 data
    final locations = [
      {'name': 'Chbar Ampov, Phnom Penh', 'lat': 11.5218, 'lng': 104.9351},
      {
        'name': 'Tonle Basak, Chamkar Mon, Phnom Penh',
        'lat': 11.5511,
        'lng': 104.9318,
      },
      {'name': 'Russey Keo, Phnom Penh', 'lat': 11.5947, 'lng': 104.8988},
      {'name': 'Boeng Keng Kang, Phnom Penh', 'lat': 11.5524, 'lng': 104.9242},
      {'name': 'Sen Sok, Phnom Penh', 'lat': 11.5833, 'lng': 104.8833},
      {
        'name': 'Toul Sangke, Russey Keo, Phnom Penh',
        'lat': 11.6033,
        'lng': 104.8978,
      },
    ];

    final roomData = [
      {
        'title': 'Large Room for rent at Chbar Ampov',
        'type': RoomType.apartment1br,
        'basePrice': 110,
        'description':
            'Large Room for rent at Chbar Ampov- បន្ទប់ជួលនៅច្បារអំពៅ. Located in a convenient area with good access to local markets and services.',
      },
      {
        'title': 'Studio room for rent - Phnom Penh',
        'type': RoomType.studio,
        'basePrice': 550,
        'description':
            'Modern studio room for rent. Posted by Condo Apartment Service. Features high-quality furnishings and is situated in the heart of the city.',
      },
      {
        'title': 'Ground floor room with mezzanine (បន្ទប់ជួលជាន់ផ្ទាល់ដី)',
        'type': RoomType.apartment1br,
        'basePrice': 120,
        'description':
            'Ground floor room featuring a mezzanine (meul). This unit is newly available and suitable for individuals or small families looking for an affordable living space.',
      },
      {
        'title': 'Cozy studio room for rent in Phnom Penh',
        'type': RoomType.studio,
        'basePrice': 450,
        'description':
            'A cozy and fully furnished studio room perfect for expatriates or professionals. Located in a safe and quiet neighborhood.',
      },
      {
        'title': 'Room Near AEON 2 & TK Avenue',
        'type': RoomType.house,
        'basePrice': 150,
        'description':
            'Conveniently located room near AEON Mall 2 and TK Avenue. Easy access to shopping, dining, and entertainment venues.',
      },
      {
        'title': 'Rental Rooms - បន្ទប់ជួលក្នុងផ្សារ (Toul Sangke Camko)',
        'type': RoomType.dormitory,
        'basePrice': 65,
        'description':
            'Affordable rental rooms located directly within the Toul Sangke market area. Ideal for those working nearby who need budget-friendly accommodation.',
      },
    ];

    for (var i = 0; i < 50; i++) {
      final loc = locations[random.nextInt(locations.length)];
      final data = roomData[random.nextInt(roomData.length)];

      // Randomize coordinates slightly around the area center
      final lat = (loc['lat'] as double) + (random.nextDouble() - 0.5) * 0.01;
      final lng = (loc['lng'] as double) + (random.nextDouble() - 0.5) * 0.01;

      final price = (data['basePrice'] as int) + random.nextInt(100) - 50;

      // Select an image from our uploaded list (rotating)
      final mainImageUrl = uploadedImageUrls[i % uploadedImageUrls.length];
      final secondaryImages = [
        uploadedImageUrls[(i + 1) % uploadedImageUrls.length],
        uploadedImageUrls[(i + 2) % uploadedImageUrls.length],
      ];

      await Room.db.insertRow(
        session,
        Room(
          ownerId: owner.id!,
          title: '${data['title']}',
          description:
              data['description'] as String? ??
              'Experience comfortable living in ${loc['name']}. This property features modern amenities, great security, and convenient access to local shops and restaurants.',
          price: price.toDouble(),
          location: loc['name'] as String,
          latitude: lat,
          longitude: lng,
          rating: (random.nextInt(20) + 30) / 10.0, // 3.0 to 5.0
          type: data['type'] as RoomType,
          isAvailable: random.nextBool(),
          createdAt: DateTime.now().subtract(
            Duration(days: random.nextInt(30)),
          ),
          status: RoomStatus.approved,
          images: secondaryImages,
          imageUrl: mainImageUrl,
          facilities: [],
          bookings: [],
          favorites: [],
          reviews: [],
        ),
      );
    }
    session.log('Seeded 50 rooms.');
  }

  static Future<void> _seedUser(
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
      session.log('Generated hash for $email: $passwordHash');

      // Step 1: Create auth core user
      final authUserResult = await session.db.unsafeSimpleQuery(
        '''
        INSERT INTO serverpod_auth_core_user (id, "createdAt", "scopeNames", blocked)
        VALUES (gen_random_uuid_v7(), NOW(), '[]', false)
        RETURNING id::text
        ''',
      );

      final authUserId = authUserResult.first[0] as String;
      session.log('Created auth core user with ID: $authUserId');

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

      // Step 4: Create Legacy UserInfo (still needed for User table relation)
      // We use Emails.createUser just to get it done quickly, then clean up its extra side effects
      await Emails.createUser(session, fullName, email, password);

      // Clean up the legacy email auth created by Emails.createUser (we use the new one)
      await session.db.unsafeSimpleQuery(
        'DELETE FROM serverpod_email_auth WHERE email = \'$email\'',
      );

      final userInfoResult = await session.db.unsafeSimpleQuery(
        'SELECT id FROM serverpod_user_info WHERE email = \'$email\'',
      );

      if (userInfoResult.isEmpty) {
        session.log('Failed to get userInfo for $email', level: LogLevel.error);
        return;
      }

      final userInfoId = userInfoResult.first[0] as int;
      session.log('UserInfo ID: $userInfoId');

      // Step 6: Create the custom user profile
      await User.db.insertRow(
        session,
        User(
          userInfoId: userInfoId,
          fullName: fullName,
          role: role,
          createdAt: DateTime.now(),
        ),
      );

      session.log('Successfully created user and profile for $email');
    } catch (e, stack) {
      session.log(
        'Error creating user $email: $e',
        level: LogLevel.error,
        stackTrace: stack,
      );
    }
  }
}
