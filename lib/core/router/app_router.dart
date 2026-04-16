import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/main_scaffold.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/browse/presentation/browse_screen.dart';
import '../../features/library/presentation/library_screen.dart';
import '../../features/search/presentation/search_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Centralized router configuration using [GoRouter] and [StatefulShellRoute]
/// for persistent bottom navigation.
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScaffold(navigationShell: navigationShell);
      },
      branches: [
        // Tab 1: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomeScreen(),
            ),
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
              path: '/search',
              builder: (context, state) => const SearchScreen(),
            ),
          ],
        ),
        // Tab 4: Library
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/library',
              builder: (context, state) => const LibraryScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
