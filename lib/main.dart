import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://biobfkobysywzkgnlifw.supabase.co',
    anonKey: 'sb_publishable_SpU6zPB3-7Be0K2ayfohuQ_MnpVC603',
  );
  runApp(const SuperMangaApp());
}

/// The root widget of the Super Manga application.
class SuperMangaApp extends StatelessWidget {
  const SuperMangaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Super Manga',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: appRouter,
    );
  }
}
