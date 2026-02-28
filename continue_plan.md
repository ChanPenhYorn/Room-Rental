Great 🔥 your plan is already very strong.
Now let’s **upgrade your AI prompt** so it can generate a production-ready Dwellly App (Flutter + Serverpod) with proper auth, realistic mock data, and full working flow.

Below is your **improved master prompt** 👇 — structured, clear, and optimized for code generation.

---

# 🚀 IMPROVED MASTER PROMPT (Production-Level)

Use this when generating the complete system.

---

## 🧠 ROLE

You are a senior Flutter + Serverpod architect.

Generate a complete production-ready Dwellly App using:

* Flutter (Clean Architecture)
* Riverpod (state management)
* Freezed (immutable models)
* Json Serializable
* Serverpod backend
* PostgreSQL
* Realistic mock seed data

The project already contains:

* UI for most screens
* Basic Room & Booking models
* Server running on port 9080
* Some mock data

Now we need to implement:

* Full Authentication System
* Proper User Roles (Tenant / Owner)
* Realistic relational database models
* Seed data
* Complete working flow end-to-end

---

# 🏗 ARCHITECTURE REQUIREMENTS

## Flutter Structure (STRICT)

```
lib/
 ├── core/
 ├── config/
 ├── features/
 │    ├── auth/
 │    ├── rooms/
 │    ├── booking/
 │    ├── bills/
 │    ├── chat/
 │    ├── favorites/
 │    ├── profile/
 │    ├── owner/
 └── main.dart
```

Each feature must contain:

```
data/
domain/
presentation/
```

Use:

* Repository pattern
* UseCases
* DTO → Entity mapping
* AsyncValue for Riverpod states
* Proper loading & error states

---

# 🔐 PHASE 1 — AUTHENTICATION (START HERE)

## Requirements

Implement full authentication using Serverpod:

### User Roles

* Tenant
* Owner

### User Model Fields

* id
* email
* passwordHash
* fullName
* phone
* role (enum)
* profileImage
* createdAt

### Endpoints Required

* register()
* login()
* logout()
* getCurrentUser()
* updateProfile()

### Important

* Use session-based auth (Serverpod session)
* Password hashing (bcrypt)
* Role-based access
* Protect owner-only endpoints
* Automatically attach session to client

---

# 🗃 DATABASE MODELS (COMPLETE)

Create all missing models with relations:

## Room

* id
* ownerId (User relation)
* title
* description
* price
* location
* latitude
* longitude
* rating
* type (studio, 1br, 2br, dormitory)
* createdAt

## Booking

* id
* roomId
* tenantId
* startDate
* endDate
* status (active, completed, cancelled)
* totalAmount

## Contract

* id
* bookingId
* signedAt
* contractText
* status

## Bill

* id
* contractId
* amount
* dueDate
* status (paid, unpaid)

## ChatMessage

* id
* senderId
* receiverId
* message
* sentAt
* isRead

## Favorite

* id
* userId
* roomId

## Review

* id
* roomId
* userId
* rating
* comment

## Facility

* id
* name
* icon
* RoomFacility (many-to-many)

---

# 🌱 REALISTIC MOCK SEED DATA

Generate seed data on server start.

## Users

* 3 Tenants
* 2 Owners

## Rooms (15 total)

Locations:

* DHA
* Gulberg
* Model Town
* Johar Town
* Bahria Town

Prices:

* $100 – $600

Types:

* Studio
* 1BR
* 2BR
* Dormitory

Ratings:

* 4.0 – 5.0

Include:

* Latitude/Longitude
* 5–8 facilities per room

## Bookings

* 5 active
* 3 completed

## Bills

* 10 paid
* 5 unpaid

## Chats

* 3 conversations with 5–10 messages each

## Contracts

* 2 active contracts

---

# 🧭 COMPLETE WORKING FLOW

Ensure:

1. Splash → Check session → Navigate
2. Login → Save session → Navigate to Home
3. Tenant:

   * Browse rooms
   * Filter/search
   * View detail
   * Book
   * Payment
   * Contract auto-generated
   * Bills created
4. Owner:

   * Add property
   * View bookings
   * Manage rooms

Everything must connect to real API (no fake UI-only state).

---

# 🗺 SEARCH & FILTER

Implement:

* Search by title & location
* Filter by:

  * Price range
  * Type
  * Rating
  * Facilities
* Map view using coordinates

---

# 💬 CHAT SYSTEM

* Real-time polling (or simple refresh)
* Mark as read
* Group by conversation

---

# 🧪 VALIDATION

* Form validation
* Proper error messages
* Loading spinners
* Empty states
* Network failure handling

---

# 🧱 CLEAN CODE RULES

* No business logic in UI
* Use UseCases
* Repositories must abstract data source
* DTO != Entity
* No direct Serverpod calls inside UI

---

# 🧩 DELIVERABLE FORMAT

Generate:

1. Serverpod protocol files
2. Endpoints
3. Seed script
4. Flutter data layer
5. Domain layer
6. Presentation layer
7. Riverpod providers
8. Navigation setup
9. Auth guard logic

Generate step-by-step in logical order.

Start from AUTH SYSTEM first.

---

# 📌 QUESTIONS I NEED FROM YOU

Before generating full system, confirm:

1. Should we use:

   * Serverpod built-in auth module?
   * Or custom authentication system?

2. Should booking create:

   * Contract automatically?
   * Or require owner approval?

3. Payment:

   * Mock only?
   * Or simulate gateway response?

4. Chat:

   * Real-time via WebSocket?
   * Or polling every X seconds?

Answer these 4 so we build it correctly.

---

# 🎯 Why This Prompt Is Better

Your old prompt:

* Focused on UI
* Not structured for backend logic
* Not role-based
* Not relationally complete

This version:

* Forces clean architecture
* Forces real database design
* Forces working flow
* Forces realistic seed data
* Forces session auth
* Forces proper separation

---

