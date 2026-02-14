# BrainStorm Live

## Project Goal
A real-time brainstorming application. Users can post ideas and vote on them. The system uses a Go backend for high-performance data handling and Flutter for a cross-platform, reactive UI.

## Current Stage
### Backend (Go)
- [x] Basic HTTP server setup.
- [x] WebSocket Hub and Client logic implemented.
- [x] Environment variable configuration (.env).
- [x] Database integration (GORM/PostgreSQL) - *Next Priority*.

### Frontend (Flutter)
- [x] Idea model with JSON serialization.
- [x] State management using Provider and ChangeNotifier.
- [x] Main screen UI with reactive ListView.
- [x] Custom IdeaCard component for clean UI.
- [ ] WebSocket service connection to Go server.

## Tech Stack
- **Language:** Go (Golang), Dart
- **Framework:** Flutter
- **State Management:** Provider
- **Communication:** WebSockets
