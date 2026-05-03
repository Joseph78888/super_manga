# SuperManga 📚

![SuperManga Banner](file:///C:/Users/YOUSIF/.gemini/antigravity/brain/846b1b38-bc20-42d4-9541-9c1cd7c1c6c4/super_manga_banner_1777784415696.png)

SuperManga is a high-performance, premium manga reader application built with Flutter. It offers a seamless reading experience with a modern UI, robust state management, and a powerful Supabase-backed infrastructure.

## ✨ Key Features

-   **🔒 Secure Authentication**: Seamless login via **Supabase Auth** and **Google Sign-In**. Supports **Guest Mode** for immediate access.
-   **📖 Immersive Reader**: A feature-rich reader with:
    -   High-resolution image support with `photo_view`.
    -   **Advanced Edge Fades**: Subtle top/bottom gradients for distraction-free reading.
    -   Smooth chapter navigation and pagination.
-   **🎨 Premium Aesthetics**: 
    -   Full **Dark Mode** support.
    -   Dynamic animations using `flutter_animate`.
    -   Modern typography with **Google Fonts**.
-   **📂 Personal Library**: Save and organize your favorite manga in your private collection.
-   **🔍 Powerful Search & Browse**: Discover new content using advanced filters and fast search indexing.
-   **⚡ Offline Ready**: Local data persistence using **SQLite** and `shared_preferences`.
-   **📱 Cross-Platform**: Optimized for a native experience on both Android and iOS.

---

## 🛠️ Tech Stack

| Category           | Technology                                                                 |
| :----------------- | :------------------------------------------------------------------------- |
| **Framework**      | [Flutter](https://flutter.dev/)                                            |
| **Language**       | [Dart](https://dart.dev/)                                                  |
| **Backend/Auth**   | [Supabase](https://supabase.com/)                                          |
| **State Management**| [Bloc / Cubit](https://pub.dev/packages/flutter_bloc)                     |
| **Navigation**     | [GoRouter](https://pub.dev/packages/go_router)                            |
| **Database**       | [SQLite](https://pub.dev/packages/sqflite)                                |
| **Networking**     | [Dio](https://pub.dev/packages/dio)                                       |
| **Animations**     | [Flutter Animate](https://pub.dev/packages/flutter_animate)               |

---

## 🏗️ Architecture

The project follows a **Feature-based Clean Architecture** to ensure scalability and maintainability:

```text
lib/
├── core/             # Shared utilities, themes, and router
│   ├── constants/    # Global constants
│   ├── router/       # GoRouter configuration
│   ├── theme/        # App-wide design system
│   └── widgets/      # Reusable UI components
└── features/         # Modular feature-specific folders
    ├── auth/         # Authentication & Guest Mode
    ├── home/         # Discovery & Dashboard
    ├── reader/       # Manga reading logic & UI
    ├── library/      # User collection management
    └── ...           # Browse, Search, Profile, Settings
```

---

## 🚀 Getting Started

### Prerequisites

-   Flutter SDK: `^3.9.2`
-   Supabase Account

### Installation

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/yourusername/SuperManga.git
    cd SuperManga/super_manga
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Setup Environment Variables**:
    Create a `.env` file in the `super_manga/` directory and add your Supabase credentials:
    ```env
    SUPABASE_URL=your_supabase_project_url
    SUPABASE_ANON_KEY=your_supabase_anon_key
    ```

4.  **Run the application**:
    ```bash
    flutter run
    ```

---

## 🧪 Code Quality & Tests

To run the linter and analyze the project:
```bash
flutter analyze
```

To run unit and widget tests:
```bash
flutter test
```

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

---

<p align="center">
  Built with ❤️ by the SuperManga Team
</p>
