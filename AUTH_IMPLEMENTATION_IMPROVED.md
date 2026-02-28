Absolutely ✅ Here’s your **Improved Auth Implementation Plan** in Markdown format.

You can save this as:

```
AUTH_IMPLEMENTATION_IMPROVED.md
```

---

# 🔐 Dwellly App — Auth Improvement Plan

---

## 📌 Goal

Restrict login so **only registered users** can log in.
Seed first user automatically.

---

## 🎯 Requirements

1. Replace current “any credential works” behavior.
2. Login flow must:

   * Validate email exists in the database.
   * Compare password hash using bcrypt.
   * Return proper session on success.
   * Return error on failure.
3. Seed **first user** automatically:

   * **Email:** [test@example.com](mailto:test@example.com)
   * **Password:** password123
   * **Role:** tenant
4. Session stores:

   * userId
   * email
   * userRole
5. Passwords **never stored in plain text**.
6. Future registrations also hash passwords before storing.

---

## 🗂 Backend Endpoints

### 1. `register()`

* Input: email, password, fullName, role
* Action:

  * Check if email exists
  * Hash password (bcrypt)
  * Save user
* Return: user info (without password)

### 2. `login()`

* Input: email, password
* Action:

  * Find user by email
  * Compare hashed password
  * If valid → create session → return user info
  * Else → return error: “Invalid credentials”

---

## ✅ Improvements for AI

* Restrict login to **existing users only**
* Seed first user automatically on server start
* Proper password hashing
* Return standardized error messages
* Session management attaches user info: `userId`, `email`, `role`
* Keep **Clean Architecture**:

  * Repository layer handles data
  * UseCase layer handles business logic
  * No business logic in UI

---

## 💡 Optional Enhancements

* Limit login attempts per email
* Add email verification in the future
* Role-based access for future endpoints

---

## 🔑 Example Prompt for AI

> “Update the auth system. Currently login accepts any credential. Implement proper login where only registered users can log in. Use bcrypt password hashing. Seed first user: email `test@example.com`, password `password123`, role `tenant`. Ensure session stores userId, email, and role. Return proper error for invalid credentials. Keep clean architecture, no business logic in UI, use repository and use case layers.”

---

This is ready for AI to **implement restricted login** with **first user seeded** and proper session handling.
