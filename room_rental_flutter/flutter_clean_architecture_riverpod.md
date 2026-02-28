# Flutter Clean Architecture + Riverpod (Feature-Based)

## Folder Structure & Development Guide

This document defines a **scalable, feature-first architecture** with **complete test coverage**, optimized for the current project:

* **Feature-Based Clean Architecture**
* **SOLID Principles**
* **Riverpod (Code Generation & Notifiers)**
* **Mockito** for robust dependency isolation
* **Unified UI Library** in `shared/`

---

## 📁 lib/ Directory Structure

The project follows a **Feature-Based** approach where each functional area is self-contained.

```text
lib/
├── core/               # App-wide logic (Router, Theme, Localization, Network)
│   ├── constants/      # App-wide constants & assets
│   ├── network/        # API Service & Endpoints
│   ├── security/       # JWT & Encryption logic
│   └── utils/          # Global extensions & helpers
│
├── features/           # Self-contained business features
│   └── <feature_name>/ # e.g., auth, dashboard, payment
│       ├── data/       # DTOs, Mappers, Remote/Local DataSources
│       ├── domain/     # Logic-less Entities, Repository Interfaces, UseCases
│       └── presentation/
│           ├── controllers/ # Riverpod Notifiers (Logic & State)
│           └── views/       # UI Screens & feature-specific widgets
│
├── shared/             # Reusable UI components & models across features
│   ├── widgets/        # Global UI library (Buttons, Dialogs)
│   ├── models/         # Shared DTOs
│   └── entities/       # Shared business objects (e.g., ReceiptEntity)
│
├── app.dart            # Main App Shell (Theme, Router config)
└── main.dart           # Production Entry point
```

---

## 📁 test/ Directory Structure

Tests are organized to mirror the `lib/` structure for easy navigation.

```text
test/
├── features/           # Feature tests
│   └── <feature_name>/
│       ├── data/       # Repository implementation & DataSource tests
│       ├── domain/     # UseCase tests
│       └── presentation/
│           ├── controllers/ # Notifier tests
│           └── views/       # Widget tests
│
├── mocks/              # Shared mock objects (Mockito)
│   ├── <feature>/      # Feature-specific mocks
│   └── shared/         # Common mocks (HttpClient, etc.)
│
└── test_helper.dart    # Shared testing utilities
```

---

## 📦 Key Dependencies

```yaml
dependencies:
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  http: ^1.2.2

dev_dependencies:
  mockito: ^5.4.4
  riverpod_generator: ^2.4.3
```

---

## 🧪 Mocking Example (Mockito)

### `test/mocks/auth/mock_auth_repository.dart`

```dart
import 'package:mockito/annotations.dart';
import 'package:new_mb_small_task/features/auth/domain/repositories/auth_repository.dart';

@GenerateMocks([AuthRepository])
void main() {}
```

---

## 1️⃣ Domain Layer Test (UseCase)

📍 `test/features/auth/domain/login_usecase_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:new_mb_small_task/core/resources/data_state.dart';
import 'package:new_mb_small_task/features/auth/domain/usecases/login_usecase.dart';
import '../../../mocks/auth/mock_auth_repository.mocks.dart';

void main() {
  late MockAuthRepository mockRepository;
  late LoginUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });

  test('should call login on the repository', () async {
    when(mockRepository.login(phone: anyNamed('phone'), pin: anyNamed('pin')))
        .thenAnswer((_) async => DataSuccess({'token': 'mock_token'}));

    await useCase.execute(phone: '012345678', pin: '123456');

    verify(mockRepository.login(phone: '012345678', pin: '123456')).called(1);
  });
}
```

---

## 2️⃣ Presentation Layer Test (Riverpod Notifier)

📍 `test/features/auth/presentation/controllers/auth_notifier_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_mb_small_task/features/auth/presentation/controllers/auth_provider.dart';

void main() {
  test('initial state is idle', () {
    final container = ProviderContainer();
    final state = container.read(authNotifierProvider);
    expect(state.isLoading, false);
  });
}
```

---

## 🧠 Architecture Principles

| Layer        | Responsibility                                     | Constraint                               |
| ------------ | -------------------------------------------------- | ---------------------------------------- |
| **Domain**   | Pure Business Logic & Interfaces                   | **Zero** external dependencies (Flutter) |
| **Data**     | Network/Storage Implementation & Data Mapping      | Depends only on Domain                   |
| **Presentation** | UI Logic, State Management (Riverpod), and Widgets | Depends on Domain (UseCases)             |
| **Shared**   | Cross-feature UI components & Data Models          | Highly reusable, standalone              |

---

## ✅ Best Practices

1. **Use Riverpod Generator**: Always use `@riverpod` and run `build_runner`.
2. **Keep Entities Pure**: Domain entities should not have JSON logic; move that to Models.
3. **Mocks directory**: Keep all Mockito generated mocks in `test/mocks/` to avoid polluting feature folders.
4. **Shared Widgets**: Put universal UI like `AppButton` in `lib/shared/widgets/`.
