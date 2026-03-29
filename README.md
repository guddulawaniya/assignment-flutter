# Movie Discovery App 🎬

A modern, high-performance Movie Discovery application built with **Flutter**. This project provides a seamless user experience for exploring trending movies, searching the TMDB database, and managing a personal favorites list with persistent storage and fluid transitions.

## 🚀 Features

-   **Trending Movies**: Explore the most popular movies of the week on a beautiful grid with infinite scrolling.
-   **Deep Search**: Powerful search functionality with debouncing to find any movie by title or keyword.
-   **Movie Details**: Detailed view including:
    -   High-resolution backdrop and poster imagery.
    -   Movie overview, tagline, and cast members.
    -   Technical details (Budget, Revenue, Status, and Language).
    -   **Similar Movies**: Discover related content directly from the detail screen.
-   **Favorites System**: Save your favorite movies locally using `shared_preferences` for offline access.
-   **Modern UI/UX**:
    -   **Shared Element Transitions**: Smooth Hero animations when switching between list and detail views.
    -   **Dual Theme**: Full support for High-Contrast Light and Sleek Dark modes.
    -   **Responsive Design**: Flexible grid layouts that prevent overflow across various screen sizes.
-   **Robust Performance**: Optimized image caching using `cached_network_image` and resilient error handling for network failures.

## 🛠️ Technology Stack

-   **Language**: Dart
-   **Framework**: [Flutter](https://flutter.dev/)
-   **State Management**: `Provider` (Clean and scalable)
-   **API**: [TMDB (The Movie Database)](https://www.themoviedb.org/)
-   **Storage**: [shared_preferences](https://pub.dev/packages/shared_preferences) for persistent favorites.
-   **Networking**: [http](https://pub.dev/packages/http) and [cached_network_image](https://pub.dev/packages/cached_network_image).

## 📥 Installation

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/guddulawaniya/assignment-flutter.git
    cd assignment-flutter
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run the application**:
    ```bash
    flutter run
    ```

## 🏗️ Project Structure

```text
lib/
├── api/          # Network service and TMDB integration
├── features/     # Feature-based architecture (Home, Favorites, Detail)
├── services/     # Core services (Storage, Logging)
├── shared/       # Reusable components, constants, and theme tokens
├── store/        # State management (MovieStore, AppStore)
└── main.dart     # Application entry point and router
```

## 🔐 Release Configuration

The production APK is pre-tuned for network stability:
-   **Permissions**: `INTERNET`, `ACCESS_NETWORK_STATE`, and `CHANGE_NETWORK_STATE` are enabled.
-   **Security**: Enabled `usesCleartextTraffic` to ensure seamless asset loading across varying network standards.

## 📄 Assignment Details

This application was developed as a high-fidelity port of a React Native movie discovery assignment, focusing on native-level performance and smooth "instant-feel" UI interactions.

---
Developed by **Guddu Lawaniya**
