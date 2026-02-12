# Production-Grade Flutter Sample: Clean Architecture & Riverpod

[![Flutter](https://img.shields.io/badge/Flutter-v3.22+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A comprehensive, senior-level demonstration of **Clean Architecture** and **Riverpod** in Flutter. This project is built to showcase production-standard software engineering practices, prioritizing **scalability**, **testability**, and **maintainability**.

---

## Architectural Blueprint

The project follows a strict **Clean Architecture** pattern, ensuring the business logic remains independent of UI, databases, and external frameworks.

### 1. Domain Layer (The Core)
- **Entities**: Pure data models with no external dependencies.
- **Repositories (Interfaces)**: Abstractions defining data operations.
- **Use Cases**: Encapsulated business logic focusing on specific user actions.

### 2. Data Layer (The Infrastructure)
- **Models (DTOs)**: Data Transfer Objects with JSON serialization logic.
- **Repositories (Implementations)**: Orchestrates data flow between multiple sources.
- **Data Sources**: Low-level implementations for Remote (Rest API) and Local (SharedPreferences/SecureStorage) data.

### 3. Presentation Layer (The UI)
- **State Management**: Leveraging **Riverpod** (StateNotifier) for predictable, unidirectional data flow.
- **View Logic**: Decoupled from state management using controllers/notifiers.
- **Routing**: Sophisticated navigation with **GoRouter**, including deep-linking and auth-guards.

---

## Key Feature Implementations

- **Robust Authentication**: Full auth cycle featuring session restoration, secure token persistence using AES encryption (platform-native), and automatic redirection via navigation guards.
- **Offline-First Strategy**: Implements a high-performance synchronization logic. The app serves cached data immediately for a "zero-latency" feel while updating from the remote source in the background.
- **Paginated Infinite Scrolling**: Custom pagination implementation with pull-to-refresh, loading-more indicators, and granular retry handling for intermittent network failures.
- **Functional Error Handling**: Utilizing `fpdart` (functional programming) for `Either<Failure, Success>` patterns. This replaces traditional try-catch blocks with explicit, compile-time enforced error handling.
- **Professional Observability**: Centralized logging system (`AppLogger`) and a mocked `AnalyticsService` abstraction to demonstrate data-driven development mindset.

---

## Tech Stack & Tools

- **State Management**: `flutter_riverpod` (Standard for modular Flutter apps).
- **Navigation**: `go_router` (Declarative routing with state integration).
- **Network**: `dio` (Customized with interceptors for auth and error mapping).
- **Functional Programming**: `fpdart` (Bringing Type-safety and functional patterns to Dart).
- **Persistence**: `shared_preferences` & `flutter_secure_storage`.
- **Testing**: `mocktail` for high-quality widget and unit testing.

---

## Project Structure

```text
lib/
 ├── core/              # Global infrastructure (network, storage, di, router, etc.)
 ├── features/
 │   ├── auth/          # Authentication feature module
 │   │   ├── data/      # Models, Repositories, DataSources
 │   │   ├── domain/    # Entities, Use cases, Repository Interfaces
 │   │   └── presentation/ # UI Screens, Providers (State management)
 │   └── posts/         # Paginated posts feature module
 └── main.dart          # Entry point and global dependency overrides
```

---

## Getting Started

### Prerequisites
- Flutter SDK `3.22.0` or higher
- Dart SDK `3.4.0` or higher

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/aashirawan44/flutter_production_sample.git
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the development environment:
   ```bash
   flutter run
   ```

---

## License

Distributed under the MIT License. See `LICENSE` for more information.

---

## Author

**Aashir Awan** - [LinkedIn](https://www.linkedin.com/in/muhammad-aashir-bilal/) | [GitHub](https://github.com/aashirawan44)
