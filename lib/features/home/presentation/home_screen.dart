import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:multiavatar/multiavatar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../data/datasources/manga_remote_data_source.dart';
import '../data/repositories/manga_repository.dart';
import '../domain/manga.dart';
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

  List<Manga> _getMockMangas() {
    return List.generate(
      5,
      (index) => const Manga(
        id: 'mock-id',
        titleAr: 'عنوان وهمي',
        titleEn: 'Mock Title For Loading',
        coverUrl: 'https://via.placeholder.com/150',
        rating: 4.5,
        status: 'Ongoing',
        author: 'Mock Author',
        description:
            'This is a mock description that is long enough to show some skeleton text lines.',
        genres: [],
        createdAt: null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final seed =
        user?.userMetadata?['username'] as String? ?? user?.id ?? 'guest';
    final avatarSvg = multiavatar(seed);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final isLoading = state is HomeInitial || state is HomeLoading;

            final featuredMangas = state is HomeLoaded
                ? state.featuredMangas
                : _getMockMangas();
            final trendingMangas = state is HomeLoaded
                ? state.trendingMangas
                : _getMockMangas();
            final recentMangas = state is HomeLoaded
                ? state.recentMangas
                : _getMockMangas();
            final errorMessage = state is HomeError ? state.message : null;

            if (errorMessage != null) {
              return Center(
                child: Text(
                  'Failed to load: $errorMessage',
                  style: TextStyle(color: Colors.white.withOpacity(0.5)),
                  textAlign: TextAlign.center,
                ),
              );
            }

            return Skeletonizer(
              enabled: isLoading,
              effect: ShimmerEffect(
                baseColor: Colors.grey[900]!.withOpacity(0.5),
                highlightColor: Colors.grey[800]!.withOpacity(0.5),
              ),
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
                            child: CircleAvatar(
                              radius: 22,
                              backgroundColor: const Color(0xFF1E1A33),
                              child: ClipOval(
                                child: SvgPicture.string(
                                  avatarSvg,
                                  width: 44,
                                  height: 44,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: Column(
                        children: [
                          if (featuredMangas.isNotEmpty)
                            FeaturedCarousel(mangas: featuredMangas),
                          const SizedBox(height: 24),
                          if (trendingMangas.isNotEmpty)
                            TrendingList(mangas: trendingMangas),
                          const SizedBox(height: 24),
                          if (recentMangas.isNotEmpty)
                            RecentlyUpdatedList(mangas: recentMangas),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
