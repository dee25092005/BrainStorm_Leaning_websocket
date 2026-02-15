# BrainStorm Live

## Project Goal
A real-time brainstorming application. Users can post ideas and vote on them. The system uses a Go backend for high-performance data handling and Flutter for a cross-platform, reactive UI.

## Current Stage
### Backend (Go)
- [x] Core Engine: WebSocket Hub and Client logic implemented.
- [x] Data Persistence: Full GORM integration with PostgreSQL.
- [x] Service Layer: Modular BrainstormService for clean business logic.
- [x] CRUD Operations: Real-time creation, voting, and permanent deletion.

### Frontend (Flutter)
- [x] Reactive UI: Implementation of ImplicitlyAnimatedList for smooth sorting.
- [x] UX/UI: Custom IdeaCard components with Slide-to-Dismiss functionality.ChangeNotifier.
- [x] State Management: Provider-driven architecture with WebSocket synchronization.
- [x] Optimistic UI: Instant local state updates for a "Zero-Lag" feel.

### How to run
- Backend: Configure your .env for PostgreSQL and run go run cmd/server/main.go.
- Frontend: Update your WebSocket URI in the provider and run flutter run.

## Tech Stack
- **Language:** Go (Golang), Dart
- **Framework:** Flutter
- **State Management:** Provider
- **Communication:** WebSockets
