# Server Status & Troubleshooting Guide

## ✅ Server Status: RUNNING

**Server URL**: http://localhost:8080
**Web Server**: http://localhost:8082
**Status**: 🟢 Online and responding

### Recent API Calls
```
2026-02-17 02:40:31 - room.getRooms - SUCCESS (6µs)
```

## 🔍 Troubleshooting 403 Error

### Step 1: Verify Server is Running
```bash
curl -X POST http://localhost:8080/room/getRooms \
  -H "Content-Type: application/json" \
  -d "{}"
```

**Expected**: JSON array with 15 rooms
**Actual**: ✅ Working perfectly

### Step 2: Check Flutter App Configuration

The 403 error is likely caused by one of these issues:

#### Issue 1: Auth Still Enabled in main.dart
**Check**: `/lib/main.dart` line 36-42

**Should look like this** (NO auth):
```dart
client = Client(serverUrl)
  ..connectivityMonitor = FlutterConnectivityMonitor();

// Note: Authentication is disabled for development
// To enable auth, uncomment the following lines:
// ..authSessionManager = FlutterAuthSessionManager();
// client.auth.initialize();
```

**If it looks like this** (WITH auth - WRONG):
```dart
client = Client(serverUrl)
  ..connectivityMonitor = FlutterConnectivityMonitor()
  ..authSessionManager = FlutterAuthSessionManager(); // ❌ Remove this

client.auth.initialize(); // ❌ Remove this
```

#### Issue 2: Old Build Cache
Sometimes Flutter caches the old code. Try:
```bash
cd room_rental_flutter
flutter clean
flutter pub get
flutter run
```

#### Issue 3: Wrong Server URL
**Check**: `assets/config.json`

Should contain:
```json
{
  "SERVER_URL": "http://localhost:8080"
}
```

### Step 3: Test the Flutter App

1. **Stop the app** (if running)
2. **Clean and rebuild**:
   ```bash
   cd room_rental_flutter
   flutter clean
   flutter pub get
   ```
3. **Run the app**:
   ```bash
   flutter run
   ```
4. **Watch the server logs** for incoming requests

### Step 4: Check Server Logs

When you run the Flutter app and navigate to the Home screen, you should see this in the server terminal:

```
TIME                        ID         TYPE           CONTEXT                  DETAILS
--------------------------- ---------- -------------- ------------------------ ------------------------------
2026-02-17 XX:XX:XX.XXXXXX  XXXXXXXXX METHOD         room.getRooms            user=null, queries=0, duration=Xµs
```

**If you see**:
- ✅ `room.getRooms` with `user=null` → Success!
- ❌ `403 Forbidden` → Auth is still enabled
- ❌ No logs at all → App isn't connecting to server

## 🔧 Quick Fixes

### Fix 1: Ensure Auth is Disabled

Edit `/lib/main.dart`:
```dart
// Remove or comment out these lines:
// ..authSessionManager = FlutterAuthSessionManager();
// client.auth.initialize();
```

### Fix 2: Force Clean Rebuild
```bash
cd room_rental_flutter
flutter clean
rm -rf build/
rm -rf .dart_tool/
flutter pub get
flutter run
```

### Fix 3: Check Network Configuration

If running on a physical device, change `localhost` to your computer's IP:

1. Find your IP:
   ```bash
   ifconfig | grep "inet " | grep -v 127.0.0.1
   ```

2. Update `assets/config.json`:
   ```json
   {
     "SERVER_URL": "http://192.168.x.x:8080"
   }
   ```

## 📊 Expected Behavior

### When App Works Correctly:

1. **Splash Screen** (3 seconds)
   - Green background
   - White app icon
   - Fade-in animation

2. **Login Screen**
   - Email: test@example.com (pre-filled)
   - Password: password123 (pre-filled)
   - Click "Sign In"

3. **Home Screen**
   - Shows "Jakarta, Indonesia"
   - Displays search bar
   - Shows category chips
   - **Loads 15 room cards** ✅
   - **NO 403 ERROR** ✅

### Server Logs Should Show:
```
room.getRooms - user=null - SUCCESS
```

## 🐛 Common Errors

### Error: "Failed to connect to localhost:8080"
**Cause**: Server not running
**Fix**: 
```bash
cd room_rental_server
dart bin/main.dart
```

### Error: "403 Forbidden"
**Cause**: Authentication still enabled in client
**Fix**: Remove `authSessionManager` from `main.dart`

### Error: "Connection refused"
**Cause**: Wrong server URL or port
**Fix**: Check `assets/config.json` has correct URL

### Error: "No data displayed"
**Cause**: API call failing silently
**Fix**: Check server logs for errors

## ✅ Verification Checklist

Before running the app, verify:

- [ ] Server is running (`dart bin/main.dart`)
- [ ] Server shows "Webserver listening on http://localhost:8082"
- [ ] `curl` test returns 15 rooms
- [ ] `main.dart` has NO `authSessionManager`
- [ ] `main.dart` has NO `client.auth.initialize()`
- [ ] `assets/config.json` has correct SERVER_URL
- [ ] Flutter dependencies installed (`flutter pub get`)

## 🎯 Next Steps

1. **Verify main.dart** - Ensure auth is disabled
2. **Clean rebuild** - `flutter clean && flutter pub get`
3. **Run the app** - `flutter run`
4. **Watch server logs** - Look for `room.getRooms` requests
5. **Test login** - Use pre-filled credentials
6. **Check home screen** - Should show 15 rooms

---

**Server Status**: 🟢 RUNNING
**API Status**: ✅ WORKING
**Last Tested**: 2026-02-17 09:40 AM
**Next Action**: Run `flutter clean && flutter pub get && flutter run`
