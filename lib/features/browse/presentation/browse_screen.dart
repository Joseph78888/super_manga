import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/manga_poster_card.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/browse_cubit.dart';
import 'cubit/browse_state.dart';

class BrowseScreen extends StatelessWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BrowseCubit(),
      child: const BrowseView(),
    );
  }
}

class BrowseView extends StatelessWidget {
  const BrowseView({super.key});

  final List<String> genres = const ['All', 'Action', 'Romance', 'Fantasy', 'Sci-Fi', 'Mystery'];
  final List<String> sortOptions = const ['Popular', 'Latest', 'Rating', 'New'];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MangaAppColors>()!;
    
    // Mock Data mimicking the image layout
    final browseItems = [
      {'title': 'Shadow Monarch', 'author': 'Chugong', 'tag': 'MANHWA', 'rating': '4.9', 'chapter': 'Ch.179', 'gradient': colors.trendingBlue},
      {'title': 'Crimson Blade Chronicles', 'author': 'Hajime Isayama', 'tag': 'MANGA', 'rating': '4.8', 'chapter': 'Ch.139', 'gradient': colors.trendingRed},
      {'title': 'Infinite Dungeon', 'author': 'Kim Dae-Jin', 'tag': 'MANHWA', 'rating': '4.7', 'chapter': 'Ch.94', 'gradient': colors.trendingGreen},
      {'title': 'Phantom Guild', 'author': 'Mashima Hiro', 'tag': 'MANGA', 'rating': '4.6', 'chapter': 'Ch.545', 'gradient': colors.trendingOrange},
      {'title': 'Neon Requiem', 'author': 'Park Taejun', 'tag': 'MANHWA', 'rating': '4.8', 'chapter': 'Ch.67', 'gradient': colors.trendingMagenta},
      {'title': 'Celestial Academy', 'author': 'Yuki Tabata', 'tag': 'MANGA', 'rating': '4.5', 'chapter': 'Ch.212', 'gradient': colors.trendingTeal},
      {'title': 'The Void Sovereign', 'author': 'Chen Wei', 'tag': 'MANHUA', 'rating': '4.7', 'chapter': 'Ch.134', 'gradient': colors.trendingGreen}, // Reuse green
      {'title': 'Scarlet Dusk', 'author': 'Oda Eiichiro', 'tag': 'MANGA', 'rating': '4.9', 'chapter': 'Ch.1089', 'gradient': colors.trendingOrange}, // Reuse orange
      {'title': 'Blood Moon Rising', 'author': 'Kim So-yeon', 'tag': 'MANHWA', 'rating': '4.6', 'chapter': 'Ch.48', 'gradient': colors.trendingRed}, // Reuse red
      {'title': 'Iron Fist Chronicles', 'author': 'Gege Akutami', 'tag': 'MANGA', 'rating': '4.8', 'chapter': 'Ch.236', 'gradient': colors.trendingTeal}, // Reuse teal
    ];

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Browse',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1A33),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Genre Filters
            SliverToBoxAdapter(
              child: SizedBox(
                height: 40,
                child: BlocBuilder<BrowseCubit, BrowseState>(
                  builder: (context, state) {
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      scrollDirection: Axis.horizontal,
                      itemCount: genres.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final genre = genres[index];
                        final isSelected = genre == state.selectedGenre;
                        return GestureDetector(
                          onTap: () => context.read<BrowseCubit>().changeGenre(genre),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? AppTheme.accentRed : const Color(0xFF1A1A2E), // Dark purple/blue tint
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              genre,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            
            // Sort Options Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: BlocBuilder<BrowseCubit, BrowseState>(
                        builder: (context, state) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: sortOptions.map((opt) {
                              final isSelected = opt == state.selectedSort;
                              return GestureDetector(
                                onTap: () => context.read<BrowseCubit>().changeSortOption(opt),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: isSelected ? 
                                    BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12)
                                    ) : null,
                                  child: Text(
                                    opt,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
                                      fontSize: 14,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(width: 1, height: 16, color: Colors.white.withOpacity(0.2)),
                    const SizedBox(width: 16),
                    Text(
                      '10 titles',
                      style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            
            // Grid View
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.65, // Adjust this to match the card proportion
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = browseItems[index];
                    return MangaPosterCard(
                      title: item['title'] as String,
                      author: item['author'] as String,
                      tag: item['tag'] as String,
                      rating: item['rating'] as String,
                      chapter: item['chapter'] as String,
                      gradientColors: item['gradient'] as List<Color>,
                      width: null, // Allow it to fill the grid cell
                      height: null,
                    );
                  },
                  childCount: browseItems.length,
                ),
              ),
            ),
            
            // Bottom Padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 32),
            ),
          ],
        ),
      ),
    );
  }
}
