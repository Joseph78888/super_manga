import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/main_scaffold.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/browse/presentation/browse_screen.dart';
import '../../features/library/presentation/library_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/detail/presentation/detail_screen.dart';
import '../../features/reader/presentation/reader_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/auth/presentation/auth_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

/// Centralized router configuration using [GoRouter] and [StatefulShellRoute]
/// for persistent bottom navigation.
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  redirect: (context, state) {
    final session = Supabase.instance.client.auth.currentSession;
    final isAuthRoute = state.matchedLocation == '/auth';

    if (session == null && !isAuthRoute) {
      return '/auth';
    } else if (session != null && isAuthRoute) {
      return '/';
    }

    return null;
  },
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScaffold(navigationShell: navigationShell);
      },
      branches: [
        // Tab 1: Home
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
          ],
        ),
        // Tab 2: Browse
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/browse',
              builder: (context, state) => const BrowseScreen(),
            ),
          ],
        ),
        // Tab 3: Search
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/library',
              builder: (context, state) => const LibraryScreen(),
            ),
          ],
        ),
        // Tab 4: Library
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/detail/:mangaId',
      builder: (context, state) {
        final mangaId = state.pathParameters['mangaId']!;
        return DetailScreen(mangaId: mangaId);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/reader/:chapterId',
      builder: (context, state) {
        final chapterId = state.pathParameters['chapterId']!;
        final chapterNumber = state.uri.queryParameters['chapterNumber'] ?? '';
        return ReaderScreen(chapterId: chapterId, chapterNumber: chapterNumber);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/auth',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const AuthScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
  ],
);
