import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/datasources/manga_remote_data_source.dart';
import '../data/repositories/manga_repository.dart';
import 'cubit/home_cubit.dart';
import 'cubit/home_state.dart';
import 'widgets/featured_carousel.dart';
import 'widgets/trending_list.dart';
import 'widgets/recently_updated_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(
        mangaRepository: MangaRepository(
          dataSource: SupabaseMangaRemoteDataSource(
            supabaseClient: Supabase.instance.client,
          ),
        ),
      )..loadMangas(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good morning',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Super Manga',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => context.push('/profile'),
                      child: const CircleAvatar(
                        radius: 22,
                        backgroundColor: Color(0xFF1E1A33),
                        child: Icon(Icons.person, color: Colors.white54),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return switch (state) {
                    HomeInitial() || HomeLoading() => const SizedBox(
                      height: 300,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    HomeError(:final message) => SizedBox(
                      height: 300,
                      child: Center(
                        child: Text(
                          'Failed to load: $message',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    HomeLoaded state => Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: Column(
                        children: [
                          FeaturedCarousel(manga: state.featuredManga),
                          const SizedBox(height: 24),
                          if (state.trendingMangas.isNotEmpty)
                            TrendingList(mangas: state.trendingMangas),
                          const SizedBox(height: 24),
                          if (state.recentMangas.isNotEmpty)
                            RecentlyUpdatedList(mangas: state.recentMangas),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
