# Dwellly App - Quick Start Guide

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.32.0+
- Dart SDK 3.8.0+
- PostgreSQL (running locally or via Docker)
- Serverpod CLI 3.3.0

### 1. Start the Backend Server

The Serverpod backend is **currently running** on:
- **API Server**: http://localhost:8080
- **Web Server**: http://localhost:8082

To stop and restart:
```bash
# Stop: Press Ctrl+C in the server terminal

# Start:
cd room_rental_server
dart bin/main.dart
```

### 2. Run the Flutter App

Open a new terminal and run:
```bash
cd room_rental_flutter
flutter run
```

Or for a specific device:
```bash
flutter run -d chrome        # Web
flutter run -d macos         # macOS
flutter run -d <device-id>   # iOS/Android
```

## 📱 App Features

### Home Screen
- **Location Selector**: Tap to change location (Jakarta, Indonesia)
- **Search Bar**: Search for apartments, houses, etc.
- **Category Filters**: All, Apartment, House, Villa, Cottage
- **Premium Listings**: Horizontal scrollable premium rooms
- **Near You**: Vertical list of nearby properties
- **Bottom Navigation**: Home, Saved, Bookings, Profile

### Room Details
- **Hero Image**: Swipeable image carousel
- **Room Info**: Name, location, rating, price
- **Amenities**: WiFi, AC, Kitchen, Parking, etc.
- **Description**: Full property description
- **Book Now**: Sticky bottom CTA button

## 🎨 Design System

### Colors (Figma Spec)
```dart
Primary Green:    #55B97D  // Buttons, ratings, accents
Secondary Green:  #E8F5EE  // Chip backgrounds
Primary Black:    #1A1A1A  // Headings, text
Secondary Gray:   #757575  // Secondary text
Surface White:    #FFFFFF  // Backgrounds
Divider Gray:     #F5F5F5  // Input fields
```

### Typography
- **Font**: Google Fonts - Outfit
- **Headline Large**: 24px Bold
- **Headline Small**: 20px Bold
- **Body**: 16px Regular
- **Labels**: 12px Medium

## 🔧 Development Commands

### Backend (Serverpod)

```bash
# Generate protocol code
cd room_rental_server
serverpod generate

# Create new migration
serverpod create-migration

# Apply migrations
dart bin/main.dart --apply-migrations

# Start server
dart bin/main.dart
```

### Frontend (Flutter)

```bash
cd room_rental_flutter

# Get dependencies
flutter pub get

# Generate code (Riverpod, Freezed, JSON)
dart run build_runner build --delete-conflicting-outputs

# Watch for changes (auto-generate)
dart run build_runner watch

# Run app
flutter run

# Build for production
flutter build apk          # Android
flutter build ios          # iOS
flutter build web          # Web
flutter build macos        # macOS
```

## 📊 Current Mock Data

The app displays **3 premium listings**:

1. **Modern Studio in Downtown**
   - Price: $120/month
   - Location: Downtown, Metro City
   - Rating: 4.8⭐
   - Amenities: WiFi, AC, Kitchen

2. **Cozy Family Apartment**
   - Price: $250/month
   - Location: Suburbs, Green Valley
   - Rating: 4.9⭐
   - Amenities: Garden, Parking, WiFi

3. **Luxury Penthouse**
   - Price: $550/month
   - Location: Skyline District
   - Rating: 5.0⭐
   - Amenities: Pool, Gym, Concierge, WiFi

## 🗂️ Project Structure

```
room_rental/
├── room_rental_server/          # Serverpod backend
│   ├── lib/src/
│   │   ├── endpoints/           # API endpoints
│   │   ├── protocol/            # Data models (.spy.yaml)
│   │   └── generated/           # Generated code
│   └── bin/main.dart            # Server entry point
│
├── room_rental_flutter/         # Flutter app
│   ├── lib/
│   │   ├── core/                # Theme, network, utils
│   │   ├── features/            # Feature modules
│   │   │   └── listings/
│   │   │       ├── data/        # Repositories
│   │   │       ├── domain/      # Entities, interfaces
│   │   │       └── presentation/# UI, providers
│   │   ├── shared/              # Reusable widgets
│   │   └── main.dart            # App entry point
│   └── assets/
│       └── config.json          # API configuration
│
└── room_rental_client/          # Generated Serverpod client
```

## 🐛 Troubleshooting

### Port Already in Use
If you see "Address already in use" error:

```bash
# Find process using port 8080
lsof -i :8080

# Kill the process (replace PID)
kill -9 <PID>

# Restart server
dart bin/main.dart
```

### Build Runner Issues
```bash
# Clean and rebuild
flutter clean
flutter pub get
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### Database Connection Issues
Ensure PostgreSQL is running:
```bash
# Check status
pg_ctl status

# Start PostgreSQL
pg_ctl start

# Or using Docker
docker start serverpod-postgres
```

## 📝 Next Steps

### Immediate Tasks
1. ✅ Backend running on localhost:8080
2. ✅ Flutter app configured with theme
3. ✅ Mock data displaying in UI
4. ⏳ Run `flutter run` to test the app

### Feature Development
1. Implement authentication (login/signup)
2. Add booking functionality
3. Implement favorites/saved rooms
4. Add search and filters
5. Create map view with markers
6. Build chat/messaging feature
7. Add user profile management

### Production Readiness
1. Write unit and widget tests
2. Set up CI/CD pipeline
3. Configure environment variables
4. Add error tracking (Sentry)
5. Implement analytics
6. Optimize images and assets
7. Add offline support

## 🎯 Testing the App

### Expected Behavior
1. **Launch**: App opens to Home Screen
2. **Loading**: Shows loading indicator while fetching rooms
3. **Display**: Shows 3 room cards with images, names, prices
4. **Tap Card**: Navigates to Room Detail Screen
5. **Detail View**: Shows full room information
6. **Back**: Returns to Home Screen

### Verify Design
- ✅ Green color (#55B97D) on buttons and ratings
- ✅ Outfit font throughout
- ✅ Rounded corners (16px cards, 30px buttons)
- ✅ Rating badge on top-left of cards
- ✅ Favorite heart on top-right
- ✅ Smooth navigation transitions

## 📞 Support

For issues or questions:
1. Check `IMPLEMENTATION_SUMMARY.md` for architecture details
2. Review `flutter_clean_architecture_riverpod.md` for patterns
3. Consult Serverpod docs: https://docs.serverpod.dev

---

**Status**: ✅ Ready to Run
**Backend**: 🟢 Running on http://localhost:8080
**Next**: Run `flutter run` in room_rental_flutter directory
